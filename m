Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36201 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbFOFgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 01:36:13 -0400
Received: by wigg3 with SMTP id g3so65295515wig.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 22:36:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557AFC9D.3020109@candelatech.com>
References: <5579F87F.4070601@candelatech.com>
	<557A1BE9.7070305@candelatech.com>
	<CA+BoTQkLyaP-2sHiu7Wn-ZzGj2JnZs4qzQKGu7PiTtUy4d9xLQ@mail.gmail.com>
	<557AFC9D.3020109@candelatech.com>
Date: Mon, 15 Jun 2015 07:36:11 +0200
Message-ID: <CA+BoTQkn+Ro1+=PPe=1aHT519jW3BtF+Mmspy+kQftufpUiTPA@mail.gmail.com> (sfid-20150615_073617_857559_988F656F)
Subject: Re: Question on beacon-miss offloading.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2015 at 17:37, Ben Greear <greearb@candelatech.com> wrote:
> On 06/11/2015 11:03 PM, Michal Kazior wrote:
>> On 12 June 2015 at 01:38, Ben Greear <greearb@candelatech.com> wrote:
>>> On 06/11/2015 02:07 PM, Ben Greear wrote:
>>>> In my ath10k CT firmware, I am disabling the beacon-miss offloading
>>>> to save space and because it will not work with lots of virtual
>>>> stations.
>>>>
>>>> But, it must be that I need some way to tell the stack that this
>>>> feature is not enabled, because when suddenly kill my AP, then
>>>> the ath10k station connected to it shows endless 'beacon loss' events
>>>> in 'iw events' output, but it never actually loses connection.
>>>>
>>>> Stock firmware works fine, so probably I just need to disable
>>>> some feature flag when registering the ath10k hardware
>>>> when using CT firmware.
>>>>
>>>> With stock firmware, I see a quick dissassociation due to inactivity.
>>>>
>>>> I am having poor luck finding how a driver tells the stack
>>>> it has beacon miss offload or not, so, does anyone know how
>>>> this is controlled?
>>>
>>> I still am not sure why stock firmware works, but it appears
>>> the reason mine is failing is that the ACK status for mgt frames
>>> is always set to TRUE since the ath10k wmi-mgt-tx API is so
>>> lame.  So, mac80211 does a probe, ath10k lies and says it was
>>> acked, and mac80211 then things all is well for another few
>>> seconds.
>>
>> mac80211 shouldn't do a Probe Req to an AP on beacon loss because
>> ath10k advertises it supports tx-status report. Hence mac80211 should
>> use NullFunc frames which shouldn't go through wmi-mgmt-tx but htt
>> tx-frm.
>>
>> But then again: NullFunc status reporting via htt tx-frm was broken on
>> 10.1 if memory serves right. I believe it was fixed in 10.2 or 10.2.4.
>>
>> This problem has been effectively obscured on stock 10.1 by the
>> offloaded beacon miss.
>
> Thanks for the hint.  I was able to fix my firmware to properly
> return htt tx status, and now it appears to work properly.
>
> A quick throughput test works as well, so hopefully no regressions.
>
> I guess the NulFunc related comment is incorrect for 10.1 stock firmware?
>
> Maybe some others?
>
> static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
> {
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>         int ret = 0;
>
>         if (ar->htt.target_version_major >= 3) {
>                 /* Since HTT 3.0 there is no separate mgmt tx command */
>                 ret = ath10k_htt_tx(&ar->htt, skb);
>                 goto exit;
>         }
>
>         if (ieee80211_is_mgmt(hdr->frame_control)) {
>                 if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
>                              ar->fw_features)) {
>                         if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
>                             ATH10K_MAX_NUM_MGMT_PENDING) {
>                                 ath10k_warn(ar, "reached WMI management transmit queue limit\n");
>                                 ret = -EBUSY;
>                                 goto exit;
>                         }
>
>                         skb_queue_tail(&ar->wmi_mgmt_tx_queue, skb);
>                         ieee80211_queue_work(ar->hw, &ar->wmi_mgmt_tx_work);
>                 } else {
>                         ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
>                 }
>         } else if (!test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
>                              ar->fw_features) &&
>                    ieee80211_is_nullfunc(hdr->frame_control)) {
>                 /* FW does not report tx status properly for NullFunc frames
>                  * unless they are sent through mgmt tx path. mac80211 sends
>                  * those frames when it detects link/beacon loss and depends
>                  * on the tx status to be correct. */
>                 ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
>         } else {
>                 ret = ath10k_htt_tx(&ar->htt, skb);
>         }

The NullFunc workaround was originally done for 999.999.0.636 but
should be true for 10.1 as well with the sole exception the latter
doesn't have htt-mgmt-tx to workaround the problem.


Michał

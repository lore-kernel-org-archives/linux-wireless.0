Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34178 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbFPF3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:29:38 -0400
Received: by wgv5 with SMTP id 5so3916762wgv.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 22:29:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557F2B43.8060409@candelatech.com>
References: <5579F87F.4070601@candelatech.com>
	<557A1BE9.7070305@candelatech.com>
	<CA+BoTQkLyaP-2sHiu7Wn-ZzGj2JnZs4qzQKGu7PiTtUy4d9xLQ@mail.gmail.com>
	<557AFC9D.3020109@candelatech.com>
	<CA+BoTQkn+Ro1+=PPe=1aHT519jW3BtF+Mmspy+kQftufpUiTPA@mail.gmail.com>
	<557EF0B0.7070008@candelatech.com>
	<557F2B43.8060409@candelatech.com>
Date: Tue, 16 Jun 2015 07:29:36 +0200
Message-ID: <CA+BoTQ=jYu2BV1rkaLwF_d5ZdDgsiws0TrWE7NGXmRsz8hMFVA@mail.gmail.com> (sfid-20150616_072942_924014_C99DE0BE)
Subject: Re: Question on beacon-miss offloading.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 June 2015 at 21:45, Ben Greear <greearb@candelatech.com> wrote:
> On 06/15/2015 08:35 AM, Ben Greear wrote:
>> On 06/14/2015 10:36 PM, Michal Kazior wrote:
>>> On 12 June 2015 at 17:37, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 06/11/2015 11:03 PM, Michal Kazior wrote:
>>>>> On 12 June 2015 at 01:38, Ben Greear <greearb@candelatech.com> wrote:
>>>>>> On 06/11/2015 02:07 PM, Ben Greear wrote:
>>>>>>> In my ath10k CT firmware, I am disabling the beacon-miss offloading
>>>>>>> to save space and because it will not work with lots of virtual
>>>>>>> stations.
>>>>>>>
>>>>>>> But, it must be that I need some way to tell the stack that this
>>>>>>> feature is not enabled, because when suddenly kill my AP, then
>>>>>>> the ath10k station connected to it shows endless 'beacon loss' events
>>>>>>> in 'iw events' output, but it never actually loses connection.
>>>>>>>
>>>>>>> Stock firmware works fine, so probably I just need to disable
>>>>>>> some feature flag when registering the ath10k hardware
>>>>>>> when using CT firmware.
>>>>>>>
>>>>>>> With stock firmware, I see a quick dissassociation due to inactivity.
>>>>>>>
>>>>>>> I am having poor luck finding how a driver tells the stack
>>>>>>> it has beacon miss offload or not, so, does anyone know how
>>>>>>> this is controlled?
>>>>>>
>>>>>> I still am not sure why stock firmware works, but it appears
>>>>>> the reason mine is failing is that the ACK status for mgt frames
>>>>>> is always set to TRUE since the ath10k wmi-mgt-tx API is so
>>>>>> lame.  So, mac80211 does a probe, ath10k lies and says it was
>>>>>> acked, and mac80211 then things all is well for another few
>>>>>> seconds.
>>>>>
>>>>> mac80211 shouldn't do a Probe Req to an AP on beacon loss because
>>>>> ath10k advertises it supports tx-status report. Hence mac80211 should
>>>>> use NullFunc frames which shouldn't go through wmi-mgmt-tx but htt
>>>>> tx-frm.
>>>>>
>>>>> But then again: NullFunc status reporting via htt tx-frm was broken on
>>>>> 10.1 if memory serves right. I believe it was fixed in 10.2 or 10.2.4.
>>>>>
>>>>> This problem has been effectively obscured on stock 10.1 by the
>>>>> offloaded beacon miss.
>>>>
>>>> Thanks for the hint.  I was able to fix my firmware to properly
>>>> return htt tx status, and now it appears to work properly.
>>>>
>>>> A quick throughput test works as well, so hopefully no regressions.
>>>>
>>>> I guess the NulFunc related comment is incorrect for 10.1 stock firmware?
>>>>
>>>> Maybe some others?
>>>>
>>>> static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
>>>> {
>>>>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>>>         int ret = 0;
>>>>
>>>>         if (ar->htt.target_version_major >= 3) {
>>>>                 /* Since HTT 3.0 there is no separate mgmt tx command */
>>>>                 ret = ath10k_htt_tx(&ar->htt, skb);
>>>>                 goto exit;
>>>>         }
>>>>
>>>>         if (ieee80211_is_mgmt(hdr->frame_control)) {
>>>>                 if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
>>>>                              ar->fw_features)) {
>>>>                         if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
>>>>                             ATH10K_MAX_NUM_MGMT_PENDING) {
>>>>                                 ath10k_warn(ar, "reached WMI management transmit queue limit\n");
>>>>                                 ret = -EBUSY;
>>>>                                 goto exit;
>>>>                         }
>>>>
>>>>                         skb_queue_tail(&ar->wmi_mgmt_tx_queue, skb);
>>>>                         ieee80211_queue_work(ar->hw, &ar->wmi_mgmt_tx_work);
>>>>                 } else {
>>>>                         ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
>>>>                 }
>>>>         } else if (!test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
>>>>                              ar->fw_features) &&
>>>>                    ieee80211_is_nullfunc(hdr->frame_control)) {
>>>>                 /* FW does not report tx status properly for NullFunc frames
>>>>                  * unless they are sent through mgmt tx path. mac80211 sends
>>>>                  * those frames when it detects link/beacon loss and depends
>>>>                  * on the tx status to be correct. */
>>>>                 ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
>>>>         } else {
>>>>                 ret = ath10k_htt_tx(&ar->htt, skb);
>>>>         }
>>>
>>> The NullFunc workaround was originally done for 999.999.0.636 but
>>> should be true for 10.1 as well with the sole exception the latter
>>> doesn't have htt-mgmt-tx to workaround the problem.
>>
>> Is it correct to say that this logic is completely broken for stock 10.1 firmware
>> because null-func frames are not management frames, so the packet goes out the
>> ath10k_htt_mgmt_tx call, and stock 10.1 does not properly do tx status
>> for htt-tx frames?

The has-wmi-mgmt-tx was originally designed to identify FW supporting
htt-mgmt-tx. It ended up to be used (implicitly) as a part of the
NullFunc workaround.

Hmm.. I guess it's not really ideal now because latest 10.2.4 FW which
supports htt-mgmt-tx doesn't need the workaround (htt-tx report
correct tx-status for NullFuncs)..


>> And slightly different question:  Once I put in proper htt ACK reporting into
>> my firmware, I notice that stations often loose connectivity when they are
>> idle.  I captured a sniff, and it appears the null-func packets are sent,
>> but the header is not requesting an explicit ACK, and the AP does not ACK it,
>> so connection is lost.
>>
>> I guess that the null-func frames should be requesting explicit ACK?
>
> This patch below (with firmware fix to make it actually pay attention
> to this special TID in station mode), fixes the null-func to be non-qos
> frames and get immediate ack.  This in turn seems to fix the disconnect
> issue I was facing, though I need to test some more to be sure.
>
> This seem reasonable, maybe even for upstream?
>
> [greearb@ben-dt2 ath10k]$ git diff
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 6ca48e3..610447e 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2213,6 +2213,9 @@ static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
>         if (ieee80211_is_mgmt(hdr->frame_control))
>                 return HTT_DATA_TX_EXT_TID_MGMT;
>
> +       if (ieee80211_is_nullfunc(hdr->frame_control))
> +               return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
> +

That's weird.. QoS NullFunc frames are already converted to non-QoS
frames, see ath10k_tx_h_nwifi():

        /* Some firmware revisions don't handle sending QoS NullFunc well.
         * These frames are mainly used for CQM purposes so it doesn't really
         * matter whether QoS NullFunc or NullFunc are sent.
         */
        hdr = (void *)skb->data;
        if (ieee80211_is_qos_nullfunc(hdr->frame_control))
                cb->htt.tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;

Or is it that ath10k_tx_h_get_tid() has a bug that ends up assigning
an invalid tid for non-QoS NullFunc frames? If so I guess your patch
would be okay with some comments/commit-log explaining why/what was
wrong.


Michał

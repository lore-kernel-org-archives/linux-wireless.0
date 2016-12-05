Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36442 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbcLEI7a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 03:59:30 -0500
Received: by mail-qt0-f175.google.com with SMTP id w33so307177827qtc.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 00:59:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ef7e16a6-9353-0f63-ac70-fc8e234d6c25@candelatech.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com>
 <57B70AED.2010200@candelatech.com> <ba1cc818-6194-11d6-7cc3-1db28036a519@candelatech.com>
 <ef7e16a6-9353-0f63-ac70-fc8e234d6c25@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 5 Dec 2016 09:50:55 +0100
Message-ID: <CA+BoTQnuLbVzuEVvf9+wOGhj7i3DV2LaMqGBfGhQHEgOSXei4g@mail.gmail.com> (sfid-20161205_100414_759156_6B6EE6F0)
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 December 2016 at 01:24, Ben Greear <greearb@candelatech.com> wrote:
> On 12/01/2016 02:52 PM, Ben Greear wrote:
>>
>> On 08/19/2016 06:34 AM, Ben Greear wrote:
>>>
>>>
>>>
>>> On 08/18/2016 11:59 PM, Michal Kazior wrote:
>>>>
>>>> On 19 August 2016 at 03:26,  <greearb@candelatech.com> wrote:
>>>>>
>>>>> From: Ben Greear <greearb@candelatech.com>
>>>>>
>>>>> I was seeing kernel crashes due to accessing freed memory
>>>>> while debugging a 9984 firmware that was crashing often.
>>>>>
>>>>> This patch fixes the crashes.  I am not certain if there
>>>>> is a better way or not.
>
>
> Michal, thanks for the help on IRC.  I added this logic:
>
> static void ieee80211_drv_tx(struct ieee80211_local *local,
>                              struct ieee80211_vif *vif,
>                              struct ieee80211_sta *pubsta,
>                              struct sk_buff *skb)
> {
>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
>         struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(vif);
>         struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
>         struct ieee80211_tx_control control =3D {
>                 .sta =3D pubsta,
>         };
>         struct ieee80211_txq *txq =3D NULL;
>         struct txq_info *txqi;
>         u8 ac;
>
>         if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
>             (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
>                 goto tx_normal;
>
>         if (!ieee80211_is_data(hdr->frame_control))
>                 goto tx_normal;
>
>         if (unlikely(!ieee80211_sdata_running(sdata))) {
>                 WARN_ON_ONCE(1);
>                 goto delete_and_return;
>         }
>
> ...
>
>         if (atomic_read(&sdata->txqs_len[ac]) >=3D
>             (local->hw.txq_ac_max_pending * 2)) {
>                 /* Must be that something is not paying attention to
>                  * max-pending, like pktgen, so just drop this frame.
>                  */
> delete_and_return:
>                 ieee80211_free_txskb(&local->hw, skb);
>                 return;
>         }
>
>
> But, I still see the txq entries on the ar->txqs list in the
> ath10k_mac_txq_init
> after firmware crash in my test case.  Is this the test you were suggesti=
ng?

Yes.

Now that I think about it mac80211 doesn't call anything in driver
during hw_restart that would unref txqs. This means you'll have them
still linked when add_interface/sta_state is called, no?

This means that either:
 (a) txq (re-)init should be smarter in ath10k
 (b) txqs should be purged during hw_restart in ath10k


Micha=C5=82

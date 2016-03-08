Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36973 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbcCHLFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:05:54 -0500
Received: by mail-wm0-f42.google.com with SMTP id p65so22475283wmp.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 03:05:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457250469-22994-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1457250469-22994-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 8 Mar 2016 12:05:53 +0100
Message-ID: <CA+BoTQmnY0omFh0iddjcVBXubt3WC49DpFumUBY=NSCYs-PuHw@mail.gmail.com> (sfid-20160308_120558_538839_7ACFE599)
Subject: Re: [PATCH v2] ath10k: move mgmt descriptor limit handle under mgmt_tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2016 at 08:47, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Firmware reserves few descriptors for management frames transmission.
> In 16 MBSSID scenario, these slots will be easy exhausted due to frequent
> probe responses. So for 10.4 based solutions, probe responses are limited
> by a threshold (24).
>
> management tx path is separate for all except tlv based solutions. Since
> tlv solutions (qca6174 & qca9377) do not support 16 AP interfaces, it is
> safe to move management descriptor limitation check under mgmt_tx
> function. Though CPU improvement is negligible, unlikely conditions or
> never hit conditions in hot path can be avoided on data transmission.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
> v2:
>   - rebased on top of Michal changes
[...]
> @@ -3979,13 +3977,22 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
>         is_htt = (txpath == ATH10K_MAC_TX_HTT ||
>                   txpath == ATH10K_MAC_TX_HTT_MGMT);
>
> -       if (is_htt) {
> -               spin_lock_bh(&ar->htt.tx_lock);
> -
> -               is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
> +       is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
> +       spin_lock_bh(&ar->htt.tx_lock);
> +       if (is_mgmt) {
>                 is_presp = ieee80211_is_probe_resp(hdr->frame_control);
>
> -               ret = ath10k_htt_tx_inc_pending(htt, is_mgmt, is_presp);
> +               ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_presp);
> +               if (ret) {
> +                       ath10k_warn(ar, "failed to increase tx mgmt pending count: %d, dropping\n",
> +                                   ret);
> +                       spin_unlock_bh(&ar->htt.tx_lock);
> +                       ieee80211_free_txskb(ar->hw, skb);
> +                       return;
> +               }
> +       }
> +       if (is_htt) {
> +               ret = ath10k_htt_tx_inc_pending(htt);
>                 if (ret) {
>                         ath10k_warn(ar, "failed to increase tx pending count: %d, dropping\n",
>                                     ret);

This doesn't look good.

You'll call ath10k_htt_tx_mgmt_inc_pending() regardless of the tx path
being chosen. FWIW It could be WMI on older firmware, oops.

Holding the lock for the entire time doesn't make much sense either, does it?

I think it should be more like:

 if (is_htt) {
    is_mgmt = ..;
    is_presp = ..;

    lock()
    ret = inc_pending(htt);
    if (ret) { unlock(); goto drop }

    ret = mgmt_inc_pending(htt, is_mgmt, is_presp);
    if (ret) { dec_pending(htt); unlock(); goto drop }

    unlock();
 }
 ...
 ret = mac_tx()
 if (ret) {
   if (is_htt) {
     lock();
     dec_pending();
     if (is_mgmt)
        mgmt_dec_pending()
     unlock();
 }

no?


> @@ -3993,16 +4000,17 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
>                         ieee80211_free_txskb(ar->hw, skb);
>                         return;
>                 }
> -
> -               spin_unlock_bh(&ar->htt.tx_lock);
>         }
> +       spin_unlock_bh(&ar->htt.tx_lock);
>
>         ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
>         if (ret) {
>                 ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
>                 if (is_htt) {
>                         spin_lock_bh(&ar->htt.tx_lock);
> -                       ath10k_htt_tx_dec_pending(htt, is_mgmt);
> +                       ath10k_htt_tx_dec_pending(htt);
> +                       if (is_mgmt)
> +                               ath10k_htt_tx_mgmt_dec_pending(htt);

And now the mgmt_dec_pending() is unbalanced. You unconditionally (wrt
is_htt) increase the mgmt_inc_pending but decrement only if is_htt is
true.


Michał

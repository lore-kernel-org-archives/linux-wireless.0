Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51144 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaLaO2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 09:28:45 -0500
Received: by mail-lb0-f172.google.com with SMTP id z12so5654487lbi.3
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2014 06:28:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416352495-82172-1-git-send-email-nbd@openwrt.org>
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>
Date: Wed, 31 Dec 2014 15:28:43 +0100
Message-ID: <CAJWpbEg0oRG6GYF_mP=m+gBKVp8Q7Gu36HBjtuxiddXFxA2fFA@mail.gmail.com> (sfid-20141231_152848_547136_B9177278)
Subject: Re: [PATCH] mac80211: add an intermediate software queue implementation
From: Johan Almbladh <ja@anyfi.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2014 at 12:14 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>
> +static void ieee80211_drv_tx(struct ieee80211_local *local,
> +                            struct ieee80211_vif *vif,
> +                            struct ieee80211_sta *pubsta,
> +                            struct sk_buff *skb)
> +{
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +       struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +       struct ieee80211_tx_control control = {
> +               .sta = pubsta
> +       };
> +       struct ieee80211_txq *pubtxq = NULL;
> +       struct txq_info *txq;
> +       u8 ac;
> +
> +       if (ieee80211_is_mgmt(hdr->frame_control) ||
> +           ieee80211_is_ctl(hdr->frame_control))
> +               goto tx_normal;
> +
> +       if (pubsta) {
> +               u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> +               pubtxq = pubsta->txq[tid];
> +       } else {
> +               pubtxq = vif->txq;
> +       }

In the monitor frame injection tx path the vif pointer may actually be
NULL when we get here, see the function __ieee80211_tx(). This causes
a NULL pointer dereference crash. The wperf tool
(https://github.com/anyfi/wperf) can be used to reproduce the crash by
specifying a BSSID that does not belong to a vif.

The following one-line change in the patch fixes the crash for me:

       if (pubsta) {
               u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
               pubtxq = pubsta->txq[tid];
-     } else {
+     } else if (vif) {
               pubtxq = vif->txq;
       }

Johan

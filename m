Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40941 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1H2G6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 02:58:04 -0400
Received: by gya6 with SMTP id 6so4545155gya.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 23:58:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314558661-28454-1-git-send-email-nbd@openwrt.org>
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org>
Date: Mon, 29 Aug 2011 08:58:03 +0200
Message-ID: <CAGXE3d_=BtQ+TEHG+y+ReftHB5Y9XhojsLyo9qkKSm4EpOGB8g@mail.gmail.com> (sfid-20110829_085812_987918_9D18CB82)
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later instead
 of tearing down aggr
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 9:11 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Unfortunately failed BAR tx attempts happen more frequently than I
> expected, and the resulting aggregation teardowns cause performance
> issues, as the aggregation session does not always get re-established
> properly.
> Instead of tearing down the entire aggr session, we can simply store the
> SSN of the last failed BAR tx attempt, wait for the first successful
> tx status event, and then send another BAR with the same SSN.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>

[...]

>  static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
>  {
>        struct ieee80211_mgmt *mgmt = (void *) skb->data;
>        struct ieee80211_local *local = sta->local;
>        struct ieee80211_sub_if_data *sdata = sta->sdata;
>
> +       if (ieee80211_is_data_qos(mgmt->frame_control)) {
> +               struct ieee80211_hdr *hdr = (void *) skb->data;
> +               u8 *qc = ieee80211_get_qos_ctl(hdr);
> +               u16 tid = qc[0] & 0xf;
> +
> +               ieee80211_check_pending_bar(sta, hdr->addr1, tid);
> +       }
> +

This code will not be run for injected QoS frames. Is this intended?
Otherwise looks good to me.

Helmut

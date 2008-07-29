Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:15569 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYG2Cj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 22:39:27 -0400
Received: by wf-out-1314.google.com with SMTP id 27so6125457wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 19:39:27 -0700 (PDT)
Message-ID: <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com> (sfid-20080729_043931_051259_BFC9FB16)
Date: Tue, 29 Jul 2008 03:39:26 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <48874F09.7060400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br>
	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>
	 <1216824917.13587.9.camel@johannes.berg>
	 <48874F09.7060400@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry, please tidy the tx seq no patch up and submit to wireless-testing..
I think it is more appropriate to copy the actual comments in rt2000
from Johannes?
instead of or in addtion to: "XXX: This sequence is an attempt to
match what happens in r2x00"

... and feel free to add ack-by/tested-by me.

I am wondering about Herton's problem with power saving (which I had
reproduced).
I think one way to move forward is to enable MAC80211_PS_DEBUG(?) and
see what happens
to the tx queues, now that we have a reliable way of reproducing the problem.

I also wonder how Herton encountered the problem :-). Older
wireless-testing simply
say "unimplemented" or something if one tries to set power-saving.
Maybe Herton has
a few devices which he routinely tries out every part of iwconfig?

Hin-Tak


On Wed, Jul 23, 2008 at 4:32 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
>
> I tried something like that, but it didn't work. Maybe you can see what is
> wrong here:
>
>
> Index: wireless-testing/drivers/net/wireless/rtl8187.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl8187.h
> @@ -100,6 +100,7 @@ struct rtl8187_priv {
>        struct usb_device *udev;
>        u32 rx_conf;
>        u16 txpwr_base;
> +       u16 seqno;
>        u8 asic_rev;
>        u8 is_rtl8187b;
>        enum {
> Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
> @@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
>  {
>        struct rtl8187_priv *priv = dev->priv;
>        struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +       struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr
> *)skb->data;
>        unsigned int ep;
>        void *buf;
>        struct urb *urb;
> @@ -198,6 +199,14 @@ static int rtl8187_tx(struct ieee80211_h
>                flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value <<
> 19;
>        }
>
> +       /* XXX: This sequence is an attempt to match what happens in r2x00.
> */
> +       if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +               if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> +                       priv->seqno += 0x10;
> +               ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> +               ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> +       }
> +
>        if (!priv->is_rtl8187b) {
>                struct rtl8187_tx_hdr *hdr =
>                        (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
>

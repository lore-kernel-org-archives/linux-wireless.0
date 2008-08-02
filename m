Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:27773 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYHBM5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 08:57:22 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1460208rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 05:57:21 -0700 (PDT)
Message-ID: <1ba2fa240808020557k15a2ba49n5d3ff2d70dcd26b4@mail.gmail.com> (sfid-20080802_145726_404640_92811E45)
Date: Sat, 2 Aug 2008 15:57:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ipw3945-devel] [BUG] IWL3945: Led doesn't blink in monitor mode
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <48942C35.6020400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48942C35.6020400@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 2, 2008 at 12:43 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> After fixing super annoying bug about garbage scan results,
> I noticed smaller bug:
>
> My wireless leds stop blinking if I enable monitor mode
> (Note that this time this doesn't happen if I enable promisc mode)
>
> Only module reload or recreation of wlan0 using iw  helps.
> This is due to the fact that once card is put in monitor mode it stays
> there always.
> (I will fix this bug when I have time)

Great.

>
> But leds should work even in monitor mode.
>
> Btw, do leds indicate RX activity or TX or both?
>
I've excluded RX for now. Since the filtering of the RX packets was
removed for favor or mac80211 filtering there was  a lot of false
blinking.

<snip>
static int iwl_get_blink_rate(struct iwl_priv *priv)
{
	int i;
	u64 current_tpt = priv->tx_stats[2].bytes;
	/* FIXME: + priv->rx_stats[2].bytes; */

</snip>

I'm pretty sure I won't have time to look at now

> PS:
>
> I will soon buy a standalone wireless card (pci express)
> Are iwlwifi based cards aviable?

Not sure if the cards are available stand alone.
Thanks
Tomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:43798 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753923AbdAZVez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 16:34:55 -0500
Received: from tisys.org (ip1f1368d2.dynamic.kabel-deutschland.de [31.19.104.210])
        by celine.tisys.org (Postfix) with ESMTPSA id 2EAC1514388A
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2017 22:25:17 +0100 (CET)
Date: Thu, 26 Jan 2017 22:25:12 +0100
From: Nils Holland <nholland@tisys.org>
To: linux-wireless@vger.kernel.org
Subject: rtl8187: No multicast
Message-ID: <20170126212511.GA2863@tisys.org> (sfid-20170126_223504_354770_3C5BDFC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

recently, a laptop featuring a rtl8187b usb wifi adapter, precisely,
this one:

Bus 001 Device 002: ID 0bda:8197 Realtek Semiconductor Corp. RTL8187B Wireless Adapter

fell into my hands. I noticed that in my IPv6 enabled home network,
the card would not receive any RAs and thus not acquire an IPv6
address. So I thought I'd have a look at the respective driver code,
with the intention of probably being able to fix this and submit a
patch. However, I have to admit that now I'm stuck and could use some
help. :-)

The relevant section of code, in
linux/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c, is certainly
this here:

static void rtl8187_configure_filter(struct ieee80211_hw *dev,
				     unsigned int changed_flags,
				     unsigned int *total_flags,
				     u64 multicast)
{
	struct rtl8187_priv *priv = dev->priv;

	if (changed_flags & FIF_FCSFAIL)
		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
	if (changed_flags & FIF_CONTROL)
		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
	if (changed_flags & FIF_OTHER_BSS)
		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
	if (*total_flags & FIF_ALLMULTI || multicast > 0)
		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
	else
		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;

	*total_flags = 0;

	if (priv->rx_conf & RTL818X_RX_CONF_FCS)
		*total_flags |= FIF_FCSFAIL;
	if (priv->rx_conf & RTL818X_RX_CONF_CTRL)
		*total_flags |= FIF_CONTROL;
	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
		*total_flags |= FIF_OTHER_BSS;
	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
		*total_flags |= FIF_ALLMULTI;

	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
}

I believe the card needs to receive multicast data in orde to pick up
RAs, and this seems to be properly set up by setting the
RTL818X_RX_CONF_MULTICAST flag. In fact, I have verified that this
actually gets set in my case, by printk()'ing "multicast" and
verifying that it is indeed > 0, as well as by changing the code to do

priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;

unconditionally. Sadly, that didn't help. I also, just out of
cluelessness, fiddled with the RTL818X_RX_CONF_BROADCAST flag which is
not touched in this function, but only set once in rtl8187_start(),
but of course, that didn't make a difference either.

Only one thing seemed to work: Unconditionally putting the card into
monitor mode, by adding

priv->rx_conf |= RTL818X_RX_CONF_MONITOR;

somewhere before the iowrite in the function above. That did in fact
make a difference and my card picked up an RA and IPv6 address.
However, it's probably not really a fix, as having the card run in
monitor mode all the time doesn't sound like too good of an idea.

So ... I have the feeling that the whole multicast filtering stuff of
the card / driver doesn't seem to be working right. And I have no idea
if it's the hardware or the driver. I did indeed find some datasheet
for the card on the web, but either it didn't really contain the info
on how to do this stuff right (or, at all), or I was too stupid to
find / understand it.

I'd really appreciate it if someone has some help or pointers, as I'd
be really glad if I could find a proper way to fix this!

Greetings
Nils

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:51084 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZADPTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 10:19:30 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: regression: no interfaces with rtl8180 driver post 2.6.28 git
Date: Sun, 4 Jan 2009 16:18:45 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20090104151222.GA6331@basil.nowhere.org>
In-Reply-To: <20090104151222.GA6331@basil.nowhere.org>
MIME-Version: 1.0
Message-Id: <200901041618.45653.rossi.f@inwind.it> (sfid-20090104_161933_187199_135EC53C)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 January 2009, Andi Kleen wrote:

> I got a
>
> 06:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 IEEE
> 802.11a/b/g Wireless LAN Controller (rev 20)
>
> PCI card in a box. With 2.6.28 it works (although rather poorly, always
> seems to eventually fallback to 1Mbit/s). With post 2.6.28-git latest the
> card is still detected, but no wlan0 interface is created anymore, only
> wmaster0:
>
> Some excerpts from the log.
>
> rtl8180 0000:06:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> wmaster0 (rtl8180): not using net_device_ops yet
> phy0: Selected rate control algorithm 'minstrel'
> phy0: hwaddr 00:18:e7:49:f4:32, RTL8185vD + rtl8225z2
>
> On 2.6.28 I get a wlan0 and roughly the same messages (except
> for the net_device_ops one, but I think that's harmless)
>
> I first suspected udev, but there's no trace of wlan0 anywhere
> in /sys, so it looks like it's not even create in kernel.
>
> Git tip 7d3b56ba37a95f1f370f50258ed3954c304c524b
> Userland is opensuse 11.1.
>
> -Andi

It should be a known problem already fixed in wireless-testing: try the patch
http://article.gmane.org/gmane.linux.kernel.wireless.general/25813/match=rtl8180

Fabio

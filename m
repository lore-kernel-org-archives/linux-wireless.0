Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:63045 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596AbZLTUU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 15:20:59 -0500
Message-ID: <4B2E8729.7050501@gmail.com>
Date: Sun, 20 Dec 2009 21:20:57 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Markus Baier <Markus_Baier@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
 for alignment operations.
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <1259012694-14869-3-git-send-email-gwingerde@gmail.com> <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com> <loom.20091220T163829-137@post.gmane.org>
In-Reply-To: <loom.20091220T163829-137@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/09 16:42, Markus Baier wrote:
> After my latest git pull to the kernel version 2.6.33-rc1-wl
> no client was able to connect to my hostapd (v0.6.9) AP.
> I found a lot of the following entries in the syslog:
> 
> wlan0: STA xx:xx:xx:xx:xx:xx
> IEEE 802.11: did not acknowledge authentication response
> 
> I bisected the problem to the commit e77f5ff92f5ef43c842e97136edcb68c61afe588
> above.
> 
> After I removed the lines below in rt2x00dev.c:
> rt2x00dev->hw->extra_tx_headroom =
>         max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
>               rt2x00dev->ops->extra_tx_headroom);
> 
> /*
> * Take TX headroom required for alignment into account.
> */
> if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
>         rt2x00dev->hw->extra_tx_headroom += RT2X00_L2PAD_SIZE;
> else if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
>         rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
> 
> added the line:
> rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
> 
> and compiled the kernel 2.6.33-rc2 again, all worked fine.
> 

That is very strange as this patch was meant to send TX statuses of frames
towards monitor interfaces (which is what hostapd is using).

What kind of rt2x00 device are you using (and which of the rt2x00 drivers)?

Are there any messages in dmesg when this happens?
Can you check whether there are any messages in dmesg in the working situation?

---
Gertjan.

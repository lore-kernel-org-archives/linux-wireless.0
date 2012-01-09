Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15048 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab2AIRE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 12:04:29 -0500
Date: Mon, 9 Jan 2012 11:54:44 -0500
From: Pavel Roskin <proski@gnu.org>
To: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: which one I can safely removed to lose some weight?
Message-ID: <20120109115444.5fbcc0e3@mj> (sfid-20120109_180433_209208_649A9AEB)
In-Reply-To: <4F098398.8090004@gmail.com>
References: <4F098398.8090004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 08 Jan 2012 19:52:56 +0800
lina <lina.lastname@gmail.com> wrote:

> after install the b43 related packages, my / become so heavy
> suddenly, reached 84%.


> 
> now
> 
> :/lib/modules/3.2.0-1-lina/updates/drivers/net/wireless# ls
> adm8211.ko       brcm80211     libertas           orinoco
> rtlwifi at76c50x-usb.ko  ipw2x00       libertas_tf
> p54            wl1251 ath              iwlegacy
> mac80211_hwsim.ko  rndis_wlan.ko  wl12xx b43
> iwlwifi       mwifiex            rt2x00         zd1211rw
> b43legacy        iwmc3200wifi  mwl8k.ko           rtl818x
> 
> root@dove:/lib/modules/3.2.0-1-lina/updates/drivers/net/wireless# du
> -sh 141M    .
> 
> I wonder above director, which one I can safely remove:
> 
> # lspci | grep Broad
> 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765 
> Gigabit Ethernet PCIe (rev 10)
> 02:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765 
> Memory Card Reader (rev 10)
> 03:00.0 Network controller: Broadcom Corporation BCM4331
> 802.11a/b/g/n (rev 02)
> 
> 
> I can keep it, just in case there are some redundant packages to take 
> the place,

I assume you are talking about some embedded system.  Remove the modules
under drivers/ except those that are used during normal operation. The
list of loaded modules is in /proc/modules.

I can imagine that some modules may or may not be used dependent on
the mode of operation (e.g. whether encryption is used), but they are
not under drivers/

-- 
Regards,
Pavel Roskin

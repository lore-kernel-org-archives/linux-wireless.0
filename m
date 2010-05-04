Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44227 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0EDIJF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 04:09:05 -0400
Message-ID: <4BDFD61B.4080901@openwrt.org>
Date: Tue, 04 May 2010 10:08:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: HT rate warning with openwrt AP using wireless-compat and ath9k
References: <87och0j7jj.fsf@purkki.valot.fi>
In-Reply-To: <87och0j7jj.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-01 11:27 AM, Kalle Valo wrote:
> Hi,
> 
> I'm running OpenWrt 10.03 on Netgear WNDR3700 and I'm having stability
> issues. The AP reboots few times a week, maybe even daily. I get the
> feeling that my wife's windows laptop is related to the reboots
> somehow, but I haven't investigated this in detail yet. Also I do not
> have access to serial console, so I don't have proper logs.
> 
> But today the AP didn't reboot, wireless was just dead. I managed to
> find this with ssh:
> 
> ------------[ cut here ]------------
> WARNING: at
> /home/openwrt/backfire/build/ar71xx/build_dir/linux-ar71xx/compat-wireless-2010-03-24/net/mac80211/rx.c:2528
> 0x83115884()
I just posted the following patch to linux-wireless:
[PATCH] ath9k: fix another source of corrupt frames
It might reduce the frequency of these warnings, or fix them entirely.

- Felix

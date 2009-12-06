Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58986 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbZLFTU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 14:20:56 -0500
Message-ID: <4B1C041A.3090708@openwrt.org>
Date: Sun, 06 Dec 2009 20:20:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
References: <200912061820.26320.8an@praha12.net> <200912061826.52394.8an@praha12.net> <4B1BF952.1000909@openwrt.org> <200912062000.26851.8an@praha12.net>
In-Reply-To: <200912062000.26851.8an@praha12.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek wrote:
> On 6.12.2009 19:34 Felix Fietkau wrote:
>> This part is wrong. The slot time can be either short or long, based on
>> configuration and PHY type.
> I did some test, and the value returned by ath5k_hw_get_slot_time was always 
> 9, even when connected to 802.11b-only AP. I didn't try the turbo mode, 
> though. Unfortunately I don't know how to calculate ACK timeouts for
> a different slot time - the formula I used is the only one in both Madwifi's 
> and FreeBSD's athctrl.
In 2.4 GHz, regular slot time is 20 usec, unless short slot is enabled.
2.4 GHz with short slot and 5 GHz both use 9 usec.

- Felix

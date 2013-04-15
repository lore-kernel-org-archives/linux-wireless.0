Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38296 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab3DOGrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 02:47:36 -0400
Date: Mon, 15 Apr 2013 12:08:38 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Jonas Gorski <jogo@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mwl8k: remove nonstandard rate 72 Mbps
Message-ID: <20130415063838.GB801@markyou.marvell.com> (sfid-20130415_084740_118643_8CA459DA)
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
 <1365941518-4963-1-git-send-email-jogo@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1365941518-4963-1-git-send-email-jogo@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 14, 2013 at 05:11:58AM -0700, Jonas Gorski wrote:
> This rate causes an overflow in the extended rates IE's data rate field,
> with the overflowing bit setting the Basic Rate Set membership. This
> results in a bogus 8 Mpbs basic rate, making clients checking them refuse
> association.
> 
> Since the rate is likely unused anyway (HT will yield better rates between
> supporting chips), we can just remove it.
> 
> This fixes association from wpa_supplicant and Android 4.x and newer.

Hi Jonas,

If you are using hostapd, have you tried using 'supported_rates' and/or
'basic_rates' being set to correct rates in the hostapd.conf.

Thanks
Yogesh

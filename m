Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39390 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1LMUaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:30:24 -0500
Date: Tue, 13 Dec 2011 15:28:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_hw: make bluetooth coexistence support optional at
 compile time
Message-ID: <20111213202813.GC2613@tuxdriver.com> (sfid-20111213_213029_859317_34B90EFF)
References: <1323550849-16651-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1323550849-16651-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 10, 2011 at 10:00:49PM +0100, Felix Fietkau wrote:
> Many systems (e.g. embedded systems) do not have wifi modules connected to
> bluetooth modules, so bluetooth coexistence is irrelevant there. With the
> addition of MCI support, ath9k picked up quite a bit of extra code that
> can be compiled out this way.
> 
> This patch redefines ATH9K_HW_CAP_MCI and adds an inline wrapper for
> querying the bluetooth coexistence scheme, allowing the compiler to
> eliminate code that uses it, with only very little use of #ifdef.
> 
> On MIPS this reduces the total size for the modules by about 20k.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

  CC [M]  drivers/net/wireless/ath/ath9k/beacon.o
In file included from drivers/net/wireless/ath/ath9k/hw.h:30:0,
                 from drivers/net/wireless/ath/ath9k/debug.h:20,
                 from drivers/net/wireless/ath/ath9k/ath9k.h:26,
                 from drivers/net/wireless/ath/ath9k/beacon.c:18:
drivers/net/wireless/ath/ath9k/btcoex.h: In function ‘ath9k_hw_get_btcoex_scheme’:
drivers/net/wireless/ath/ath9k/btcoex.h:105:11: error: dereferencing pointer to incomplete type

Did I miss a patch?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

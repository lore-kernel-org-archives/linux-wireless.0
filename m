Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47378 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab0KEAFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 20:05:25 -0400
Date: Fri, 5 Nov 2010 02:05:13 +0200
From: Jouni Malinen <j@w1.fi>
To: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
Cc: Bruno Randolf <br1@einfach.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2] ath9k_htc: Fix beacon distribution in IBSS mode
Message-ID: <20101105000513.GA8891@jm.kir.nu>
References: <1285054089-6707-1-git-send-email-rmanoharan@atheros.com>
 <201009271018.42232.br1@einfach.org>
 <201011041905.26464.br1@einfach.org>
 <44EE5C37ADC36343B0625A05DD408C4850DAB4D6CB@CHEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6CB@CHEXMB-01.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 04, 2010 at 05:11:18PM +0530, Rajkumar Manoharan wrote:
> Sorry for long gap. somehow I missed your mail. During our Interop Testing, we
> observed that ath9k based cards utilized the channel more frequently that others.
> To ensure fair beacon distribution, BE queue parameters were set to beacon queue.

Looking at interop testing results may end up being the most realistic
way of getting this working properly regardless of what the standard
says..

> But still I couldn't find specific WMM parameters for beacon queue except
> hostap.conf which stats that
> 
> tx_queue_beacon_aifs=2
> tx_queue_beacon_cwmin=3
> tx_queue_beacon_cwmax=7
> tx_queue_beacon_burst=1.5

Thanks for bringing those up.. I did not realize that the extra TX queue
parameters were still included in hostapd.conf (well, they are not
anymore.. ;-). Anyway, these were used in infrastructure BSS (i.e., by
an AP), not in an IBSS. IBSS is governed by special rules in IEEE Std
802.11-2007, 11.1.2.2 like Bruno already pointed out. While management
frames in general use AC_VO (until 802.11ae comes to play..), IBSS
Beacon distribution is specified to follow special rules: "Calculate a
random delay uniformly distributed in the range between
zero and twice aCWmin x aSlotTime." where aCWmin depends on the
used PHY, not some configurable AC-specific CWmin value.

-- 
Jouni Malinen                                            PGP id EFC895FA

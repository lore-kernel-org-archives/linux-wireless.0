Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59608 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbbGGHI4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 03:08:56 -0400
Message-ID: <559B7AFC.3040202@openwrt.org> (sfid-20150707_090859_843220_0D23BE7B)
Date: Tue, 07 Jul 2015 09:08:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: export HW random number generator
References: <1435912110-9646-1-git-send-email-miaoqing@qca.qualcomm.com> <559A5919.3060308@openwrt.org> <262dbfcff3564c4ba2025f9fde11e8e2@NASANEXM01E.na.qualcomm.com>
In-Reply-To: <262dbfcff3564c4ba2025f9fde11e8e2@NASANEXM01E.na.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-07-07 07:07, Pan, Miaoqing wrote:
> AR_PHY_TST_ADC is BB ADC sample register, it doesn't depend on other
> BB registers. Get non zero data if it has the ADC values.
This is completely wrong!

AR_PHY_TST_ADC is a generic observation register which can be configured
to observe multiple points in the rx path.
I did my own experiments with sampling raw I/Q values from the ADC, and
you can find my patch here:

http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=package/kernel/mac80211/patches/543-ath9k_entropy_from_adc.patch

It right now uses only the lowest bits (they are the hardest to control
from the outside).

Through extensive testing (not just by me, but also by many people in
the OpenWrt community), I found that leaving the AR_PHY_TST_ADC register
configured for raw I/Q samples causes the radio to become unstable on
AR5008-AR9002. That's why my patch currently only gathers some data at
driver init time.
By the way, on AR5008-AR9002 this register is in a different location
than AR9003, something your patch also needs to take into account.

You should also make sure that the radio is actually configured to a
channel (and active!) before gathering data.

When you rework your patch, please carefully review the documentation
for the fields rx_obs_sel and cf_bbb_obs_sel before you change the code
again.

- Felix

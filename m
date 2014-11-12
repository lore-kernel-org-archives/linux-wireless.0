Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41220 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaKLIsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 03:48:13 -0500
Message-ID: <54631EC7.1030009@openwrt.org> (sfid-20141112_094816_971387_0D07C64D)
Date: Wed, 12 Nov 2014 09:48:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>	<1415689644-29693-5-git-send-email-sujith@msujith.org>	<54621BFF.7080709@openwrt.org>	<21602.40415.179942.572517@gargle.gargle.HOWL>	<5326b4c51c744de285b390d8c78a47be@NASANEXM01E.na.qualcomm.com> <21602.54599.303861.990586@gargle.gargle.HOWL>
In-Reply-To: <21602.54599.303861.990586@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-12 04:34, Sujith Manoharan wrote:
> Pan, Miaoqing wrote:
>> the issue was found on ap143(QCA9531, 11n, 2x2), reported by Korea team.  They
>> want to make ap143 to work on 1x2 or 2x2 mode.
> 
> Ok, so apparently there are boards that are 2x2 in the HW, but the
> tx chainmask is set as 1 in the eeprom. In such cases, the thermometer
> has to be enabled for both the chains. So, I think we need this fix.
Makes sense. I don't like all these duplicated SREV checks though.
Let's store the chip_chainmask variable from ath9k_hw_fill_cap_info
somewhere in ath_hw and use that.

- Felix

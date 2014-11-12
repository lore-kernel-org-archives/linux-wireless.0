Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22852 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966647AbaKLBzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 20:55:03 -0500
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "sujith@msujith.org" <sujith@msujith.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: RE: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
Date: Wed, 12 Nov 2014 01:54:58 +0000
Message-ID: <5326b4c51c744de285b390d8c78a47be@NASANEXM01E.na.qualcomm.com> (sfid-20141112_030921_387040_1A9148F3)
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-5-git-send-email-sujith@msujith.org>
	<54621BFF.7080709@openwrt.org> <21602.40415.179942.572517@gargle.gargle.HOWL>
In-Reply-To: <21602.40415.179942.572517@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah->caps.tx_chainmask is  read from eeprom, e.g
ath9k_hw_fill_cap_info():  pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);

Sujith, the issue was found on ap143(QCA9531, 11n, 2x2), reported by Korea team.  They want to make ap143 to work on 1x2 or 2x2 mode. You can also find  the changes on 10.2(ar9300_thermometer_apply).

Miaoqing

-----Original Message-----
From: Sujith Manoharan [mailto:sujith@msujith.org] 
Sent: Wednesday, November 12, 2014 7:38 AM
To: nbd@openwrt.org
Cc: Pan, Miaoqing; John Linville; linux-wireless@vger.kernel.org; ath9k-devel
Subject: Re: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode

Felix Fietkau wrote:
> That doesn't seem right to me. ah->caps.tx_chainmask is not altered 
> based on software antenna configuration.

Yes, that's true.

Miaoqing, can you clarify ? Should the thermometer for chain 1 be enabled even though the HW caps contain 0x1 as TX chainmask, for example ?
Are there such boards ?

Sujith

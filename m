Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60872 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaKLDdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 22:33:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21602.54599.303861.990586@gargle.gargle.HOWL> (sfid-20141112_043321_912777_0C48212D)
Date: Wed, 12 Nov 2014 09:04:31 +0530
To: "nbd\@openwrt.org" <nbd@openwrt.org>
Cc: "Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: RE: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
In-Reply-To: <5326b4c51c744de285b390d8c78a47be@NASANEXM01E.na.qualcomm.com>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-5-git-send-email-sujith@msujith.org>
	<54621BFF.7080709@openwrt.org>
	<21602.40415.179942.572517@gargle.gargle.HOWL>
	<5326b4c51c744de285b390d8c78a47be@NASANEXM01E.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pan, Miaoqing wrote:
> the issue was found on ap143(QCA9531, 11n, 2x2), reported by Korea team.  They
> want to make ap143 to work on 1x2 or 2x2 mode.

Ok, so apparently there are boards that are 2x2 in the HW, but the
tx chainmask is set as 1 in the eeprom. In such cases, the thermometer
has to be enabled for both the chains. So, I think we need this fix.

Sujith

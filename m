Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42948 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaKNGB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 01:01:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21605.39678.693220.950149@gargle.gargle.HOWL> (sfid-20141114_070206_383580_6BE1BAEE)
Date: Fri, 14 Nov 2014 11:32:38 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/6] ath9k: disable overriding AR9340 SLP32 registers
In-Reply-To: <21603.62903.29605.927800@gargle.gargle.HOWL>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
	<1415689644-29693-2-git-send-email-sujith@msujith.org>
	<546343EF.5090803@openwrt.org>
	<21603.62903.29605.927800@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> Well, the code is redundant and I don't see the point in
> doing the writes when we don't have to ? We could maybe
> restructure it a bit...

So I managed to track down the reason for this override.

This is a specific hack for an Apple product that is
based on Wasp in which they use their own reference clock which is 40Mhz.

This override is not required for any other chip apart from Hornet,
for which we maintain different arrays for 25/40 Mhz in the INI files.

So, this chunk of code can be completely removed. ;-)

Sujith

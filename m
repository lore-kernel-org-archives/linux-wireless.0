Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41387 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab0G1WDO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 18:03:14 -0400
Message-ID: <4C50A922.3010500@openwrt.org>
Date: Thu, 29 Jul 2010 00:03:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH 2/3] ath9k_hw: clean up per-channel calibration data
References: <1280339151-37084-1-git-send-email-nbd@openwrt.org> <1280339151-37084-2-git-send-email-nbd@openwrt.org> <AANLkTi=8UX5B9+nLymSdJS2J-gRwMsYT_SVnviHX9Zi3@mail.gmail.com> <4C509CE1.90503@openwrt.org> <AANLkTi==nB+Wqe3KcmDf6P=JUYnLzc2PeAuOZQE3v9bn@mail.gmail.com> <4C50A170.1070902@openwrt.org> <20100728214041.GC8033@tux>
In-Reply-To: <20100728214041.GC8033@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-28 11:40 PM, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 02:30:24PM -0700, Felix Fietkau wrote:
>> My current patch should work just fine with virtual wiphy's, since I
>> store the calibration data in the ath_wiphy struct.
> 
> Ah neat, this approach seems fine in the long run then. My only remaining
> questions is how effective our scans are in a noisy environemnt with what
> I suppose are some default settings?
Scans in noisy environments should be fine. The hardware reset kicks off
an initial NF calibration that lets the baseband use the result
immediately and unfiltered by software. That is much more appropriate
than a calibration history of a channel that is almost never used.

- Felix

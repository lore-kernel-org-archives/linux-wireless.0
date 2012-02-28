Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:37489 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2B1L5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 06:57:08 -0500
Message-ID: <4F4CC111.7040909@neratec.com> (sfid-20120228_125748_487974_447B18F7)
Date: Tue, 28 Feb 2012 12:57:05 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Chadd, Adrian" <achadd@qca.qualcomm.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: decouple RX error checking for DFS
References: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com> <48EC4E8D43A28947B1AB2639FA97CDB901524852@nasanexd02a.na.qualcomm.com>
In-Reply-To: <48EC4E8D43A28947B1AB2639FA97CDB901524852@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

finally found an AR9280 and repeated the tests simultaneously, i.e. identical radar pulses go to AR9390 and AR9280.

After several hours of continuous radar firing (pulse count in the 1M range), it looks like the AR9280 does not suffer from the reported problem, i.e. the PHY error is never reported in combination with other RX errors.

The AR9390 OTOH always follows the following scheme:
* it starts as expected with radar pulses being reported as PHY errors (RX descriptor word 11 set to status11=0x511)
* after a short time (about 80% probability within 5-20 mins) a single CRC error is reported (status11=0x005)
* the CRC error flag becomes sticky thereafter, all further radar pulses are reported with status11=0x515, i.e. PHY *and* CRC error


The posted patch fixes this issue for monitor mode. Not sure about implications for the soon to follow master mode, though.

On 02/27/2012 05:00 PM, Chadd, Adrian wrote:
> Hi,
> 
> Hm, so the AR9003 series NICs set PHY error _and_ decrypt/CRC error? On radar frames?
> 
> Interesting! Have you checked to see if the AR9280 does the same?
> 
> 
> 
> Adrian

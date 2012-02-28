Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3536 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab2B1P7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:59:37 -0500
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] ath9k: decouple RX error checking for DFS
Date: Tue, 28 Feb 2012 15:59:35 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB901524A5F@nasanexd02a.na.qualcomm.com> (sfid-20120228_165940_640329_80720F3F)
References: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com>
 <48EC4E8D43A28947B1AB2639FA97CDB901524852@nasanexd02a.na.qualcomm.com>,<4F4CC111.7040909@neratec.com>
In-Reply-To: <4F4CC111.7040909@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

That's interesting. I have found the AR9280 to do the same. I hadn't gone digging into it though, I've been busy with other things but it was on my todo list. So thankyou for finding it. :-)

Specifically (and this is all under BSD):

* I'd start rx'ing radar errors;
* then they'd become crc errors;
* after some indeterminate amount of time, they'd drift back to being radar errors.

I'll reproduce it on the AR9280 and let you know how it goes.

Thanks for digging into it!


Adrian
________________________________________
From: Zefir Kurtisi [zefir.kurtisi@neratec.com]
Sent: Tuesday, 28 February 2012 3:57 AM
To: Chadd, Adrian
Cc: linville@tuxdriver.com; ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org; Rodriguez, Luis
Subject: Re: [PATCH] ath9k: decouple RX error checking for DFS

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

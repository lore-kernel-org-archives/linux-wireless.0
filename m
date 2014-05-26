Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:53969 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaEZROI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 13:14:08 -0400
Message-ID: <53837258.8050907@01019freenet.de> (sfid-20140526_191411_970606_FF610BFF)
Date: Mon, 26 May 2014 18:56:56 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Matthias Fend <Matthias.Fend@wolfvision.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2x00: Ralink RT5572 very high peak current consumption
References: <CC2A85E271C1FB479D9C17305347F69A4479A6@WOLFSERVER19.wolfvision-at.intra> <CC2A85E271C1FB479D9C17305347F69A44D336@WOLFSERVER19.wolfvision-at.intra>
In-Reply-To: <CC2A85E271C1FB479D9C17305347F69A44D336@WOLFSERVER19.wolfvision-at.intra>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Fend wrote:

[...]

> I found out that the discovered high current peaks are somehow related to invalidated beacons.
> Usually I can see 1 block with a normal tx-condition current followed by 7 additional blocks with high current peaks.
> For a test I copied the beacon data from HW_BEACON_BASE0 to HW_BEACON_BASE2 and then the first and the third beacon block have normal current values while the others still generate high current peaks
> 
> It seems that setting all five words of the TXWI at the beacon base does not complete disable the generation of this beacon.
> If I modify the TXIW_W0 of the disabled beacons to 0x40000000 (set TXWI_W0_PHYMODE as in the really used beacon) then the current consumption does not exceed the usual value. But it seems that there is still a short activity for this beacon which, in my opinion, should not be the case.
> 
> So, currently I'm wondering about two things:
> -)How do I completely turn off unused beacons (from the measurements with the windows setup I know that this should be somehow possible)?
> -)Where is the real address of HW_BEACON_BASE6 and HW_BEACON_BASE7? Modifying registers at the address of the appropriate defines (0x5dc0, 0x5bc0) does not change anything at all.

Container 13_UExxF68xx.zip on
http://opensource.samsung.com/reception/receptionSub.do?method=sub&sub=T&menu_item=tv_n_video&classification1=tv

seems to contain a complete Ralink vendor AP driver. I would take a look
there.


Andreas

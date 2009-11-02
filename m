Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:6119 "EHLO
	filter3.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZKBN7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 08:59:37 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: RE: [PATCH] libertas: remove internal buffers from GSPI driver
Date: Mon, 2 Nov 2009 13:59:25 -0000
Message-ID: <0D107966AF6D79418315B7C5549F4B5101150E65@lemail1.le.imgtec.org>
In-Reply-To: <45e8e6c40910291048g2958c086oa6b7a39dbb68258f@mail.gmail.com>
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com> <1256749998.3850.45.camel@localhost.localdomain> <45e8e6c40910291048g2958c086oa6b7a39dbb68258f@mail.gmail.com>
From: "George Shore" <George.Shore@imgtec.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>,
	"Dan Williams" <dcbw@redhat.com>
Cc: <linux-wireless@vger.kernel.org>,
	<libertas-dev@lists.infradead.org>, <sebatian@breakpoint.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey,



I've been unable to fully test the WPA2 functionality - I've not got

access to a WPA2 enabled access point - however, I have had a chance to

try the PS mode while connected to a WEP access point (something I

neglected to test first time around - my apologies :-S )



After connecting to the AP, I enabled PS mode and then tried the

following commands (in order):



* iwconfig (no arguments)

  This reurned the connection information, and indicated that power

namagement had been enabled;



* iwlist wlan0 scan

  This gave the following in my log:

[  741.343474] libertas: if_spi_c2h_cmd: error: response packet too

large: 4616 bytes, but maximum is 2400

[  741.370373] libertas: if_spi_c2h_cmd: err=-22

[  741.396573] libertas: lbs_spi_thread: got error -22

[  741.426908] libertas: if_spi_c2h_cmd: error: response packet too

large: 4616 bytes, but maximum is 2400

[  741.453290] libertas: if_spi_c2h_cmd: err=-22

[  741.466275] libertas: lbs_spi_thread: got error -22

[  743.454090] libertas: if_spi_c2h_cmd: error: response packet too

large: 4616 bytes, but maximum is 2400

[  743.480131] libertas: if_spi_c2h_cmd: err=-22

[  743.505172] libertas: lbs_spi_thread: got error -22

[  747.896416] libertas: if_spi_c2h_cmd: error: response packet too

large: 4616 bytes, but maximum is 2400

[  747.909623] libertas: if_spi_c2h_cmd: err=-22

[  747.934910] libertas: lbs_spi_thread: got error -22



  And then returned a 'Failed to read scan data : Resource temporarily

unavailable' error.



* iwconfig wlan0 power off

  After the previous command, this hung with no output on the console or

log.



* iwconfig

  After displaying the 'lo' entry (with no wireless extensions) this too

hung with no output on the console or log.



I apologise for not testing this functionality of the driver, our use

case for the device doesn't include power management so I didn't test it

(to be honest, I'm not sure how our usage of the device would affect any

results wrt power management - I'm still pretty new at this whole

testing and driver development gig!)



Hope this helps, and if I can get onto a WPA2 AP I'll do some more

tests,



George.



> -----Original Message-----

> From: Andrey Yurovsky [mailto:andrey@cozybit.com]

> Sent: 29 October 2009 17:49

> To: Dan Williams

> Cc: linux-wireless@vger.kernel.org; libertas-dev@lists.infradead.org;

> sebatian@breakpoint.cc; George Shore

> Subject: Re: [PATCH] libertas: remove internal buffers from GSPI

driver

> 

> On Wed, Oct 28, 2009 at 10:13 AM, Dan Williams <dcbw@redhat.com>

wrote:

> > Looks OK to me, but I don't have any of the SPI hardware so when you

get

> > a Tested-by:, let me know and I'll ack.

> 

> Thanks Dan, by the way the issue with WPA2 and IEEE PS is unrelated to

> this patch (that is, I can reproduce it without the patch applied) so

> we'll need to address that separately.  So at this point we have:

> 

> Tested-by: George Shore <george.shore@imgtec.com>

> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

-

This message is subject to Imagination Technologies' e-mail terms: http://www.imgtec.com/e-mail.htm



Imagination Technologies Ltd is a limited company registered in England No:  1306335 

Registered Office: Imagination House, Home Park Estate, Kings Langley, Hertfordshire, WD4 8LZ.  



Email to and from the company may be monitored for compliance and other administrative purposes.  

-



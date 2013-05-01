Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59114 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab3EAOeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 10:34:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MARmu-1Uj4Qc1nA2-00Bbgg for
 <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 16:34:24 +0200
Message-ID: <518127ED.9060900@rempel-privat.de> (sfid-20130501_163429_258127_95B38403)
Date: Wed, 01 May 2013 16:34:21 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: radiotap@NetBSD.org, simon@superduper.net,
	johannes@sipsolutions.net, Adrian Chadd <adrian@freebsd.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Standardisation - adding 2 bit STBC and Ness to MCS
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo all,


> http://www.radiotap.org/suggested-fields/MCS%20extension%20for%20STBC%20and%20Ness
>
> I have posted 3 patches on the proposal page (see Attachments):
>
> 1. A patch that applies to the Linux kernel v3.7-rc1 to collect the new
> STBC and Ness parameters from a wireless driver, and add them into the
> MCS radiotap field.
> 2. A patch to the Intel wireless driver in the kernel to collect STBC
> and Ness information.
> 3. A patch to wireshark to display STBC and Ness information.
>
> With this I believe we have everything needed to start the 3 week
> comment period.

There is a bit more then 3 week now. I would like to have this approved :)
Are there any thing needed to finish this?

Beside, i have one question about how STBC work. According to differnet 
docs, i assume that:
- STBC is done by sending, at least, two stream with same data in 
different order.
- It means for me, that real use of STBC can be made only on MIMO hardware.
- If 1x1 receiver indicates that it got STBC encoded frame, it dos not 
meant, it would be able to use redundant data from second stream.
- There are fallowing STBC schemes: Alamouti’s
STBC for 2 transmit antennas and orthogonal STBC for 3 and 4 transmit 
antennas.

According to this information, what do we call 1,2 or 3 stream STBC?
Since STBC should have minimal 2 stream, but in same time we have 1x1 
and 2x2 hardware which able to receive and decode STBC stream i assume:
	- RX-STBC1 is for compatibility only. No data redundancy.
	- RX-STBC12 - can be used Alamouti’s schema with 2 streams. Mostly used 
method.
	- RX-STBC123 - is orthogonal schema and not widely used method. Since 
last method use wide spectrum to transmit data comparable to SISO 
stream, it makes almost no sense. But 3-stream method get optimal error 
corect in compare with 2 and 4 strea schemas.

Do this assumptions correct?

PS: My assumptions based on "MIMO Space-Time Block Coding (STBC):
Simulations and Results"
-- 
Regards,
Oleksij

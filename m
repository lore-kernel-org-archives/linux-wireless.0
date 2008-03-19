Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claritin.media.mit.edu ([18.85.2.133]:3426 "EHLO
	claritin.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761598AbYCSUnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:43:42 -0400
In-Reply-To: <200803191650.53769.hs4233@mail.mn-solutions.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	libertas-dev-bounces@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] libertas: change quality calculation
MIME-Version: 1.0
Message-ID: <OFB867E8CF.D152FA3E-ON85257411.0057A540-85257411.005929B7@notes-mail.media.mit.edu> (sfid-20080319_204432_074704_BA21424A)
From: Michail Bletsas <mbletsas@laptop.org>
Date: Wed, 19 Mar 2008 12:13:51 -0400
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas-dev-bounces@lists.infradead.org wrote on 03/19/2008 11:50:53 AM:

> > RSSI can be derived by adding Noise Floor to SNR value
> 
> I saw that, and it's actually like this coded. However, I was 
> wondering if it is allowed to add "dBm" to "dB". Those are the 
> documented units for "noisefloor" and "SNR", respectively.
> 
Yes, you can add dB to dBm and you will end up with dBm

 0 dBm = 1mW

So the Noise Floor is given as an absolute value (dBm)  and adding the SNR 
to it ( just a ratio in dB) will tell you what the Signal level is (in 
dBm)

If the noise floor is reported as -86dBm, that means that the received 
noise power is about 2.5pW.
An SNR of 36 means that the received signal power is  -86dbm + 36dB = 
-50dbm ( i.e. 2^12 times higher - 10nW)

Wikipedia has a nice article explaining that: 
http://en.wikipedia.org/wiki/DBm

M.



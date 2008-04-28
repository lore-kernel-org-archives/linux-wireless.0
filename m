Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:37253 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966146AbYD1SaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 14:30:19 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	"'Dan Williams'" <dcbw@redhat.com>,
	"'Holger Schurig'" <hs4233@mail.mn-solutions.de>,
	<linux-wireless@vger.kernel.org>
Subject: RE: Roaming problems
Date: Mon, 28 Apr 2008 20:28:53 +0200
Message-ID: <009d01c8a95d$b73b0410$0b3ca8c0@gotws1589> (sfid-20080428_203056_316876_E7D0B8B5)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1209243255.10943.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > - Driver authenticating with new AP while having a valid 
> > association with and other AP.
> 
> Yes, that is the problem, we should disassociate first. If 
> you can come up with a patch to send a disassoc packet in 
> that case (and test it,
> preferably) that would be much welcome.

OK. I understood that there has been a discussion about the way the driver
should handle this situation and the current behaviour is according to that
discussion. Is there any information document available describing the
selected design path or is it only the code that document the design ? 
I think need that information if I should be able to create the patch
requested above.

On the other hand, that patch will only keep track of 'dual association'
problem. With the current wpa_supplicant, we will still have the problem
with the driver start an association sequence as soon as 'trig' ioctl
arrives. I think the wpa_supplicant need to modified to better cooperate
with the driver.

The patch that I suggested is now installed in the system where I had the
problem. The traces looks good and I have had no problems reported so far. 

/Lars


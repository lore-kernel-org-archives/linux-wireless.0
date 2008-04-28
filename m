Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:58339 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933769AbYD1UXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 16:23:46 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	"'Dan Williams'" <dcbw@redhat.com>,
	"'Holger Schurig'" <hs4233@mail.mn-solutions.de>,
	<linux-wireless@vger.kernel.org>
Subject: RE: Roaming problems
Date: Mon, 28 Apr 2008 22:22:42 +0200
Message-ID: <00ab01c8a96d$9d9360b0$0b3ca8c0@gotws1589> (sfid-20080428_222350_224466_3895857E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1209407657.29025.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> That would be doable as well (though I would argue it should 
> be done in addition), we could use Holger's approach and 
> delay the actual association sequence start until a commit 
> wext ioctl is received or a timer expires. Then 
> wpa_supplicant can call the commit explicitly after doing everything.

Yes I like this. A commit ioctl issued from the wpa_supplicant when all
configuration is done is the preferred solution. 
The commit ioctl that will speed up the roaming and the timer that will trig
the association if no commit ioctl is received which gives backwards
compatibility.
But, we then need to change the current implementation where 3 ioctls trigs
an immediate association start.

/Lars




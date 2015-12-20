Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38921 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbLTUeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 15:34:00 -0500
Date: Sun, 20 Dec 2015 23:33:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
Message-ID: <20151220203335.GX5284@mwanda> (sfid-20151220_213406_774523_39E1D37C)
References: <20151219105919.GB3749@mwanda>
 <1450637228.3430.30.camel@perches.com>
 <alpine.DEB.2.02.1512201959090.2055@localhost6.localdomain6>
 <1450638355.3430.34.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1450638355.3430.34.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 20, 2015 at 11:05:55AM -0800, Joe Perches wrote:
> On Sun, 2015-12-20 at 20:00 +0100, Julia Lawall wrote:
> > On Sun, 20 Dec 2015, Joe Perches wrote:
> > 
> > > On Sat, 2015-12-19 at 13:59 +0300, Dan Carpenter wrote:
> > > > There is a type bug so it always returns success.
> > > 
> > > How many false positives do you have to sift
> > > through to find this sort of error?
> > 
> > The return type is thoughtfully bool, so it should be easy in this case.  
> > The function has a return -EINVAL and a return true, so even without the 
> > return type it would be locally apparent that there is an inconsistency.
> 
> True, -EINVAL is a non-bool constant, but
> bool returns can be a variable int.
> 
> Dan, was the check any constant non-bool?

This warning is for returning negative with unsigned types smaller than
int.  It's doing cross function flow analysis so it could warning about
other things besides constants, but it's 90% constants.  It warns
about ds2482_w1_triplet() for example.

There aren't many false positives.

regards,
dan carpenter


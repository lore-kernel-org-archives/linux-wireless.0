Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:52491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750716AbbLTTF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 14:05:59 -0500
Message-ID: <1450638355.3430.34.camel@perches.com> (sfid-20151220_200630_358986_DF09E82B)
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Date: Sun, 20 Dec 2015 11:05:55 -0800
In-Reply-To: <alpine.DEB.2.02.1512201959090.2055@localhost6.localdomain6>
References: <20151219105919.GB3749@mwanda>
	 <1450637228.3430.30.camel@perches.com>
	 <alpine.DEB.2.02.1512201959090.2055@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-12-20 at 20:00 +0100, Julia Lawall wrote:
> On Sun, 20 Dec 2015, Joe Perches wrote:
> 
> > On Sat, 2015-12-19 at 13:59 +0300, Dan Carpenter wrote:
> > > There is a type bug so it always returns success.
> > 
> > How many false positives do you have to sift
> > through to find this sort of error?
> 
> The return type is thoughtfully bool, so it should be easy in this case.  
> The function has a return -EINVAL and a return true, so even without the 
> return type it would be locally apparent that there is an inconsistency.

True, -EINVAL is a non-bool constant, but
bool returns can be a variable int.

Dan, was the check any constant non-bool?


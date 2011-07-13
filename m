Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56815 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171Ab1GMJga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 05:36:30 -0400
Received: by pvg12 with SMTP id 12so4549874pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 02:36:30 -0700 (PDT)
Date: Wed, 13 Jul 2011 12:34:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
Message-ID: <20110713093450.GP18655@shale.localdomain> (sfid-20110713_113633_604347_27410D5A)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
 <20110713092257.GN18655@shale.localdomain>
 <1310549324.3873.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310549324.3873.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 11:28:44AM +0200, Johannes Berg wrote:
> On Wed, 2011-07-13 at 12:22 +0300, Dan Carpenter wrote:
> 
> > warn: returning -1 instead of -ENOMEM is sloppy
> 
> out of curiosity -- why does it say "instead of -ENOMEM"? -1 really gets
> interpreted as "-EPERM" (since EPERM == 1)

It's for an allocation failure.  The code returns -1 (-EPERM) but it
should be returning -ENOMEM.

regards,
dan carpenter

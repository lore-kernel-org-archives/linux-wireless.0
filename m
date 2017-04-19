Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34989 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763672AbdDSN3w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 09:29:52 -0400
Date: Wed, 19 Apr 2017 16:29:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Vincent Cuissard <cuissard@marvell.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcmrvl: double free on error path
Message-ID: <20170419132921.xkbj3bbumusxc2hx@mwanda> (sfid-20170419_152955_752089_BA019595)
References: <20170308052237.GA14542@mwanda>
 <20170401221117.GD22034@zurbaran.ger.intel.com>
 <20170419113354.6j7co2yuusdqsubl@mwanda>
 <20170419125229.GE13724@zurbaran.ger.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170419125229.GE13724@zurbaran.ger.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 19, 2017 at 02:52:29PM +0200, Samuel Ortiz wrote:
> On Wed, Apr 19, 2017 at 02:47:34PM +0300, Dan Carpenter wrote:
> > On Sun, Apr 02, 2017 at 12:11:17AM +0200, Samuel Ortiz wrote:
> > > Hi Dan,
> > > 
> > > On Wed, Mar 08, 2017 at 08:22:37AM +0300, Dan Carpenter wrote:
> > > > The nci_spi_send() function calls kfree_skb(skb) on both error and
> > > > success so this extra kfree_skb() is a double free.
> > > > 
> > > > Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
> > > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > ---
> > > > Static analysis.  Not tested.
> > > Applied to nfc-next, thanks.
> > > 
> > 
> > This is still not showing up in linux-next.
> I sent a pending pull request containing it.

Ah.  Sorry for the noise.  I didn't realize your tree didn't feed into
linux-next directly.  Perhaps it should, though?

regards,
dan carpenter

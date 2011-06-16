Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64822 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1FPFPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 01:15:23 -0400
Date: Thu, 16 Jun 2011 08:14:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Dowan Kim <dowan@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom board
Message-ID: <20110616051452.GF23739@shale.localdomain> (sfid-20110616_071528_842604_3B7D6A12)
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110616013615.GA14700@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110616013615.GA14700@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2011 at 06:36:16PM -0700, Henry Ptasinski wrote:
> On Wed, Jun 15, 2011 at 03:25:09PM -0700, Greg Dietsche wrote:
> > This code looks wrong to me. I think it meant to return false
> > if the board's vendor id isn't Broadcom's.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> > ---
> >  drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> > index 4534926..ee13238 100644
> > --- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> > +++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> > @@ -1943,7 +1943,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
> >  	}
> >  
> >  	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
> > -		return goodboard;
> > +		goodboard = false; 
> >  
> >  	return goodboard;
> >  }
> 
> Actually, the original code is correct.
> 
> For boards with the Broadcom ID, this function checks that the boardrev is
> sane. Dev boards that aren't properly configured may have invalid info, so this
> check is mainly to catch that problem.
> 
> For boards with any other vendor, we don't have any sanity checks that we know
> should be done, so the board info is always considered good.
>

Sounds like it should be "goodboard = true;" then.

regards,
dan carpenter


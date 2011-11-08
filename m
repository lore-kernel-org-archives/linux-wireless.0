Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33742 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1KHOPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:15:14 -0500
Date: Tue, 8 Nov 2011 09:09:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check
 that all given ssids are in filters
Message-ID: <20111108140941.GB2776@tuxdriver.com> (sfid-20111108_151519_420889_CE0BE1FB)
References: <1320760486-19700-1-git-send-email-eyal@wizery.com>
 <1320761188.19479.10.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320761188.19479.10.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2011 at 04:06:28PM +0200, Luciano Coelho wrote:
> On Tue, 2011-11-08 at 15:54 +0200, Eyal Shapira wrote: 
> > A minor fix for the check that verifies that all given SSIDs (in req) exist
> > in the filters (the match sets)
> > 
> > Signed-off-by: Eyal Shapira <eyal@wizery.com>
> > ---
> >  drivers/net/wireless/wl12xx/scan.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
> > index 128ccb7..fc29c67 100644
> > --- a/drivers/net/wireless/wl12xx/scan.c
> > +++ b/drivers/net/wireless/wl12xx/scan.c
> > @@ -559,7 +559,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
> >  						break;
> >  					}
> >  				/* Fail if SSID isn't present in the filters */
> > -				if (j == req->n_ssids) {
> > +				if (j == cmd->n_ssids) {
> >  					ret = -EINVAL;
> >  					goto out_free;
> >  				}
> 
> Just to clarify.  My comment:
> > Acked-by: Luciano Coelho <coelho@ti.com>
> > 
> > John, can you apply this to 3.2, please?
> 
> ...was about this patch.  Eyal's email was delivered to me, but vger
> rejected it, so he had to resend it.

OK, I got it. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

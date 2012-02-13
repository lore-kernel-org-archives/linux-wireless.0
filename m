Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab2BMQnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 11:43:09 -0500
Date: Mon, 13 Feb 2012 17:43:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/24] iwlegacy: only enable rfkill interrupt during UP
Message-ID: <20120213164301.GB9599@redhat.com> (sfid-20120213_174324_024682_8E556749)
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
 <1329128611-6815-21-git-send-email-sgruszka@redhat.com>
 <1329149958.2094.4.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1329149958.2094.4.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 10:19:18AM -0600, Dan Williams wrote:
> On Mon, 2012-02-13 at 11:23 +0100, Stanislaw Gruszka wrote:
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlegacy/4965-mac.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> By UP here I'll assume IFF_UP; did the previous code enable the
> interrupt while the interface was down too? 
Yes, we do the same thing during IFF_DOWN and IFF_UP, we enable rfkill
interrupt and mask all other interrupts, when rfkill switch is on.

> The problem we have here is
> that if there's no platform rfkill switch, but only the iwlwifi one,
> then we don't get notifications of rfkill changes, which breaks showing
> in the UI when you can and cannot use the card.
This change will not broke that.

I just realize that description is wrong, and probably that make the
confusion here. It should be "enable only rfkill interrupt when
rfkill switch is on during IFF_UP".

Deja vu
http://comments.gmane.org/gmane.linux.kernel.wireless.general/61915
Some people will never learn some things ...

> There are various complexities with rfkill here; for example I think for
> 3945 it used to be that you couldn't UP the interface when it was
> rfkilled, so when it was killed (and thus down) you couldn't get
> notifications of rfkill change at all, and thus you wouldn't know if you
> could start using it again, except to poll (which sucks).

Anyway I tested this patches on two laptops with 3945 and 4965,
rfkill worked there as expected.

I'll repost patch with correct topic

Stanislaw

> 
> Dan
> 
> > diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> > index 24a3bbc..cf14861 100644
> > --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> > +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> > @@ -5523,13 +5523,11 @@ __il4965_up(struct il_priv *il)
> >  	/* If platform's RF_KILL switch is NOT set to KILL */
> >  	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
> >  		clear_bit(S_RF_KILL_HW, &il->status);
> > -	else
> > +	else {
> >  		set_bit(S_RF_KILL_HW, &il->status);
> > -
> > -	if (il_is_rfkill(il)) {
> >  		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
> >  
> > -		il_enable_interrupts(il);
> > +		il_enable_rfkill_int(il);
> >  		IL_WARN("Radio disabled by HW RF Kill switch\n");
> >  		return 0;
> >  	}
> 
> 

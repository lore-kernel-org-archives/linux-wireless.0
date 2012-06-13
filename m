Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2FMNnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:43:35 -0400
Date: Wed, 13 Jun 2012 08:43:30 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 6/9] brcm80211: smac: enable/disable radio on
 regulatory updates
Message-ID: <20120613134330.GA3490@thinkpad-t410> (sfid-20120613_154346_157447_29A26E75)
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-7-git-send-email-seth.forshee@canonical.com>
 <4FD85D47.8070609@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD85D47.8070609@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 11:28:39AM +0200, Arend van Spriel wrote:
> On 06/05/2012 04:34 PM, Seth Forshee wrote:
> > Currently the radio disable state is only updated during initialization,
> > and it's only checked against the internal world domain. This is
> > unnecessary, as there are always valid channels against this domain.
> > Instead, check whether any channels are enabled in the regulatory
> > notifier and update the radio state accordingly.
> > 
> > Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> > Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  drivers/net/wireless/brcm80211/brcmsmac/channel.c |   67 ++++++++-------------
> >  1 file changed, 26 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> > index 65ef60b..7182b58 100644
> > --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> > +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> > @@ -1235,12 +1194,38 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
> > +
> > +	if (likely(ch_found)) {
> > +		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> > +	} else {
> > +		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> > +		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\"\n",
> > +			  wlc->pub->unit, __func__, request->alpha2);
> > +	}
> > +
> 
> When we were having fun in staging GregKH indicated that use of likely()
> should be justified with profiling data. Probably not really needed here.

Okay, I'll remove it. This isn't performance critical code anyhow.


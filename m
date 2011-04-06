Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44295 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1DFSaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:30:20 -0400
Date: Wed, 6 Apr 2011 13:18:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Joe Culler <joe.culler@gmail.com>,
	linux-wireless@vger.kernel.org,
	Michael Green <michael.green@atheros.com>,
	David Quan <david.quan@atheros.com>
Subject: Re: invalid regdomain: 0x5c (was: problem with D-Link DWA-160)
Message-ID: <20110406171858.GH11941@tuxdriver.com>
References: <BANLkTinLdpaS9GLN88ObSACbmQJOK7wnug@mail.gmail.com>
 <201104061423.02484.chunkeey@googlemail.com>
 <BANLkTinaQHv-WUdg6F+xSE-X36bzOqCphQ@mail.gmail.com>
 <BANLkTi=NuktQeE07p3QDZbekyXMF4uR_cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTi=NuktQeE07p3QDZbekyXMF4uR_cg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 10:17:45AM -0700, Luis R. Rodriguez wrote:
> On Wed, Apr 6, 2011 at 10:17 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Apr 6, 2011 at 5:23 AM, Christian Lamparter
> > <chunkeey@googlemail.com> wrote:
> >> On Wednesday 06 April 2011 05:26:28 Joe Culler wrote:
> >>> [...]
> >>> I have a problem with carl9170 driver with my d-link dwa-160 under
> >>> linux-2.6.39-rc1.
> >>> Here's the dmesg:
> >>
> >>> [ 3114.257063] ath: EEPROM regdomain: 0x5c
> >>> [ 3114.257066] ath: EEPROM indicates we should expect a direct regpair map
> >>> [ 3114.257069] ath: invalid regulatory domain/country code 0x5c
> >>> [ 3114.257071] ath: Invalid EEPROM contents
> >> clearly, the regdomain code 0x5c is not defined in the
> >> drivers/net/wireless/ath/regd_common.h => regDomainPairs struct.
> >>
> >> this would be easy to fix [see attached patch], however I'm
> >> not quite sure what to do about the 5GHz band in this case,
> >> since the CTL_FCC is more restrictive than it should be.
> >>
> >> Regards,
> >>        Chr
> >>
> >> ---
> >> diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
> >> index 248c670..5c2cfe6 100644
> >> --- a/drivers/net/wireless/ath/regd_common.h
> >> +++ b/drivers/net/wireless/ath/regd_common.h
> >> @@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
> >>        {APL9_WORLD, CTL_ETSI, CTL_ETSI},
> >>
> >>        {APL3_FCCA, CTL_FCC, CTL_FCC},
> >> +       {APL7_FCCA, CTL_FCC, CTL_FCC},
> >>        {APL1_ETSIC, CTL_FCC, CTL_ETSI},
> >>        {APL2_ETSIC, CTL_FCC, CTL_ETSI},
> >>        {APL2_APLD, CTL_FCC, NO_CTL},
> >
> > I verified internally with our other code and this is correct, APL7
> > maps to FCC CTL and FCCA maps to FCC CTL as well. For an upstream
> > patch:
> >
> > Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Oh and please Cc stable@kernel.org, thanks a lot!

...and don't forget the Signed-off-by...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

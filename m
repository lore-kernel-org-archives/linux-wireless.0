Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47308 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYLaF1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 00:27:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 21:27:15 -0800
Date: Wed, 31 Dec 2008 10:45:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Handle power constraint level advertised in
	11d+h beacon
Message-ID: <20081231051529.GB9080@localhost.localdomain> (sfid-20081231_062723_158624_CF9CEE3A)
References: <1230641555-13425-1-git-send-email-vasanth@atheros.com> <1ba2fa240812300708o40717c87x13697c180be19913@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240812300708o40717c87x13697c180be19913@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 08:38:15PM +0530, Tomas Winkler wrote:
> > +       /* TODO: for IBSS */
> 
> IIRC this particular feature of 11h is not supported in IBSS
> 

No, this is supported in IBSS also. See 11.8.2 of IEEE802.11-2007.pdf. 

> > +       if ((conf->channel->band != IEEE80211_BAND_5GHZ) ||
> > +           !(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
> > +               return;
> 
> I think our original patch removed need of IEEE80211_BAND_5GHZ as
> WLAN_CAPABILITY_SPECTRUM_MGMT
> is sufficient condition.
> 

Thats right, spectrum management is only for 5Ghz, will remove that
redundant check, thanks. 

> > +       /* Power constraint IE length should be 1 octet */
> > +       if (pwr_constr_elem_len != 1)
> > +               return;
> > +
> > +       if ((*pwr_constr_elem <= conf->channel->max_power) &&
> > +           (*pwr_constr_elem != conf->power_constr_level)) {
> 
> This is defined only when you receive country IE, how do you check for it?

The thing is AP should not send power constraint without country
element :), yeah, check is needed for the APs which dont do 11d + h
properly. 


Vasanth


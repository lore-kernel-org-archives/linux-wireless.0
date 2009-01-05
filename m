Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60626 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZAENhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 08:37:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 05:37:50 -0800
Date: Mon, 5 Jan 2009 19:07:38 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Handle power constraint level advertised in
	11d+h beacon
Message-ID: <20090105133738.GA21471@vasanth-laptop> (sfid-20090105_143754_040377_F24AF73D)
References: <1231148165-10529-1-git-send-email-vasanth@atheros.com> <1231153954.3334.4.camel@johannes>
MIME-Version: 1.0
Content-Type: application/x-re
In-Reply-To: <1231153954.3334.4.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 04:42:34PM +0530, Johannes Berg wrote:=0A> =0A> I t=
hink I'd prefer that to be written as=0A> =0A> if (!scanning && power_const=
r_level)=0A> 	power =3D ... - ...=0A> else=0A> 	power =3D chan->max_power;=
=0A> =0A> Also, I don't understand the subtraction? And why are you checkin=
g only=0A> for sw scanning and not hw scanning?=0A=0AI think driver should =
handle in case of hw_scanning.=0A=0A> > +=0A> > +	if ((*pwr_constr_elem <=
=3D conf->channel->max_power) &&=0A> > +	    (*pwr_constr_elem !=3D conf->p=
ower_constr_level)) {=0A> > +		conf->power_constr_level =3D *pwr_constr_ele=
m;=0A> > +		ieee80211_hw_config(sdata->local, 0);=0A> =0A> That needs a cha=
nged flag, no? =0A=0ANo, ieee80211_hw_config() will take care.=0A=0A>And ho=
w does the subtraction make sense=0A> like this? The spec talks about the c=
ountry element's max power, and=0A> then subtracting this, to get the local=
 power, but if the local power=0A> was set lower than that then we shouldn'=
t subtract even more, no?=0A=0A=0AThis is more concervative way of processi=
ng power constraint.  Yeah, you are correct=0Athat we might be setting lowe=
r tx power than the allowed one when we subtract power=0Aconstraint from al=
ready min power (of reg data base and 11d ie) instead of only power =0Alimi=
t advertised in 11d ie, but this situation is uncommon. =0A=0AVasanth=0A=0A

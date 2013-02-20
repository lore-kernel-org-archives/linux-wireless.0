Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:44299 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758925Ab3BTS3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:29:33 -0500
Message-ID: <1361384969.2219.4.camel@joe-AO722> (sfid-20130220_192936_348780_4BA044DA)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 10:29:29 -0800
In-Reply-To: <51250E6B.3030308@lwfinger.net>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	 <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>
	 <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 11:56 -0600, Larry Finger wrote:
> On 02/20/2013 11:31 AM, Joe Perches wrote:
> > On Mon, 2013-02-18 at 17:09 +0100, Rafał Miłecki wrote:
> >> 2013/2/16 Hauke Mehrtens <hauke@hauke-m.de>:
> >>> The mac address should be aligned to u16 to prevent an unaligned access
> >>> in drivers/ssb/pci.c where it is casted to __be16.
> > []
> >>> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> > []
> >>> @@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
> >>>
> >>>   struct ssb_sprom {
> >>>          u8 revision;
> >>> +       u8 country_code;        /* Country Code */
> >>>          u8 il0mac[6];           /* MAC address for 802.11b/g */
> >>
> >> It looks a little hacky to me too, it's easy to forget about that
> >> requirement and break that again in the future.
> >>
> >> What about not casting il0mac to u16 at all? Maybe we should just fill
> >> it as u8 (which it is)?
> >>
> >
> > Perhaps this?
> >
> > From: Joe Perches <joe@perches.com>
> > Subject: [PATCH] ssb: pci: Standardize a function to get mac address
> >
> > Don't require alignment of mac addresses to u16.
[]
> > diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
[]
> > @@ -231,6 +231,15 @@ static inline u8 ssb_crc8(u8 crc, u8 data)
> >   	return t[crc ^ data];
> >   }
> >
> > +static void sprom_get_mac(char *mac, const u16 *in)
> > +{
> > +	int i;
> > +	for (i = 0; i < 3; i++) {
> > +		*mac++ = in[i];
> > +		*mac++ = in[i] >> 8;
> > +	}
> > +}
> > +
> >   static u8 ssb_sprom_crc(const u16 *sprom, u16 size)
> >   {
> >   	int word;
> > @@ -341,8 +350,6 @@ static s8 r123_extract_antgain(u8 sprom_revision, const u16 *in,
> >
> >   static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
> >   {
> > -	int i;
> > -	u16 v;
> >   	u16 loc[3];
> >
> >   	if (out->revision == 3)			/* rev 3 moved MAC */
> > @@ -352,19 +359,10 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
> >   		loc[1] = SSB_SPROM1_ET0MAC;
> >   		loc[2] = SSB_SPROM1_ET1MAC;
> >   	}
> > -	for (i = 0; i < 3; i++) {
> > -		v = in[SPOFF(loc[0]) + i];
> > -		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
> > -	}
> > +	sprom_get_mac(out->il0mac, &in[SPOFF(loc[0])]);
[]
> I like the looks of sprom_get_mac() over that ugly *(((__be16 *)out->il0mac) 
> construct, but this patch breaks ssb. The resulting MAC address is all ones. I 
> have not yet figured out the problem.

Dunno, I must have done something stupid.

I don't have one of these but the transform
looked correct when I did  it.

I'm not sure it's the best solution anyway
because some of the other ether address
functions like compare_ether_addr also
require 2 byte alignment and cast to u16.

cheers, Joe


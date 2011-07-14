Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3318 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1GNOIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 10:08:05 -0400
Date: Thu, 14 Jul 2011 19:38:09 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/3] mac80211: Add 20/40 BSS coexistence management frame
 format
Message-ID: <20110714140804.GA23883@vmraj-lnx.users.atheros.com> (sfid-20110714_160810_914194_E6223D2F)
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1310638112.3874.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310638112.3874.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 12:08:32PM +0200, Johannes Berg wrote:
> On Wed, 2011-07-13 at 17:54 +0530, Rajkumar Manoharan wrote:
> > Add 20/40 BSS coexistence and intolerant channel report IEs.
> 
> Can you make the subject "wireless" or "ieee80211" instead of
> "mac80211"?
>
OK
> > +/**
> > + * struct ieee80211_2040_bss_coex_ie
> > + *
> > + * This structure refers to "20/40 BSS Coexistence information element"
> > + */
> 
> That documentation is incomplete.
>
Followed the existing IE struct documenting style.

> > +struct ieee80211_2040_bss_coex_ie {
> > +	u8 element_id;
> > +	u8 length;
> > +#define IEEE80211_2040_BC_INFO_REQ		0x01
> > +#define IEEE80211_2040_BC_40MHZ_INTOL		0x02
> > +#define IEEE80211_2040_BC_20MHZ_WIDTH_REQ	0x04
> > +#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_REQ	0x08
> > +#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_GRNT	0x10
> 
> Please don't define them inside the struct, the docbook processing
> doesn't like that. Also BIT() would be nice to be more readable, and
> maybe make them an enum so they can have docs?
>
OK
> > +/**
> > + * struct ieee80211_2040_intol_chan_report
> > + *
> > + * This structure refers to "20/40 BSS Intolerant Channel Report"
> > + */
> 
> Again incomplete docs. Come to think of it, maybe give pointers to the
> spec?
>
Followed the existing IE struct documenting style.
> > +struct ieee80211_2040_intol_chan_report {
> > +	u8 element_id;
> > +	u8 length;
> > +	u8 reg_class;
> > +	u8 variable[0];
> > +} __packed;
> 
> Does that variable[] really belong to the report? Didn't check now.
>
Yes. It points to intolerant channel list (sec 7.3.2.58)

--
Rajkumar

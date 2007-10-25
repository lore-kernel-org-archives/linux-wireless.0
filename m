Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:2008 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXJYJ7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:59:46 -0400
Received: by rv-out-0910.google.com with SMTP id k20so426570rvb
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2007 02:59:45 -0700 (PDT)
Message-ID: <c85cb4470710250259y2e35294cmb6131abc7327389@mail.gmail.com> (sfid-20071025_110009_013455_9CA2AABD)
Date: Thu, 25 Oct 2007 11:59:45 +0200
From: "Ron Rindzonski" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: [RFC] adding bss_config to low level driver ops
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1193227218.4510.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
	 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
	 <1193227218.4510.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-10-24 at 12:22 +0200, Ron Rindjunsky wrote:
>
> > +#define BSS_VERIFY_STATE_ASSOC               (1<<0)
>
> Why "verify"? Shouldn't it be "CHANGED" instead?

there are cases (erp reset for example) that values are sent to the low level
driver even if there is no change from previous state, so "verify" is
for telling the driver: "hey, check this value to see if it's the one
configured in HW, and if not change it to delivered value"
in fact i had difficulty finding a suitable word describing this. any
suggestions will
be more then welcome...

>
> > +struct ieee80211_bss_data {
> > +     u8 verify_map;
>
> Seeing that you already used 5 of 8 bits and we're likely to increase
> this in the future, I'd go with a u32 here. Also, have you attempted to
> make all fields 'valid' all the time and if so, why is there no
> 'changed' bitmap passed to the callback?
>

right, i'll change it to u32.
i believe that if i'll just follow the current flows the struct will
always be valid as it will follow every change occurs in the mac80211,
so i'll add the "valid" only if i see it is really needed.
for the "changed" use - please see above 'changed/verify" naming dilemma.


> > +     /* association related data */
> > +     u8 assoc;
> > +     u16 aid;
>
> And then reorder these two for less padding.
>
> > + * @bss_info_changed: Handler for configuration requests related to BSS
> > + *   parameters that may vary during BSS's lifespan, and may affect low
> > + *   level driver (e.g. assoc/disassoc status, erp parameters).
> > + *   This function should not be used if no BSS has been set, unless
> > + *   for association indication.
>
> I don't understand the last sentence here. Can you elaborate? Is it
> meant as a note for mac80211 hackers? If so, wouldn't it be more
> appropriate to add it to the function that calls this? Also, you didn't
> add the if_id which will even break Intel's driver once multi-MAC
> support is added...
>

if_id will be added, thanks.
my initial thought was that no BSS configuration is possible without
association first to establish this BSS, but coming to think about it
AP flows can be different - config the driver even with no association
first. i'll remove this line, and inspect my code accordingly.

> > @@ -276,6 +276,7 @@ struct ieee80211_if_sta {
> >       u32 supp_rates_bits;
> >
> >       int wmm_last_param_set;
> > +     struct ieee80211_bss_data bss_data;
>
> Are you sure this will work properly? The same stuff must also be used
> for AP mode, when hostapd decides to change things, no?
>

i see your point. do you think that sub_if_data will be more suitable?

> > +                             if (bss->has_erp_value)
> > +                                 ieee80211_handle_erp_ie(dev,
> > +                                                         bss->erp_value);
>
> Seeing that you're shuffling around this code anyway, I'd put patch 2
> into this patch.
>

will do.

> johannes
>
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32923 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbbA0Lnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 06:43:32 -0500
Message-ID: <1422359002.1890.65.camel@sipsolutions.net> (sfid-20150127_124337_047766_CF2F8687)
Subject: Re: [RFCv4 3/3] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 12:43:22 +0100
In-Reply-To: <CALhHN=oGGR=6bq90DB3wEN4Sq7rCCXEZLFR8x0sxot2+3JE=Aw@mail.gmail.com> (sfid-20150127_123951_413522_6EE70539)
References: <1422348243-4928-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1422348243-4928-3-git-send-email-janusz.dziedzic@tieto.com>
	 <1422354271.1890.62.camel@sipsolutions.net>
	 <CALhHN=oGGR=6bq90DB3wEN4Sq7rCCXEZLFR8x0sxot2+3JE=Aw@mail.gmail.com>
	 (sfid-20150127_123951_413522_6EE70539)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 12:39 +0100, Janusz Dziedzic wrote:
> On 27 January 2015 at 11:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2015-01-27 at 09:44 +0100, Janusz Dziedzic wrote:
> >
> >> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> >> +                             const struct cfg80211_chan_def *chandef)
> >
> >> +     /* 1 stream, MCS0-7 as a min Basic VHT MCS rates */
> >> +     vht_oper->basic_mcs_set = cpu_to_le16(0xfffc);
> >
> > Unless I'm mistaken in my reading of the spec, this will make any
> > well-behaved client (i.e. not mac80211) not join this network since it
> > supports VHT MCSes.
> >
> > We seem to do the same for HT:
> >
> >         /* It seems that Basic MCS set and Supported MCS set
> >            are identical for the first 10 bytes */
> >         memset(&ht_oper->basic_set, 0, 16);
> >         memcpy(&ht_oper->basic_set, &ht_cap->mcs, 10);
> >
> > but I'm not convinced it's right. It probably only works because nobody
> > ever tested against a well-behaved non-HT client? Or perhaps there isn't
> > even one?
> >
> for HT (spec, 20.3.5) - MCS0 .. MSC7 are mandatory - but this is for
> all stations (not sure about ibss)
> for VHT (22.5, table 22-30) - MCS0...MCS7 are mandatory for nss=1 (20,40,80)
> Seems such set is secure?
> 
> If I understand correctly case you describe with non-HT client:
> non-HT client should not understand HT ies, and HT-only client should
> not understand VHT ies?

Yeah that's a good point, I guess older clients won't even look at this,
and we don't include the HT or VHT marker in the basic rate set IE.

johannes


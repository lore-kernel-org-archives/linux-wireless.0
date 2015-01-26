Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54360 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbAZI0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:26:15 -0500
Message-ID: <1422260772.1890.7.camel@sipsolutions.net> (sfid-20150126_092618_647347_C3BEEB7B)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Jan 2015 09:26:12 +0100
In-Reply-To: <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com> (sfid-20150125_113036_230083_24A4666B)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	 <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	 (sfid-20150125_113036_230083_24A4666B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-01-25 at 12:30 +0200, Arik Nemtsov wrote:

> > +       switch (chandef->width) {
> > +       case NL80211_CHAN_WIDTH_80:
> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
> > +               break;
> > +       case NL80211_CHAN_WIDTH_80P80:
> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
> > +               vht_oper->center_freq_seg2_idx =
> > +                       ieee80211_frequency_to_channel(chandef->center_freq2);
> > +               break;
> > +       case NL80211_CHAN_WIDTH_160:
> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
> > +               break;
> > +       default:
> > +               return pos;
> > +       }
> 
> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
> have no use for it in IBSS I can add it later.

Why would you want to require VHT rates?

johannes


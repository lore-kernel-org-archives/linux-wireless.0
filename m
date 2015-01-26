Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54762 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbbAZJZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 04:25:08 -0500
Message-ID: <1422264304.1890.17.camel@sipsolutions.net> (sfid-20150126_102512_820895_F1698583)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Jan 2015 10:25:04 +0100
In-Reply-To: <CALhHN=r=Bzh=EyzurEGWWHo3ozYuCf-X6qdKv0tgas_MtvtA4Q@mail.gmail.com> (sfid-20150126_101905_892008_6CC288A3)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	 <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	 <1422260772.1890.7.camel@sipsolutions.net>
	 <CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com>
	 <1422262812.1890.12.camel@sipsolutions.net>
	 <CALhHN=r=Bzh=EyzurEGWWHo3ozYuCf-X6qdKv0tgas_MtvtA4Q@mail.gmail.com>
	 (sfid-20150126_101905_892008_6CC288A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-26 at 10:19 +0100, Janusz Dziedzic wrote:
> On 26 January 2015 at 10:00, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2015-01-26 at 10:37 +0200, Arik Nemtsov wrote:
> >
> >> >> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
> >> >> have no use for it in IBSS I can add it later.
> >> >
> >> > Why would you want to require VHT rates?
> >>
> >> Are you sure it's required and no the other way around in this case?
> >> As in specifying which rates are not supported.
> >> Not sure it means the same thing as in the HT instance.
> >
> > Well, it does mean the same thing ("these rates are required") but it's
> > encoded in a way that you have to set it to all-ones (rather than
> > all-zeroes) to mean "no requirements", so in that sense you're right.
> >
> 
> I already set this in the patch:
> +       vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;

But do you really want to require the local capabilities as basic MCSes?

johannes


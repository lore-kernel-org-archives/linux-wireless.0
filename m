Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:46347 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZCQVuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:50:07 -0400
Received: by ewy12 with SMTP id 12so221244ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 14:50:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 mesh support
Date: Tue, 17 Mar 2009 22:50:02 +0100
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <1237299098.31814.12.camel@johannes.local> <1237320625.10264.0.camel@johannes.local>
In-Reply-To: <1237320625.10264.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903172250.02427.IvDoorn@gmail.com> (sfid-20090317_225012_366993_60AC7E69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009, Johannes Berg wrote:
> On Tue, 2009-03-17 at 15:11 +0100, Johannes Berg wrote:
> 
> > > Thanks for the dumps, the reason why the beaconing isn't working
> > > is (fortunately) very obvious from the registers point of view.
> > > The "generate beacons" bit is simply not enabled. However the reason
> > > why this bit has not been set escapes me. Could you apply the attached
> > > patch? This will add extra debug messages to the driver to see when the
> > > beacon generation bit is set.
> > 
> > I think mac80211 is probably not requesting it until you scan -- since
> > once you scan it calls ieee80211_if_config internally and changes that
> > bit. Some mesh code needs to call ieee80211_if_config() with the beacon
> > enable change flag.
> 
> Actually, it does, in ieee80211_start_mesh(). I have no idea then.

I understood that in normal master mode rt73usb doesn't scan either,
so my bet is that the bug is in rt2x00. :)

Ivo

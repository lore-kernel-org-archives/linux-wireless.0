Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53882 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcBAM54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:57:56 -0500
Message-ID: <1454331473.3211.3.camel@sipsolutions.net> (sfid-20160201_135759_289209_D42E28A4)
Subject: Re: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	antonio@open-mesh.com, nbd@nbd.name
Date: Mon, 01 Feb 2016 13:57:53 +0100
In-Reply-To: <7460390.ua0GvOE4DE@bentobox> (sfid-20160201_135611_528149_53AC3A85)
References: <1454329450-31527-1-git-send-email-sven@open-mesh.com>
	 <1454329837.3211.2.camel@sipsolutions.net> <7460390.ua0GvOE4DE@bentobox>
	 (sfid-20160201_135611_528149_53AC3A85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 13:56 +0100, Sven Eckelmann wrote:
> On Monday 01 February 2016 13:30:37 Johannes Berg wrote:
> > On Mon, 2016-02-01 at 13:24 +0100, Sven Eckelmann wrote:
> > > The change from cur_tp to the function
> > > minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used
> > > for
> > > the
> > > current throughtput. For example in minstrel_ht the correct
> > > conversion between them would be:
> > > 
> > >     mrs->cur_tp / 10 == minstrel_ht_get_tp_avg(..).
> > > 
> > > This factor 10 must also be included in the calculation of
> > > minstrel_get_expected_throughput and
> > > minstrel_ht_get_expected_throughput to
> > > get similar results as before the change.
> > > 
> > 
> > 10 is a pretty expensive factor, perhaps that should use 16
> > instead?
> 
> Not really funny but I will change the title.

Huh? Not sure what you mean. I really meant to change 10 to 16 overall
as far as the factor is concerned, since division by/multiplication
with 16 is far easier in base 2 than by/with 10.

johannes

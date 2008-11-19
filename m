Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYKSVbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 16:31:20 -0500
Date: Wed, 19 Nov 2008 16:18:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rami Rosen <ramirose@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Message-ID: <20081119211826.GJ3485@tuxdriver.com> (sfid-20081119_223124_924576_06639F55)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> <1226943608.3902.36.camel@johannes.berg> <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> <1227106146.26243.43.camel@johannes.berg> <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> <1227107869.26243.52.camel@johannes.berg> <20081119160135.GB3485@tuxdriver.com> <1227126620.26243.71.camel@johannes.berg> <20081119210046.GC5900@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081119210046.GC5900@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 01:00:46PM -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 19, 2008 at 12:30:19PM -0800, Johannes Berg wrote:
> > On Wed, 2008-11-19 at 11:01 -0500, John W. Linville wrote:
> > 
> > > Is there some way we could take that into account?  I'm sure there
> > > are users who would prefer to have an AP (i.e. their laptop) that
> > > can't support PS clients rather than not having an AP at all.
> > 
> > That's a good question. The distinction here is between empowering users
> > to do the wrong thing (AP without proper PS support) and enforcing the
> > right thing (with the consequence of complete loss of AP functionality).
> > The issue I see here is that users will see "ohh shiny, AP support"
> > without knowing that it doesn't actually really support it. Not sure
> > which side of the line we want to stand on, I prefer the correctness
> > side but I can see arguments for the other side, would just like to have
> > users know. Maybe we could have some way to tell hostapd this and then
> > have hostapd print a huge warning about it when started up?
> 
> How about making it Kconfigable for broken AP support and add the
> warning there?

That doesn't really associate the bad behavior with specific drivers.
Probably better to send something do dmesg and/or make hostap aware
of the issue.

Any idea if many STAs are smart enough to stop going to sleep once
(or if) they realize they are missing frames?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

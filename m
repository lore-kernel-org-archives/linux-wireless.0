Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54382 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZH1PpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 11:45:24 -0400
Date: Fri, 28 Aug 2009 11:44:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, mickflemm@gmail.com,
	proski@gnu.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, ic.felix@gmail.com
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use
	in ath5k_eeprom_read_turbo_modes()
Message-ID: <20090828154410.GB32694@tuxdriver.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com> <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com> <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com> <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com> <20090827213921.GB30419@hash.localnet> <43e72e890908271614p58feb9bn2130e1c963685a55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890908271614p58feb9bn2130e1c963685a55@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 04:14:56PM -0700, Luis R. Rodriguez wrote:
> On Thu, Aug 27, 2009 at 2:39 PM, Bob Copeland<me@bobcopeland.com> wrote:
> > On Thu, Aug 27, 2009 at 11:25:03AM -0700, Luis R. Rodriguez wrote:
> >> > Well, we also don't use the turbo modes at all and that's where the
> >> > error is (IIRC) so it shouldn't have any impact. :)
> >>
> >> Again, why don't we just remove all that fucking turbo cruft?
> >
> > OK with me since no one seems to care enough to implement mac80211
> > support.  I left some of the #defines in place as they are useful
> > documentation.  Approx. 80 of the lines removed are comments.
> >
> >   text    data     bss     dec     hex filename
> >  136746     480      56  137282   21842 ath5k_old.ko
> >  134913     480      56  135449   21119 ath5k_new.ko
> >
> > Disclaimer: only barely tested.
> 
> Sexy, thanks!
> 
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

I think I am on the side of removing the non-standard extensions.
FWIW, I'll need a patch posted with a proper Subject and
Signed-off-by...

I think Nick has some valid points.  His position sounds similar to
that expressed to me by Felix and some others that it would be nice
if we could more easily accomodate some of the features of madwifi
that have made it attractive to researchers and experimenters.
Perhaps NL80211_CMD_TESTMODE relates to this desire?

Just a thought...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

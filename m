Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39080 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZKRNp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 08:45:26 -0500
Date: Wed, 18 Nov 2009 08:44:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janakiram Sistla <janakiram.sistla@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: 
Message-ID: <20091118134402.GA2911@tuxdriver.com>
References: <> <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com> <1258541631.30511.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258541631.30511.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 11:53:51AM +0100, Johannes Berg wrote:
> On Wed, 2009-11-18 at 07:20 +0530, Janakiram Sistla wrote:
> 
> > ---
> >  include/linux/rfkill.h |    2 ++
> >  net/rfkill/core.c      |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > index 3392c59..7ae75ef 100644
> > --- a/include/linux/rfkill.h
> > +++ b/include/linux/rfkill.h
> > @@ -35,6 +35,7 @@
> >   * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
> >   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
> >   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
> > + * @RFKILL_TYPE_FM: switch is on a wireless FM device.
> >   * @NUM_RFKILL_TYPES: number of defined rfkill types
> >   */
> >  enum rfkill_type {
> > @@ -44,6 +45,7 @@ enum rfkill_type {
> >  	RFKILL_TYPE_UWB,
> >  	RFKILL_TYPE_WIMAX,
> >  	RFKILL_TYPE_WWAN,
> > +	RFKILL_TYPE_FM,
> >  	RFKILL_TYPE_GPS,
> >  	NUM_RFKILL_TYPES,
> >  };
> 
> Nice try, but no fly. This struct is ABI, you cannot add in the middle.

Ah, good point -- I think I may have inadvertently encourage this
order. :-(

It looks like you'll need the other order -- be mindful of the
BUILD_BUG_ON I pointed-out in the previous email!

John

P.S.  Hmmm...anyone want to add a kerneldoc entry for RFKILL_TYPE_GPS?
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

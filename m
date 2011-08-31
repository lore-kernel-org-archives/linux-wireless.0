Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HaSmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 14:42:22 -0400
Date: Wed, 31 Aug 2011 11:33:05 -0700
From: Greg KH <gregkh@suse.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110831183305.GA11296@suse.de> (sfid-20110831_204226_033563_F32606BB)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de>
 <20110830014257.GI15771@broadcom.com>
 <20110830181452.GA24769@suse.de>
 <CAB=NE6WpuHdW000qdx4M1w21U8LjKYOX4nhc4kjjiZWwZpop6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAB=NE6WpuHdW000qdx4M1w21U8LjKYOX4nhc4kjjiZWwZpop6Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 10:55:45AM -0700, Luis R. Rodriguez wrote:
> On Tue, Aug 30, 2011 at 11:14 AM, Greg KH <gregkh@suse.de> wrote:
> > On Mon, Aug 29, 2011 at 06:42:57PM -0700, Henry Ptasinski wrote:
> >> The brcmsmac driver has architectural alignment with our drivers for other
> >> operating systems, and we intend to to enhance and maintain this driver in
> >> parallel with drivers for other operating systems.  Maintaining alignment
> >> between our Linux driver and drivers for other operating systems allows us to
> >> leverage feature and chip support across all platforms.
> >
> > Just curious, if you really are going to try to do this, how are you
> > going to handle the issue when others change the in-kernel driver in
> > ways that you are not going to be allowed to make to your "internal"
> > copy of the driver?
> 
> What do you mean by this?

 - Infrastructure changes that do not match up with how other operating
   systems handle things.
 - support for new features
 - support for older devices
 - license incompatibilities (i.e. new files under GPL-only license
 - etc.

> > Also, how are you going to handle any GPL-only changes that happen to
> > the code as well?
> 
> For the broadcom drivers this may be hard if people want to move GPLv2
> b43 code to a permissively licensed driver... but ...
> 
> > Do you have some process in place to ensure that all
> > contributions will have the proper copyright releases on it to allow you
> > to make the same changes to your internal versions?
> 
> To be clear *new* code going in to a permissively licensed driver
> follows the Developer's Certificate of Origin which does state the
> contributor follows the file's license.

For an existing file, yes.

But for new files, or for copying code from another driver (GPL only)
into this one (dual licensed), that's different, right?

You need to be very careful about this, that's all.

> The issues with a large GPLv2 code from b43 and the fact that the
> other driver is permissively licensed makes this a bit more
> complicated though, but that is only a reflection of not addressing
> supporting old hardware. Ouch.

Yes, this is going to be tricky :)

That is what I am worried about, but I know the lawyers and developers
at Broadcom have already considered this, but they haven't told us how
they are going to handle it, which is what I'm curious about.

Then there the issue that some companies want to keep their internal
copies in a non-dual licensed codebase, to handle the license of the
other operating systems they are working with.  Hopefully Broadcom isn't
going to do this, but others have in the past (SGI with xfs, Intel with
the ACPI core, etc.)

thanks,

greg k-h

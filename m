Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40243 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1LUUAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:00:36 -0500
Date: Wed, 21 Dec 2011 14:58:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3.2] iwlagn: fix (remove) use of PAGE_SIZE
Message-ID: <20111221195821.GF11842@tuxdriver.com> (sfid-20111221_210040_335225_9F381B36)
References: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
 <20111221161953.GB11842@tuxdriver.com>
 <1324482300.13074.295.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324482300.13074.295.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 07:45:00AM -0800, Guy, Wey-Yi wrote:
> Hi John,
> 
> On Wed, 2011-12-21 at 08:19 -0800, John W. Linville wrote:
> > On Mon, Dec 19, 2011 at 02:00:59PM -0800, Wey-Yi Guy wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > The ICT code erroneously uses PAGE_SIZE. The bug
> > > is that PAGE_SIZE isn't necessarily 4096, so on
> > > such platforms this code will not work correctly
> > > as we'll try to attempt to read an index in the
> > > table that the device never wrote, it always has
> > > 4096-byte pages.
> > > 
> > > Additionally, the manual alignment code here is
> > > unnecessary -- Documentation/DMA-API-HOWTO.txt
> > > states:
> > >   The cpu return address and the DMA bus master address are both
> > >   guaranteed to be aligned to the smallest PAGE_SIZE order which
> > >   is greater than or equal to the requested size.  This invariant
> > >   exists (for example) to guarantee that if you allocate a chunk
> > >   which is smaller than or equal to 64 kilobytes, the extent of the
> > >   buffer you receive will not cross a 64K boundary.
> > > 
> > > Just use appropriate new constants and get rid of
> > > the alignment code.
> > > 
> > > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > This seems like a big patch.  It is a bit late in the release cycle
> > to rewrite all the DMA allocation code. :-)
> > 
> > What platforms does this affect?  Are there actual users involved?
> 
> I understand the patch is bigger than the regular patch should be
> generated for stable kernel. Johannes can explain better, but he is on
> vacation. as what I understood, he work with community user who
> encounter issue and root cause it is PAGE SIZE cause the problem.
> 
> Thanks
> Wey

Unless someone screams, I'd be a lot more comfortable saving this
for 3.3.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

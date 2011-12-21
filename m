Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1LUQpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 11:45:35 -0500
Subject: Re: [PATCH 3.2] iwlagn: fix (remove) use of PAGE_SIZE
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20111221161953.GB11842@tuxdriver.com>
References: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20111221161953.GB11842@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 07:45:00 -0800
Message-ID: <1324482300.13074.295.camel@wwguy-huron> (sfid-20111221_174539_597165_89D7DE09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2011-12-21 at 08:19 -0800, John W. Linville wrote:
> On Mon, Dec 19, 2011 at 02:00:59PM -0800, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The ICT code erroneously uses PAGE_SIZE. The bug
> > is that PAGE_SIZE isn't necessarily 4096, so on
> > such platforms this code will not work correctly
> > as we'll try to attempt to read an index in the
> > table that the device never wrote, it always has
> > 4096-byte pages.
> > 
> > Additionally, the manual alignment code here is
> > unnecessary -- Documentation/DMA-API-HOWTO.txt
> > states:
> >   The cpu return address and the DMA bus master address are both
> >   guaranteed to be aligned to the smallest PAGE_SIZE order which
> >   is greater than or equal to the requested size.  This invariant
> >   exists (for example) to guarantee that if you allocate a chunk
> >   which is smaller than or equal to 64 kilobytes, the extent of the
> >   buffer you receive will not cross a 64K boundary.
> > 
> > Just use appropriate new constants and get rid of
> > the alignment code.
> > 
> > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> This seems like a big patch.  It is a bit late in the release cycle
> to rewrite all the DMA allocation code. :-)
> 
> What platforms does this affect?  Are there actual users involved?

I understand the patch is bigger than the regular patch should be
generated for stable kernel. Johannes can explain better, but he is on
vacation. as what I understood, he work with community user who
encounter issue and root cause it is PAGE SIZE cause the problem.

Thanks
Wey



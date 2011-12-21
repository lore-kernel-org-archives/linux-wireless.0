Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55299 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1LUQaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 11:30:35 -0500
Date: Wed, 21 Dec 2011 11:19:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 3.2] iwlagn: fix (remove) use of PAGE_SIZE
Message-ID: <20111221161953.GB11842@tuxdriver.com> (sfid-20111221_173045_728203_3F177509)
References: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 02:00:59PM -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The ICT code erroneously uses PAGE_SIZE. The bug
> is that PAGE_SIZE isn't necessarily 4096, so on
> such platforms this code will not work correctly
> as we'll try to attempt to read an index in the
> table that the device never wrote, it always has
> 4096-byte pages.
> 
> Additionally, the manual alignment code here is
> unnecessary -- Documentation/DMA-API-HOWTO.txt
> states:
>   The cpu return address and the DMA bus master address are both
>   guaranteed to be aligned to the smallest PAGE_SIZE order which
>   is greater than or equal to the requested size.  This invariant
>   exists (for example) to guarantee that if you allocate a chunk
>   which is smaller than or equal to 64 kilobytes, the extent of the
>   buffer you receive will not cross a 64K boundary.
> 
> Just use appropriate new constants and get rid of
> the alignment code.
> 
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This seems like a big patch.  It is a bit late in the release cycle
to rewrite all the DMA allocation code. :-)

What platforms does this affect?  Are there actual users involved?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

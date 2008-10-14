Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42793 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYJNPot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 11:44:49 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223997668.10113.40.camel@johannes.berg>
References: <1223308831.15196.28.camel@johannes.berg>
	 (sfid-20081006_180110_939098_1A64839A)  <1223309405.15196.32.camel@johannes.berg>
	 (sfid-20081006_181043_313891_E9288151)  <1223997668.10113.40.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 08:42:14 -0700
Message-Id: <1223998934.26421.1.camel@rc-desk> (sfid-20081014_174452_145448_A252372E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 17:21 +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 18:10 +0200, Johannes Berg wrote:
> > This patch cleans up the DMA code to be understandable and not
> > completely wrong. In particular:
> >  * there is no need to have a weird iwl_tfd_frame_data struct that is
> >    used 10 times, just use an address struct 20 times
> >  * therefore, all the is_odd junk goes away
> >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
> >    fragments of a descriptor rather than all descriptors (this may be
> >    the cause of the dma unmapping problem I reported)
> >  * some more cleanups
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Tested on 5000 hw, please apply.
> > 
> > v2: fixes small issue with getting rid of iwl_get_dma_hi_address.
> 
> John, can you apply this? I keep getting invalid frees, or double-frees
> without this patch.

Tomas reworked this patch. I will send the new patch upstream soon.

Reinette

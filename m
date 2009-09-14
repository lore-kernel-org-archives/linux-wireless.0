Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:58361 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbZINR7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 13:59:37 -0400
Date: Mon, 14 Sep 2009 18:59:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Frans Pop <elendil@planet.nl>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Krauss, Assaf" <assaf.krauss@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090914175942.GH11778@csn.ul.ie>
References: <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie> <1252617290.30150.321.camel@rc-desk> <20090911084717.GB32497@csn.ul.ie> <1252897270.5650.169.camel@debian> <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 11:42:15AM -0400, Christoph Lameter wrote:
> On Mon, 14 Sep 2009, Zhu Yi wrote:
> 
> > BTW, does SLAB/SLUB guarantee size of multiple PAGE_SIZE __kmalloc()
> > allocation align on PAGE_SIZE (or 256 bytes) boundary?
> 
> Page allocators guarantee page aligned data. Slab allocators do not.
> 
> You can create a slab that aligns objects on 256 byte boundary if you
> want.
> 

The allocation of buffers >= PAGE_SIZE even when allocated with
kmalloc() are page-aligned though right? It's not an explicit guarantee
but is it not always the case?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

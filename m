Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33036 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbZINPvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 11:51:33 -0400
Date: Mon, 14 Sep 2009 11:42:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
To: Zhu Yi <yi.zhu@intel.com>
cc: Mel Gorman <mel@csn.ul.ie>,
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
In-Reply-To: <1252897270.5650.169.camel@debian>
Message-ID: <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
References: <200909060941.01810.elendil@planet.nl>  <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>  <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>  <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie>
  <1252617290.30150.321.camel@rc-desk>  <20090911084717.GB32497@csn.ul.ie> <1252897270.5650.169.camel@debian>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 Sep 2009, Zhu Yi wrote:

> BTW, does SLAB/SLUB guarantee size of multiple PAGE_SIZE __kmalloc()
> allocation align on PAGE_SIZE (or 256 bytes) boundary?

Page allocators guarantee page aligned data. Slab allocators do not.

You can create a slab that aligns objects on 256 byte boundary if you
want.



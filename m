Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXEXHe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 03:34:26 -0400
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS  support
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200705232342.31882.flamingice@sourmilk.net>
References: <20070514051526.GA25582@mail.intel.com>
	 <200705232342.31882.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 24 May 2007 15:34:34 +0800
Message-Id: <1179992075.6150.30.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-05-23 at 23:42 -0700, Michael Wu wrote:
> The dls_info code looks like it was copied from the sta_info code and modified 
> to store what you need. No good.
> 
> Instead, you should modify struct sta_info to hold the information necessary. 

OK.

> > + if (dls_link_status(&sdata->u.sta, hdr.addr1) == DLS_STATUS_OK){
> How is this line suppose to work? I don't see hdr.addr1 initialized at any 
> point before this.

DLS must be setup before it can be used. The addr1 is inserted into the
dls hash table when the QSTA received a successful DLS response or
accepted a DLS request.

Thanks,
-yi

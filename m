Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15846 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbXEXH4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 03:56:47 -0400
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS  support
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200705240039.57564.flamingice@sourmilk.net>
References: <20070514051526.GA25582@mail.intel.com>
	 <200705232342.31882.flamingice@sourmilk.net>
	 <1179992075.6150.30.camel@debian.sh.intel.com>
	 <200705240039.57564.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 24 May 2007 15:56:56 +0800
Message-Id: <1179993416.6150.44.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-05-24 at 00:39 -0700, Michael Wu wrote:
> AFAICT, dls_link_status uses the second argument to look up the dls
> entry for the destination address. At this point, hdr.addr1 is not
> initialized to anything, so something is wrong here. 

You are right. It should be

dls_link_status(&sdata->u.sta, skb->data);

Thanks,
-yi

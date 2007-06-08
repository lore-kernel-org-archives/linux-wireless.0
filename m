Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31129 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934012AbXFHDlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 23:41:00 -0400
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200706071914.56402.flamingice@sourmilk.net>
References: <20070606082210.GA28649@mail.intel.com>
	 <200706071914.56402.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 11:40:19 +0800
Message-Id: <1181274019.3039.129.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-06-07 at 19:14 -0700, Michael Wu wrote:
> > +#define SET_TSINFO_ACK(i, d)         (i.short1 |= (d << 14) &
> 0xC000)
> > +
> Everything that touches short1 looks broken on big endian. 

No. These are safe on all endians as long as you touch short1 with these
macros. Because from the macro mask, you can see no value d is more than
a byte.

Thanks,
-yi

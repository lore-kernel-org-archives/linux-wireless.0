Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030631AbXFHQj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 12:39:27 -0400
Date: Sat, 9 Jun 2007 00:38:43 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070608163843.GA13276@mail.intel.com>
Reply-To: yi.zhu@intel.com
References: <20070606082210.GA28649@mail.intel.com> <200706071914.56402.flamingice@sourmilk.net> <1181274019.3039.129.camel@debian.sh.intel.com> <20070608121628.6c6a810d@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070608121628.6c6a810d@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 12:16:28PM +0200, Jiri Benc wrote:
> No. Michael is right and I'm really blind I haven't seen that myself.
> That's totally broken. You cannot do _any_ bit operation on __le16.
> 
> Let's assume that a value of short1 is 0x34 0x12 (two bytes as stored
> in a memory). Now let's look at the result of (short1 & 0xff).
> 
> On a LE platform that's (0x1234 & 0xff), i.e. 0x34.
> 
> On a BE platform that's (0x3412 & 0xff), i.e. 0x12.
> 
> How that could be correct?

You and Michael are right. The mask (i.e 0x00ff) need a cpu_to_le16()
in this case. I will replace the short with 2 bytes to fix this issue.

Thanks,
-yi

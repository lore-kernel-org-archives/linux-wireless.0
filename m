Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33824 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968526AbXFHKQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 06:16:21 -0400
Date: Fri, 8 Jun 2007 12:16:28 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070608121628.6c6a810d@griffin.suse.cz>
In-Reply-To: <1181274019.3039.129.camel@debian.sh.intel.com>
References: <20070606082210.GA28649@mail.intel.com>
	<200706071914.56402.flamingice@sourmilk.net>
	<1181274019.3039.129.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 08 Jun 2007 11:40:19 +0800, Zhu Yi wrote:
> On Thu, 2007-06-07 at 19:14 -0700, Michael Wu wrote:
> > > +#define SET_TSINFO_ACK(i, d)         (i.short1 |= (d << 14) &
> > 0xC000)
> > > +
> > Everything that touches short1 looks broken on big endian. 
> 
> No. These are safe on all endians as long as you touch short1 with these
> macros. Because from the macro mask, you can see no value d is more than
> a byte.

No. Michael is right and I'm really blind I haven't seen that myself.
That's totally broken. You cannot do _any_ bit operation on __le16.

Let's assume that a value of short1 is 0x34 0x12 (two bytes as stored
in a memory). Now let's look at the result of (short1 & 0xff).

On a LE platform that's (0x1234 & 0xff), i.e. 0x34.

On a BE platform that's (0x3412 & 0xff), i.e. 0x12.

How that could be correct?

 Jiri

-- 
Jiri Benc
SUSE Labs

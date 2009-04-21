Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZDUIhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:37:51 -0400
Subject: Re: [PATCH] cfg80211: mark all WEXT handlers _GPL
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1240302453.17388.5.camel@johannes.local>
References: <1240246179.4632.6.camel@johannes.local>
	 <1240276136.354.107.camel@debian> <1240302453.17388.5.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 16:31:54 +0800
Message-Id: <1240302714.354.130.camel@debian> (sfid-20090421_103754_577676_6B7E75F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-21 at 16:27 +0800, Johannes Berg wrote:
> On Tue, 2009-04-21 at 09:08 +0800, Zhu Yi wrote:
> > On Tue, 2009-04-21 at 00:49 +0800, Johannes Berg wrote:
> > > The fact that these are exported is a technical detail
> > > of the conversion period -- we don't want anybody to
> > > start relying on these. Ultimately we want things to
> > > use cfg80211 only, and once everything that is in wext
> > > is converted to cfg80211 drivers will not need to touch
> > > wext _at all_.
> > 
> > Johannes, why don't you want them to be used by others, say some fullmac
> > drivers? These functions can be used as glue from wext to cfg80211 in
> > the conversion period. After cfg80211 is ultimately used, they can be
> > removed all together of course.
> 
> I don't expect any binary drivers to start using them anyway, but on the
> odd chance that somebody was considering that ... I just don't want any
> arguments at the conversion point that "we still need these symbols
> because we released a driver that uses them" which would mean we
> couldn't actually convert properly.

Fair enough, no binary drivers. I don't have any problem with your
patch. Just the comment "we don't want anybody to start relying on
these" makes me confuse.

Thanks,
-yi


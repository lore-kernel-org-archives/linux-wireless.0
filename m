Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59489 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZBEM15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:27:57 -0500
Date: Thu, 5 Feb 2009 14:26:26 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205122626.GA19117@jm.kir.nu> (sfid-20090205_132800_234719_5723D2D9)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local> <20090205084407.GA11126@jm.kir.nu> <20090205111058.GA16422@jm.kir.nu> <1233834907.3931.4.camel@johannes.local> <20090205120730.GA18339@jm.kir.nu> <1233835854.3931.18.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1233835854.3931.18.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 01:10:54PM +0100, Johannes Berg wrote:

> Yeah, the truncation is a little worrying. I doubt any program but
> wpa_supplicant is prepared to handle that. Should we completely remove
> the entry, and add some new/custom piece to stream that indicates that
> we had to truncate here?

Well, the truncation is partly an artifact of the way iwe_stream_*
helpers work and I would expect all drivers to be doing this already
(should they support large enough number of BSSes to hit the limit). If
I have understood correctly, truncation happens between events, i.e., no
event (struct iw_event) itself is truncated; some events are just
missing from a BSS. As such, I would expect more or less all application
to handle that one way or another. They may assume the network does not
support WPA etc. based on some iw_events missing, but that should be
about it.

It would be somewhat cleaner to truncate between BSSes instead of
between iw_events, but it would be some more code (remember the length
before starting to add new BSS and use it if truncations was detected).
I don't think I would bother with custom iw_event stating that
truncation happened since I do not see much use for it in
wpa_supplicant. It could be of some use for someone running iwlist scan
manually.

-- 
Jouni Malinen                                            PGP id EFC895FA

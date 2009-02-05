Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50388 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbZBEJ42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 04:56:28 -0500
Date: Thu, 5 Feb 2009 11:52:17 +0200
From: Jouni Malinen <j@w1.fi>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205095217.GA13736@jm.kir.nu> (sfid-20090205_105639_833269_5514A8C3)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local> <20090205084407.GA11126@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090205084407.GA11126@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 10:44:07AM +0200, Jouni Malinen wrote:
> Trying to use 131072 byte buffer is actually a bug in wpa_supplicant and
> even the previous attempt of 65536 is not valid. I did not realize
> this before, but it was pointed out to me some time ago that the length
> field in struct iw_point is only 16 bits, so there is actually a strict
> limit of 65535 bytes of data available through SIOCGIWSCAN.
> 
> 65536 ends up being truncated into zero, so I would assume the largest
> buffer wpa_supplicant tries to use in practice is 32768 bytes. I'll fix
> this so that the next doubling is actually limited to 65535 (assuming it
> works with WEXT code in kernel). I would hope that this helps quite a
> bit as far as wpa_supplicant is concerned (almost doubling the maximum
> results buffers).

This moved the maximum from 88 BSSes (using IEEE 802.11g with WPA2 as an
example here; smaller number for 802.11n etc. extensions) to 177 BSSes
(or 178, but the last one was truncated, I think; the returned buffer
was 65534 bytes long). After that, things get bad, though, since there
is no way for the user space to fetch the buffer (at least with mac80211
scan reporting).

> As far as a possible workaround in kernel code is concerned,
> length=65535 could be considered a special case. Since it is clear that
> userspace cannot provide a larger buffer, there is not much point in
> returning -E2BIG. Instead, the results could be truncated after the last
> BSS that fit into the buffer and that would be returned to userspace.
> This is likely going to be much more useful than not being able to
> receive any result.

This should have helped with the test above when the number of BSSes
went past 178. Sure, all BSSes would not be reported, but should the
driver do any sorting based on BSS preference (e.g., signal strength),
this would likely work for most use cases.
 
-- 
Jouni Malinen                                            PGP id EFC895FA

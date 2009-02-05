Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43427 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZBEMP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:15:29 -0500
Date: Thu, 5 Feb 2009 14:12:22 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205121222.GB18339@jm.kir.nu> (sfid-20090205_131532_892788_F3209F2F)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local> <20090205084407.GA11126@jm.kir.nu> <20090205095217.GA13736@jm.kir.nu> <1ba2fa240902050344h1deb4c3dqce0949ec154faba4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240902050344h1deb4c3dqce0949ec154faba4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 01:44:15PM +0200, Tomas Winkler wrote:

> Just a thought If user space will be able to merge 2 scan results we
> can then split then in 2 separate reports....

Theoretically speaking, yes, WEXT could be extended to do this with some
kind of scan parameter that indicates which 64 kB block is requested.
However, I would not suggest going there and I would probably object to
a patch that tries to do this either in the kernel or in wpa_supplicant
for that matter.

If you really end up hitting a case that does not work reasonably well
with 64 kB fix in user space, I would suggest looking into the
cfg80211/nl80211 scan stuff. The only additional thing it needs in such
an environment is to get better optimized data structure (for which,
there is already a proposed implementation, too).

-- 
Jouni Malinen                                            PGP id EFC895FA

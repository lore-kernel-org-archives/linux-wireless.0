Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38476 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbZBEMKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:10:34 -0500
Date: Thu, 5 Feb 2009 14:07:30 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205120730.GA18339@jm.kir.nu> (sfid-20090205_131038_114865_9212084F)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local> <20090205084407.GA11126@jm.kir.nu> <20090205111058.GA16422@jm.kir.nu> <1233834907.3931.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1233834907.3931.4.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 12:55:07PM +0100, Johannes Berg wrote:

> Seems ok to me, since wext limits us to this anyway... But can we rely
> on userspace to (a) use the exactly largest buffer size and (b) be able
> to interpret that?

(a) Currently not, but once people realize that the length field has a
maximum value of 65535, using it as the largest attempt sounds like the
most logical choice. In other words, yes, this will require a small
change in programs that care (wpa_supplicant, which I already changed;
iwlist; etc.), but the change is minimal and not doing this does not break
anything new.

(b) Yes, user space apps better be prepared to read the results even if
the last entry is truncated (can happen with current kernel). There is
no clear way for the app to know that there could be more scan results
(well, it could guess that this is the case if the returned buffer is
very close to 64 kB), but it is not like scanning is that reliable
operation anyway, so applications better be prepared to not always
find every BSS in the results.

-- 
Jouni Malinen                                            PGP id EFC895FA

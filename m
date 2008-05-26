Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52095 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYEZJou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 05:44:50 -0400
Date: Mon, 26 May 2008 12:44:06 +0300
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/5] hostap: remove private "monitor" ioctl
Message-ID: <20080526094406.GI4932@jm.kir.nu> (sfid-20080526_114453_101280_6CE2A8C5)
References: <20080523015442.16636.92254.stgit@dv.roinet.com> <20080523015454.16636.44068.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080523015454.16636.44068.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 09:54:54PM -0400, Pavel Roskin wrote:
> This is an ioctl obsoleted by the monitor mode years ago.  Using it
> would trigger a deprecation warning.  As the wireless drivers
> standardize on the radiotap standard, the "monitor" ioctl cannot be
> preserved to work as obsolete software expects.

I don't follow the login here... Why "cannot be preserved"? I might go
with "we do not want to preserve this", but I do not see any technical
reason that would prevent us from supporting existing user space
interface that has been used in the past and may still be in use. Since
this may break existing user space programs, I do not think this should
go in. Obviously, same goes for removal of the actual use of this
parameter and support for different header formats in patch 5/5. Adding
support for radiotap format is of course reasonable, but I would be more
careful with removing existing functionality which may still be in use.

-- 
Jouni Malinen                                            PGP id EFC895FA

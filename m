Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1FSIFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:05:09 -0400
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if
 rate_lowest_index() fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20110615220252.1918.73638.stgit@mj.roinet.com> (sfid-20110616_000256_270703_19F4D5F9)
References: <20110615220252.1918.73638.stgit@mj.roinet.com>
	 (sfid-20110616_000256_270703_19F4D5F9)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:05:05 +0200
Message-ID: <1308470705.4145.1.camel@jlt3.sipsolutions.net> (sfid-20110619_100516_346429_A0CDA114)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-15 at 18:02 -0400, Pavel Roskin wrote:
> WARN_ON is not enough, as we cannot return a valid index, and the
> callers will use whatever we return, causing a cascade of oopses and
> eventually a panic.

Can you show the details of that? 0 should always be an at least
semi-valid index pointing to _something_ whereas -EINVAL will cause it
to point to random memory that isn't even valid...

johannes



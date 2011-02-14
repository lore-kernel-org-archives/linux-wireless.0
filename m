Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1BNMQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:16:06 -0500
Subject: Re: [PATCH 2/5] iwlwifi: Convert the tx queue high_mark to an
 atomic_t
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <1297619803-2832-3-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-3-git-send-email-njs@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:16:01 +0100
Message-ID: <1297685761.3785.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> This patch should cause no behavioral change whatsoever.

Right -- but it makes the TX path quite a bit more expensive on some
architectures. Why is this necessary? There should be locking in most
places already, and where not it should be easy to move this under the
existing lock.

johannes



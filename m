Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab1FVVDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 17:03:50 -0400
Subject: Re: [PATCH v2] mac80211: fix rx->key NULL dereference during mic
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1308776424-12109-1-git-send-email-arik@wizery.com> (sfid-20110622_230033_916576_AC5E16DC)
References: <1308776424-12109-1-git-send-email-arik@wizery.com>
	 (sfid-20110622_230033_916576_AC5E16DC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 23:03:46 +0200
Message-ID: <1308776626.29571.31.camel@jlt3.sipsolutions.net> (sfid-20110622_230353_379384_89DACE79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-23 at 00:00 +0300, Arik Nemtsov wrote:
> Sometimes when reporting a MIC failure rx->key may be unset. This
> code path is hit when receiving a packet meant for a multicast
> address, and decryption is performed in HW.
> 
> Fortunately, the failing key_idx is not used for anything up to
> (and including) usermode, so we allow ourselves to drop it on the
> way up when a key cannot be retrieved.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

Thanks. Since it fixes a crash, should it be Cc: stable@kernel.org?

johannes


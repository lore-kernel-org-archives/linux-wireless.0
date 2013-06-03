Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3FCO7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:59:13 -0400
Message-ID: <1370271547.8227.16.camel@jlt4.sipsolutions.net> (sfid-20130603_165926_231434_498F8381)
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Mon, 03 Jun 2013 16:59:07 +0200
In-Reply-To: <1370241587-2609-1-git-send-email-ordex@autistici.org>
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Users may want to send a frame on the current channel
> without specifying it.
> 
> Make mgmt_tx pass a NULL channel to mac80211 if none has
> been specified by the user.

cfg80211 isn't just a mac80211 frontend ... ;-)

Also, as Nicolas said, ath6kl_mgmt_tx() will crash after this patch if
it's called in AP mode w/o a channel, so you need to think about that.

Tracing looks fine though.

johannes


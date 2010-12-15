Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28210 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0LOM6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 07:58:35 -0500
Subject: Re: [PATCH] wl12xx: disable 11a channels when wl->enable_11a is
 known
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: geryk@ti.com
In-Reply-To: <1291388740-27218-1-git-send-email-luciano.coelho@nokia.com>
References: <1291388740-27218-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:00:38 +0200
Message-ID: <1292418038.32385.0.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-03 at 17:05 +0200, luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> Disabling the 11a channels when not supported in the reg_notify function was
> not working as it should, because when the driver is initiailizing (and
> registering itself with mac80211), it would get the reg notification too
> early.  At that point the driver wouldn't have received the NVS yet, so it
> wouldn't know whether 11a was supported.
> 
> To fix this, we disable 11a channels when we read the NVS instead.  Also, it
> is easier (and still safe) to set n_channels to zero instead of setting the
> disabled flag on every 11a channel.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>

Applied.

-- 
Cheers,
Luca.


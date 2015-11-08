Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:35216 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbKHXtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 18:49:35 -0500
Received: by qgec40 with SMTP id c40so70537750qge.2
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2015 15:49:35 -0800 (PST)
Date: Sun, 8 Nov 2015 18:49:23 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211_hwsim: stop using pointers as cookies
Message-ID: <20151108234923.GA30106@localhost> (sfid-20151109_004939_228200_DACB61AA)
References: <1446807443-12133-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446807443-12133-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2015 at 11:57:23AM +0100, Johannes Berg wrote:
> Instead of using pointers, use sequentially assigned cookies.
> This is easier to understand while debugging and also avoids
> problems when the pointer is reused for the next allocation.

I tested this out in wmediumd and it didn't go so well...

> +	info->rate_driver_data[0] = (void *)cookie;

[...]

> +		skb_cookie = (u64)(uintptr_t)txi->driver_data[0];

rate_driver_data vs driver_data?

-- 
Bob Copeland %% http://bobcopeland.com/

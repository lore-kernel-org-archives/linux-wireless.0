Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0GZHnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 03:43:06 -0400
Subject: Re: [PATCH] mac80211: simplify key locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100726013953.GA29386@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
	 <20100724053301.GA6773@jm.kir.nu>
	 <1279962385.8223.2.camel@jlt3.sipsolutions.net>
	 <20100726013953.GA29386@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 09:42:58 +0200
Message-ID: <1280130178.3693.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-07-25 at 18:39 -0700, Jouni Malinen wrote:

> The following seems to be more or less minimal patch with that
> approach to get rid of this oops with FT protocol.. Is this what you
> were looking for?

Well so to answer both your emails :-)

> -	ieee80211_key_disable_hw_accel(key);
> +	if (key->local)
> +		ieee80211_key_disable_hw_accel(key);

 
> -	ieee80211_debugfs_key_remove(key);
> +	if (key->local)
> +		ieee80211_debugfs_key_remove(key);

These might look odd, but they're fine on a key that hasn't been used
since it couldn't have been uploaded to hardware, or put into debugfs,
so they'll just exit right away.

The rest of the patch is exactly what I was thinking of.

johannes


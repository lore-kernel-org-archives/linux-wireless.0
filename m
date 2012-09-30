Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38764 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878Ab2I3Pw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 11:52:27 -0400
Message-ID: <1349020345.1958.1.camel@joe-AO722> (sfid-20120930_175231_013199_1AC37AED)
Subject: Re: [PATCH] mac80211: use __printf attribute in debugfs
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Sun, 30 Sep 2012 08:52:25 -0700
In-Reply-To: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net>
References: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 17:16 +0200, Johannes Berg wrote:
> The internal function mac80211_format_buffer() has a
> printf-style argument list, so add the attribute to
> have gcc verify that list.
[]
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
[]
> @@ -17,8 +17,8 @@
[]
> -int mac80211_format_buffer(char __user *userbuf, size_t count,
> -				  loff_t *ppos, char *fmt, ...)
> +int __printf(4, 5) mac80211_format_buffer(char __user *userbuf, size_t count,
> +					  loff_t *ppos, char *fmt, ...)
>  {
>  	va_list args;
>  	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];

Good idea, but this needs to be added to the prototype
in debugfs.h not on the function itself.


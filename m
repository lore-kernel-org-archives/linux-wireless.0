Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1CWTWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:22:35 -0400
Subject: Re: [PATCH] wifi:  Add hwflags to debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300908008-17676-1-git-send-email-greearb@candelatech.com>
References: <1300908008-17676-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 20:22:35 +0100
Message-ID: <1300908155.3790.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-23 at 12:20 -0700, greearb@candelatech.com wrote:

> +	sf += snprintf(buf, mxln - sf, "0x%x", local->hw.flags);
> +	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
> +		sf += snprintf(buf + sf, mxln - sf, " HAS_RATE_CONTROL");

Wouldn't it be easier to read with "<flag>\n" rather than " <flag>"?

> +static const struct file_operations hwflags_ops = {
> +	.read = hwflags_read,
> +	.open = mac80211_open_file_generic,
> +	.llseek = default_llseek,
> +};

I think it'd make sense to split up the DEBUGFS_READONLY_FILE macro and
use it?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1BBSzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 13:55:43 -0500
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296670694-28596-1-git-send-email-greearb@candelatech.com>
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 19:55:41 +0100
Message-ID: <1296672941.5671.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 10:18 -0800, greearb@candelatech.com wrote:

> * Do no blindly go off/on channel in work.c  Instead, only call
>   appropriate on/off code when we really need to change channels.

Based on the powersave comments I had earlier, maybe we should remove
that bit for now? Work items here require powersave is disabled, but we
won't do that right now if we're on the same channel.

Scan, on the other hand, will still disable powersave (right?)

johannes


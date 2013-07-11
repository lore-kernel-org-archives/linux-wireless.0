Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3GKIv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:51:27 -0400
Message-ID: <1373532681.8201.1.camel@jlt4.sipsolutions.net> (sfid-20130711_105131_722883_C753E084)
Subject: Re: [WT PATCH 1/6] mac80211: Add debugfs file to show station-hash
 counts.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 10:51:21 +0200
In-Reply-To: <1372546738-25827-1-git-send-email-greearb@candelatech.com> (sfid-20130630_005921_608423_933F950E)
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130630_005921_608423_933F950E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Helps debug bad hash spreads, like when you have lots of
> station interfaces all connected to the same AP.

I'm willing to take this patch, but

> +			res += sprintf(buf + res, "%i: %i\n", q, cnt);
> +			if (res >= (STA_HASH_SIZE * 10)) {
> +				res = STA_HASH_SIZE * 10;
> +				break;

tihs needs to use "maxln" (what does that variable mean anyway? it's
more like "bufsize"?) and snprintf().

johannes


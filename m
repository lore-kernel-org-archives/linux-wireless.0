Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3GKIwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:52:51 -0400
Message-ID: <1373532768.8201.2.camel@jlt4.sipsolutions.net> (sfid-20130711_105254_462816_20E02892)
Subject: Re: [WT PATCH 2/6] mac80211: Make un-found-rate splat a warn-once.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 10:52:48 +0200
In-Reply-To: <1372546738-25827-2-git-send-email-greearb@candelatech.com> (sfid-20130630_005926_867232_CB3CEEA7)
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	 <1372546738-25827-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130630_005926_867232_CB3CEEA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> After that, print it out with net_ratelimit.  We saw a system
> continually hit this warning, for reasons unknown, and it
> seems it bogged the system down enough to make it go OOM.

I've hardly seen this in practice, let's just make it ratelimited
always.

I think maybe sdata_info_ratelimited() or so would be worthwhile.

Might also stick in an unlikely().

johannes



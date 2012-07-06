Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60465 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2GFNP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 09:15:59 -0400
Received: by ghrr11 with SMTP id r11so8559066ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 06:15:59 -0700 (PDT)
Message-ID: <4FF6E50B.4090205@lwfinger.net> (sfid-20120706_151604_648506_67476605)
Date: Fri, 06 Jul 2012 08:15:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix crash with single-queue drivers
References: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2012 05:53 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Larry (and some others I think) reported that with
> single-queue drivers mac80211 crashes when waking
> the queues. This happens because we allocate just
> a single queue for each virtual interface in case
> the driver doesn't have at least 4 queues, but the
> code stopping/waking the virtual interface queues
> wasn't taking this into account.
>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mac80211/util.c |   12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

This patch fixes the problem for drivers that always report a single queue such 
as at76c503-usb. There is still a problem for b43 with open-source firmware 
where the number of queues changes from 4 to 1. As that only affects b43, do you 
agree that the problem should be fixed there?

Larry

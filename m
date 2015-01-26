Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54368 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbAZI1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:27:24 -0500
Message-ID: <1422260840.1890.9.camel@sipsolutions.net> (sfid-20150126_092726_726685_3DDCAF40)
Subject: Re: [PATCH] nl80211: add new scan flag to indicate P2P search
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 26 Jan 2015 09:27:20 +0100
In-Reply-To: <1422189052-25602-1-git-send-email-dlansky@codeaurora.org>
References: <1422189052-25602-1-git-send-email-dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-01-25 at 14:30 +0200, Dedy Lansky wrote:
> Scan request (NL80211_CMD_TRIGGER_SCAN) is used for triggering both scan
> and P2P search.
> At driver/firmware layer, scan and P2P search might be handled differently.
> 
> Add new scan flag to indicate P2P search. This flag can be used
> by applications (e.g. wpa_supplicant) to explicitly request P2P search.

I think this ship has sailed many months ago -- too late, you can never
rely on wpa_supplicant settings this flag.

If you need to distinguish, you should be able to advertise P2P-Device
supports, and then get P2P scans on the P2P-Device virtual interface.
Could be a pure driver thing of course.

johannes


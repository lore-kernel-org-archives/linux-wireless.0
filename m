Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab3JQOgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:36:02 -0400
Message-ID: <1382020558.14410.11.camel@jlt4.sipsolutions.net> (sfid-20131017_163606_692194_1958770D)
Subject: Re: [PATCH 1/2] cfg80211: on ibss_joined use the channel to get the
 proper bss object
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Thu, 17 Oct 2013 16:35:58 +0200
In-Reply-To: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 00:38 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> It may be the case that the same IBSS (same bssid and essid)
> exists on two different channels (i.e. two IBSSes created
> with different but fixed freq) and therefore the latter must
> be also used to distinguish them.
> 
> Fix wdev->current_bss assignment by passing the channel to
> cfg80211_get_bss() on ibss_joined.
> This ensures that cfg80211_get_bss() picks up the proper bss
> object.

This makes no sense, wdev->channel should always be NULL (unless the
same wdev was in AP or mesh mode first and that somehow leaked out?)

johannes


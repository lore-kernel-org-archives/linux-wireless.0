Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3FKLPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:15:25 -0400
Message-ID: <1370949320.8356.2.camel@jlt4.sipsolutions.net> (sfid-20130611_131534_931433_4BEBA03E)
Subject: Re: [PATCH v2 1/2] mac80211: fix mesh deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Tue, 11 Jun 2013 13:15:20 +0200
In-Reply-To: <1370895442-21784-1-git-send-email-thomas@cozybit.com> (sfid-20130610_221953_296737_CF41059A)
References: <1370895442-21784-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130610_221953_296737_CF41059A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-10 at 13:17 -0700, Thomas Pedersen wrote:
> The patch "cfg80211/mac80211: use cfg80211 wdev mutex in
> mac80211" introduced several deadlocks by converting the
> ifmsh->mtx to wdev->mtx. Solve these by:
> 
> 1. drop the cancel_work_sync() in ieee80211_stop_mesh().
>    Instead make the mesh work conditional on whether the mesh
>    is running or not.
> 2. lock the mesh work with sdata_lock() to protect beacon
>    updates and prevent races with wdev->mesh_id_len or
>    cfg80211.

Applied, thanks.

johannes


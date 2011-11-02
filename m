Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1KBKSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 06:18:36 -0400
Subject: Re: [PATCH 1/4] mac80211: Avoid filling up mesh preq queue with
 redundant requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1319864732-11286-1-git-send-email-thomas@cozybit.com> (sfid-20111029_070610_804404_15F11A15)
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
	 (sfid-20111029_070610_804404_15F11A15)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 11:18:30 +0100
Message-ID: <1320229110.3950.41.camel@jlt3.sipsolutions.net> (sfid-20111102_111840_018314_DE35EA25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 22:05 -0700, Thomas Pedersen wrote:

> @@ -1062,6 +1072,7 @@ void mesh_path_timer(unsigned long data)
>  		++mpath->discovery_retries;
>  		mpath->discovery_timeout *= 2;
>  		spin_unlock_bh(&mpath->state_lock);
> +		mpath->flags &= ~MESH_PATH_REQ_QUEUED;

locking spot-check -- is that really correct?

johannes


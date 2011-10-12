Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1JLIc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:32:26 -0400
Subject: Re: [RFC 07/07] mac80211: Do not call release_buffered_frames if
 not available.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27ru2maya27un@edmitar> (sfid-20111012_030258_417331_5CE804F3)
References: <op.v27ru2maya27un@edmitar>
	 (sfid-20111012_030258_417331_5CE804F3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:32:23 +0200
Message-ID: <1318408343.3933.29.camel@jlt3.sipsolutions.net> (sfid-20111012_103229_788409_BDB7AA0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
> From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> Date: Wed, 5 Oct 2011 13:20:04 +0200
> 
> A new .release_buffered_frames callback was introduced recently.
> Check for the callback presence was missing in the mac80211 code,
> and PM state could get broken in some cases.

Interesting, but we do check:

drv_release_buffered_frames(struct ieee80211_local *local,
                            struct sta_info *sta, u16 tids, int num_frames,
                            enum ieee80211_frame_release_type reason,
                            bool more_data)
{
        trace_drv_release_buffered_frames(local, &sta->sta, tids, num_frames,
                                          reason, more_data);
        if (local->ops->release_buffered_frames)
                local->ops->release_buffered_frames(&local->hw, &sta->sta, tids,


So whatever you're trying to do must be something else.

johannes


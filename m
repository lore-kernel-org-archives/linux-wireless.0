Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab2JSNuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:50:15 -0400
Message-ID: <1350654649.10678.3.camel@jlt4.sipsolutions.net> (sfid-20121019_155020_444396_C389EE3E)
Subject: Re: [PATCH 2/2] [nl,cfg,mac]80211: Add nl80211 command to get mesh
 network statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Fri, 19 Oct 2012 15:50:49 +0200
In-Reply-To: <1349814468-6512-2-git-send-email-ashok@cozybit.com> (sfid-20121009_222803_617605_1E8764DF)
References: <1349814468-6512-1-git-send-email-ashok@cozybit.com>
	 <1349814468-6512-2-git-send-email-ashok@cozybit.com>
	 (sfid-20121009_222803_617605_1E8764DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-09 at 13:27 -0700, Ashok Nagarajan wrote:

>  /**
> + * struct mesh_stats - 802.11s mesh statistics
> + *
> + * Used to provide statistical information about mesh
> + *
> + * @fwded_mcast: Mesh forwarded multicast frames
> + * @fwded_unicast: Mesh forwarded unicast frames
> + * @fwded_frames: Mesh total forwarded frames
> + * @dropped_frames_ttl: Not transmitted since mesh_ttl == 0
> + * @dropped_frames_no_route: Not transmitted, no route found
> + * @dropped_frames_congestion: Not forwarded due to congestion
> + */
> +struct mesh_stats {
> +	u32 fwded_mcast;

Would it make sense to use u64 right away? A lot of netdev stats were at
some point extended from u32 to u64 and that caused problems, maybe
using u64 right away here would be good?

johannes


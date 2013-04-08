Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56170 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965131Ab3DHV1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 17:27:48 -0400
Message-ID: <1365456467.2029.16.camel@joe-AO722> (sfid-20130408_232759_460554_EA53F957)
Subject: Re: [PATCH 5/6] mac80211: stringify another plink state
From: Joe Perches <joe@perches.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 08 Apr 2013 14:27:47 -0700
In-Reply-To: <1782507887.154.1365455855469.JavaMail.mail@webmail12>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1782507887.154.1365455855469.JavaMail.mail@webmail12>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
> The patch "mac80211: stringify mesh peering events" missed
> an opportunity to print the peering state as a string.

Perhaps it's better to use functions for these instead of
indexing in case an index is somehow incorrectly set.

> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
[]
> @@ -544,8 +544,8 @@ static void mesh_plink_timer(unsigned long data)
>  		return;
>  	}
>  	mpl_dbg(sta->sdata,
> -		"Mesh plink timer for %pM fired on state %d\n",
> -		sta->sta.addr, sta->plink_state);
> +		"Mesh plink timer for %pM fired on state %s\n",
> +		sta->sta.addr, mplstates[sta->plink_state]);




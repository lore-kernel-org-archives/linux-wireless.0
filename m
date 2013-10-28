Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3J1On2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:43:28 -0400
Message-ID: <1382971400.17956.28.camel@jlt4.sipsolutions.net> (sfid-20131028_154334_521801_92C7CC5E)
Subject: Re: [PATCH] cfg80211: clarify DFS / CAC case for the new NO-IR flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	janusz.dziedzic@tieto.com, smihir@qti.qualcomm.com,
	tushnimb@qca.qualcomm.com
Date: Mon, 28 Oct 2013 15:43:20 +0100
In-Reply-To: <1382376440-25838-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192725_639430_71EBE1FD)
References: <1382376440-25838-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131021_192725_639430_71EBE1FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-21 at 19:27 +0200, Luis R. Rodriguez wrote:
> Now that the no-ibss and passive-scan flags are bundled
> together its a lot easier to deal with the case of when
> we support DFS. If DFS is supported on the wiphy and if
> the Channel availability check (CAC) has been cleared on
> the channel (dfs_state is NL80211_DFS_AVAILABLE) we can
> ignore the no-ir flag.
> 
> This simplifies the paranoid requirement of bundling
> together DFS and NO-IR cases by placing onus on the
> DFS implementation. If code paths also want to reuse
> knowledge from DFS state machines they must also ensure
> that they always look at and monitor the dfs_state.

Please resend this as part of the other series when my comment there is
sorted out. (Unless nothing is needed, in which case just remind me to
pick this up if I forget)

johannes


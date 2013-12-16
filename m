Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3LPUb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 15:31:56 -0500
Message-ID: <1387225907.2057.35.camel@jlt4.sipsolutions.net> (sfid-20131216_213159_708659_53FF4D00)
Subject: Re: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 21:31:47 +0100
In-Reply-To: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131216_165106_255388_711937BF)
References: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com>
	 (sfid-20131216_165106_255388_711937BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 16:50 +0100, Marek Puzyniak wrote:
> In AP mode DFS channel state is changed to DFS_AVAILABLE
> after successful CAC and remains as such until a radar
> signal is detected during the In-Service Monitoring.
> When AP is stopped it is no longer monitoring current channel
> for radar signals. DFS channel state should be changed
> to DFS_USABLE when last AP interface is stopped. Starting AP
> again on that channel will start CAC instead of starting radiation.

Applied. Since it didn't apply/compile on 3.13, I put it into -next
(even though you said before that it should be in 3.13 ... sorry. gotta
make sure your patches actually apply where you want them)

johannes


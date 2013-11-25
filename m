Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3KYQnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:43:11 -0500
Message-ID: <1385397787.4443.54.camel@jlt4.sipsolutions.net> (sfid-20131125_174315_237280_26765460)
Subject: Re: [PATCH v2 4/4] cfg80211: DFS use 10 minutes CAC when weather
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 25 Nov 2013 17:43:07 +0100
In-Reply-To: <1384940517-6154-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131120_104224_778593_81B2F202)
References: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1384940517-6154-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131120_104224_778593_81B2F202)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 10:41 +0100, Janusz Dziedzic wrote:
> When nominal bandwidth falls completely or partly
> within the band 5600MHz to 5650MHz the CAC time shall
> be 10 minutes.

I wonder if those 10 minutes should come from the regdb somehow? You had
a TODO there somewhere but maybe it should just be the timeout rather
than a flag?

> +       start_freq = cfg80211_get_start_freq(center_freq, bandwidth) -
> 10;
> +       end_freq = cfg80211_get_end_freq(center_freq, bandwidth) + 10;

That seems wrong for wider channels - didn't we just add support for
that?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37116 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaJTMCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:02:40 -0400
Message-ID: <1413806542.10246.21.camel@jlt4.sipsolutions.net> (sfid-20141020_140243_394048_D76951A8)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 14:02:22 +0200
In-Reply-To: <21572.60015.349942.74265@gargle.gargle.HOWL>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	 <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	 <21568.29077.518022.812356@gargle.gargle.HOWL>
	 <1413797588.10246.3.camel@jlt4.sipsolutions.net>
	 <21572.55536.308167.684155@gargle.gargle.HOWL>
	 <1413798712.10246.14.camel@jlt4.sipsolutions.net>
	 <21572.58249.490532.207564@gargle.gargle.HOWL>
	 <1413801423.10246.16.camel@jlt4.sipsolutions.net>
	 <21572.60015.349942.74265@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 16:26 +0530, Sujith Manoharan wrote:

> Here is a trace log showing the issue - cfg80211_scan_done()
> is called after NETDEV_DOWN is received in cfg80211_netdev_notifier_call().
> 
> http://pastebin.com/raw.php?i=AJqFLtZR
> 
> I've removed entries to show the issue clearly, if
> you need the full trace, please let me know.

Ah, so mac80211 is also delaying and not doing the right thing ... need
to look at that.

johannes


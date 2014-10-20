Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36637 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbaJTKhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:37:10 -0400
Message-ID: <1413801423.10246.16.camel@jlt4.sipsolutions.net> (sfid-20141020_123715_362807_04F38F02)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 12:37:03 +0200
In-Reply-To: <21572.58249.490532.207564@gargle.gargle.HOWL> (sfid-20141020_122629_033759_85FDFBFF)
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	 <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	 <21568.29077.518022.812356@gargle.gargle.HOWL>
	 <1413797588.10246.3.camel@jlt4.sipsolutions.net>
	 <21572.55536.308167.684155@gargle.gargle.HOWL>
	 <1413798712.10246.14.camel@jlt4.sipsolutions.net>
	 <21572.58249.490532.207564@gargle.gargle.HOWL>
	 (sfid-20141020_122629_033759_85FDFBFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:57 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > But the driver can/should just do it when the interface is removed from
> > it? Otherwise it has no valid way to run/continue the scan anyway?
> 
> cancel_hw_scan() is called before remove_interface() and if the
> interface is removed in cfg80211 before __cfg80211_scan_done() gets
> a chance to run, then this warning is hit.

I'm not sure that's true - the WARN_ON you're modifying keys off
something that happens in cfg80211_scan_done(), not
__cfg80211_scan_done(), so as long as the driver called
cfg80211_scan_done() properly things should be OK?

How are you implementing cancel_hw_scan()? You need to call
ieee80211_scan_completed() by the time the function returns.

johannes


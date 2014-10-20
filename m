Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44394 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaJTKzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:55:53 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.60015.349942.74265@gargle.gargle.HOWL> (sfid-20141020_125556_301580_4F89AFA9)
Date: Mon, 20 Oct 2014 16:26:47 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <1413801423.10246.16.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
	<21572.58249.490532.207564@gargle.gargle.HOWL>
	<1413801423.10246.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I'm not sure that's true - the WARN_ON you're modifying keys off
> something that happens in cfg80211_scan_done(), not
> __cfg80211_scan_done(), so as long as the driver called
> cfg80211_scan_done() properly things should be OK?

Here is a trace log showing the issue - cfg80211_scan_done()
is called after NETDEV_DOWN is received in cfg80211_netdev_notifier_call().

http://pastebin.com/raw.php?i=AJqFLtZR

I've removed entries to show the issue clearly, if
you need the full trace, please let me know.

> How are you implementing cancel_hw_scan()? You need to call
> ieee80211_scan_completed() by the time the function returns.

Yes, that's what we do in ath9k.

Sujith

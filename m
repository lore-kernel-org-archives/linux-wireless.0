Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaBCNYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:24:34 -0500
Message-ID: <1391433871.4488.18.camel@jlt4.sipsolutions.net> (sfid-20140203_142437_137242_497D5AB3)
Subject: Re: [RFC 0/2] cfg80211: add channel switching awareness
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 14:24:31 +0100
In-Reply-To: <1391431407.4488.9.camel@jlt4.sipsolutions.net> (sfid-20140203_134402_047400_66535498)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110347_817013_693B94E8) <1391431407.4488.9.camel@jlt4.sipsolutions.net>
	 (sfid-20140203_134402_047400_66535498)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 13:43 +0100, Johannes Berg wrote:

> > The channel switch is split into two phases now -
> > start and finalize. This is required to make
> > cfg80211 in control of the whole channel
> > switching process. It also makes it apparent that
> > mac80211's STA CSA offload doesn't work quite well
> > here. Can we kill it?
> 
> No. Well, you could make cfg80211 be in charge, but not wpa_supplicant,
> I think.

Actually, that might not make sense either, most non-mac80211 devices
would probably do that in firmware anyway and locking in the API to do
it "like mac80211" would thus probably be a bad idea.

johannes


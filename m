Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3BIVKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2013 16:10:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4Hh4-0004NH-5h
	for linux-wireless@vger.kernel.org; Sat, 09 Feb 2013 22:10:42 +0100
Message-ID: <1360444240.8394.2.camel@jlt4.sipsolutions.net> (sfid-20130209_221051_215866_8C1BEBBF)
Subject: Re: [RFC 14/14] mac80211: properly track HT/VHT operation changes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Sat, 09 Feb 2013 22:10:40 +0100
In-Reply-To: <1360344344-15742-15-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183812_452599_890EF4AF)
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
	 <1360344344-15742-15-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130208_183812_452599_890EF4AF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 18:25 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> A while ago, I made the mac80211 station code never change
> the channel type after association. This solved a number of
> issues but is ultimately wrong,

I should say that the reason for that originally was that we would
change from non-HT to HT during association, and generally switch
channels far too much (auth/assoc was kinda off-channel then). Changing
just the bandwidth while already doing HT (or VHT!) shouldn't be an
issue.

johannes


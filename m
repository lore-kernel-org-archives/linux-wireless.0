Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2GJJNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:13:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SoWVI-0007ju-GT
	for linux-wireless@vger.kernel.org; Tue, 10 Jul 2012 11:13:08 +0200
Message-ID: <1341911586.4475.7.camel@jlt3.sipsolutions.net> (sfid-20120710_111314_349602_18EF8A00)
Subject: Re: [PATCH] mac80211: optimize ieee80211_rx_status struct layout
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 10 Jul 2012 11:13:06 +0200
In-Reply-To: <1341911478-13342-1-git-send-email-johannes@sipsolutions.net> (sfid-20120710_111127_712290_B064822B)
References: <1341911478-13342-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120710_111127_712290_B064822B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 11:11 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We waste a lot of space in this struct because it uses
> int values where smaller ones would be sufficient. The
> upcoming A-MPDU information needs some space, optimize
> the struct now.

It'll be a few weeks until the A-MPDU stuff is adopted in radiotap, but
I figured this could still go upstream already. The previous patch (time
sync) was based on it (and accidentally the A-MPDU stuff, so it won't
apply as is, but I've fixed that)

johannes


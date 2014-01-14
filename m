Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANMym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 07:54:42 -0500
Message-ID: <1389704078.32635.0.camel@jlt4.sipsolutions.net> (sfid-20140114_135445_713029_4A02D7CA)
Subject: Re: [PATCH] mac80211: move roc cookie assignment earlier
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 13:54:38 +0100
In-Reply-To: <1389517597-3865-1-git-send-email-eliad@wizery.com> (sfid-20140112_100643_457507_2FA01435)
References: <1389517597-3865-1-git-send-email-eliad@wizery.com>
	 (sfid-20140112_100643_457507_2FA01435)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-12 at 11:06 +0200, Eliad Peller wrote:
> ieee80211_start_roc_work() might add a new roc
> to existing roc, and tell cfg80211 it has already
> started.
> 
> However, this might happen before the roc cookie
> was set, resulting in REMAIN_ON_CHANNEL (started)
> event with null cookie. Consequently, it can make
> wpa_supplicant go out of sync.
> 
> Fix it by setting the roc cookie earlier.

Applied (to mac80211.git), I also decided to add a Cc stable tag. I'm
not going to send any more pull requests until the merge window closes,
so it'll be a while.

johannes


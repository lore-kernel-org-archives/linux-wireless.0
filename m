Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2GJLGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 07:06:10 -0400
Message-ID: <1341918365.4475.9.camel@jlt3.sipsolutions.net> (sfid-20120710_130619_750954_597003B6)
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Jul 2012 13:06:05 +0200
In-Reply-To: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 15:37 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Previously we would check in nl80211 with an empty
> cfg80211_wowlan structure to check for 'iw phy phyX wowlan enable'
> with empty arguments (or) no triggers and disable WoWLAN.

No ... that's not how it works. If you enable WoWLAN without any
triggers, then that's what you get: the connection is kept alive but
there are no wakeup sources. If you don't specify the triggers at all
then it's disabled.

johannes


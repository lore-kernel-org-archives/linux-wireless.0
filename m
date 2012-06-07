Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38694 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555Ab2FGGZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 02:25:10 -0400
Message-ID: <1339050308.6009.9.camel@joe2Laptop> (sfid-20120607_082515_499616_6DB3AEC5)
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 23:25:08 -0700
In-Reply-To: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 11:32 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> ratelimit few aggregation related messages, these messages
> floods the log when aggregation is disabled in the AP(for some
> wifi testcases) and we run traffic between STA and AP.

I looked at all of the #ifdef CONFIG_MAC80211_HT_DEBUG uses.

I think it's better simply to define a mac80211_ht_dbg
macro for each of the !CONFIG and CONFIG cases and convert
all of the other #ifdef CONFIG_MAC80211_HT_DEBUG logging
messages.

#ifdef CONFIG_MAC80211_HT_DEBUG
#define mac80211_ht_dbg(fmt, ...)				\
	net_dbg_ratelimited(fmt, ##__VA_ARGS__)
#else
#define mac80211_ht_dbg(fmt, ...)				\
do {								\
	if (0)							\
		net_dbg_ratelimited(fmt, ##__VA_ARGS__);	\
} while (0)

etc...

I think there's one use of wiphy_dbg that could be a
mac80211_ht_dbg without much loss.

Maybe add "%s", wiphy_name() to the args there.

cheers, Joe


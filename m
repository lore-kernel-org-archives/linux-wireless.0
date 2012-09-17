Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2IQPRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:17:53 -0400
Message-ID: <1347895109.4975.8.camel@jlt4.sipsolutions.net> (sfid-20120917_171756_999251_8DA9CBAF)
Subject: Re: [PATCH] cfg80211: fix possible circular lock on
 reg_regdb_search()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Sep 2012 17:18:29 +0200
In-Reply-To: <1347662217-4292-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20120915_003707_554322_87F22985)
References: <1347662217-4292-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20120915_003707_554322_87F22985)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-14 at 15:36 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> When call_crda() is called we kick off a witch hunt search
> for the same regulatory domain on our internal regulatory
> database and that work gets kicked off on a workqueue, this
> is done while the cfg80211_mutex is held. If that workqueue
> kicks off it will first lock reg_regdb_search_mutex and
> later cfg80211_mutex but to ensure two CPUs will not contend
> against cfg80211_mutex the right thing to do is to have the
> reg_regdb_search() wait until the cfg80211_mutex is let go.
> 
> The lockdep report is pasted below.

[...]

This looks fine to me,

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

John, if you think this can still go to wireless.git can you please
apply it? Otherwise I'll take it into mac80211-next.git.

johannes


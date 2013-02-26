Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BZUt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:49:28 -0500
Message-ID: <1361911760.8440.15.camel@jlt4.sipsolutions.net> (sfid-20130226_214931_904381_7AC00BA2)
Subject: Re: [PATCH 3/6] mac80211: cleanup generic suspend/resume procedures
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 26 Feb 2013 21:49:20 +0100
In-Reply-To: <1361793008-2857-3-git-send-email-sgruszka@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
	 <1361793008-2857-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 12:50 +0100, Stanislaw Gruszka wrote:

> @@ -95,17 +75,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>  			WARN_ON(err != 1);
>  			local->wowlan = false;
>  		} else {

Hmmm! The context here reminds me that it is possible to have WoWLAN
configured, but have the driver reject it and then suspend "normally".
Our driver seems to be the only one doing it (both dvm and mvm flavours)
and it does it only in case we aren't connected ...

However overall this patchset will break the functionality, if WoWLAN is
enabled but not possible we won't cleanly disconnect. This is a bit of a
problem, I guess we need to propagate this return value behaviour all
the way into cfg80211 where the cfg80211_leave() can then be called?

johannes


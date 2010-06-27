Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0F0HtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 03:49:19 -0400
Subject: Re: [PATCH] mac80211: auth retries if AP sends temporary deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTilhbYTH2gKJsvqDaMzLG2cIt2tNV-GW-X0K3pNJ@mail.gmail.com>
References: <AANLkTilhbYTH2gKJsvqDaMzLG2cIt2tNV-GW-X0K3pNJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 09:49:15 +0200
Message-ID: <1277624955.3684.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-25 at 00:33 -0700, Paul Stewart wrote:

> If a STA gets sent a DEAUTH from an AP it is actively trying to
> authenticate to, mac80211 currently shoots itself in the foot by
> letting  ieee80211_sta_rx_mgmt() clean up state for the connection
> (removing an entry from authtry_bsses[] in wireless/mlme.c),
> but the retry loop contiinues, leading to a kernel warning but no
> connection.
> 
> An AP is allowed by the spec to return DEAUTH as a result of a
> temporary failure, one of which is "you are already authenticated
> -- what are you talking about?"

Do you know the reason code for that? I think the check here should be
more fine-grained.

johannes


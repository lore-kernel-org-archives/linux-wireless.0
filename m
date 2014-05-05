Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbaEEM7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 08:59:18 -0400
Message-ID: <1399294750.22235.11.camel@jlt4.sipsolutions.net> (sfid-20140505_145922_589553_8EF42EF9)
Subject: Re: [PATCH] cfg80211: free sme on connection failures
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 May 2014 14:59:10 +0200
In-Reply-To: <1398862693-19264-1-git-send-email-eliad@wizery.com> (sfid-20140430_145824_430540_863BD337)
References: <1398862693-19264-1-git-send-email-eliad@wizery.com>
	 (sfid-20140430_145824_430540_863BD337)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-30 at 15:58 +0300, Eliad Peller wrote:
> cfg80211 is notified about connection failures by
> __cfg80211_connect_result() call. However, this
> function currently does not free cfg80211 sme.
> 
> This results in hanging connection attempts in some cases
> 
> e.g. when mac80211 authentication attempt is denied,
> we have this function call:
> ieee80211_rx_mgmt_auth() -> cfg80211_rx_mlme_mgmt() ->
> cfg80211_process_auth() -> cfg80211_sme_rx_auth() ->
> __cfg80211_connect_result()
> 
> but cfg80211_sme_free() is never get called.

Applied.

johannes


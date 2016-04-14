Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42439 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbcDNJBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 05:01:50 -0400
Message-ID: <1460624507.2358.9.camel@sipsolutions.net> (sfid-20160414_110207_680433_A5580C76)
Subject: Re: [PATCH 1/3] cfg80211: Add option to report the bss entry in
 connect result
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 14 Apr 2016 11:01:47 +0200
In-Reply-To: <1460367961-11254-1-git-send-email-vkanchan@qti.qualcomm.com>
References: <1460367961-11254-1-git-send-email-vkanchan@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-11 at 15:16 +0530, Kanchanapally, Vidyullatha wrote:
> From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
> 
> Since cfg80211 maintains separate BSS table entries for APs if the
> same
> BSSID, SSID pair is seen on multiple channels, it is possible that it
> can map the current_bss to a BSS entry on the wrong channel. This
> current_bss will not get flushed unless disconnected and cfg80211
> reports a wrong channel as the associated channel.
> 
> Fix this by introducing a new cfg80211_connect_bss() function which
> is
> similar to cfg80211_connect_result(), but it includes an additional
> parameter: the bss the STA is connected to. This allows drivers to
> provide the exact bss entry that matches the BSS to which the
> connection
> was completed.

Applied.

I'm surprised you're so worried about this test scenario (we've
discussed this multiple times before), but I can't really argue with
passing the BSS pointer either :)

johannes

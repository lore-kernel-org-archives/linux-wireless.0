Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37964 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbbBXJvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:51:37 -0500
Message-ID: <1424771494.2192.5.camel@sipsolutions.net> (sfid-20150224_105146_316987_E53B9A5C)
Subject: Re: [PATCH] mac80211: clear sdata->radar_required
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 10:51:34 +0100
In-Reply-To: <1423391767-1185-1-git-send-email-eliad@wizery.com> (sfid-20150208_113618_677322_945BE617)
References: <1423391767-1185-1-git-send-email-eliad@wizery.com>
	 (sfid-20150208_113618_677322_945BE617)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-02-08 at 12:36 +0200, Eliad Peller wrote:
> If ieee80211_vif_use_channel() fails, we have to clear
> sdata->radar_required (which we might have just set).
> 
> Failing to do it results in stale radar_required field
> which prevents starting new scan requests.

Applied, but I fixed it to use = false instead of = 0.

johannes


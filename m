Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37784 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbE2LFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:05:09 -0400
Message-ID: <1432897506.2104.3.camel@sipsolutions.net> (sfid-20150529_130532_646826_AB2554A9)
Subject: Re: [PATCH v3] mac80211: prevent possible crypto tx tailroom
 corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 May 2015 13:05:06 +0200
In-Reply-To: <1432282960-4980-1-git-send-email-michal.kazior@tieto.com> (sfid-20150522_102253_713902_7F0F9AAA)
References: <1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
	 <1432282960-4980-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150522_102253_713902_7F0F9AAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-22 at 10:22 +0200, Michal Kazior wrote:
> There was a possible race between
> ieee80211_reconfig() and
> ieee80211_delayed_tailroom_dec(). This could
> result in inability to transmit data if driver
> crashed during roaming or rekeying and subsequent
> skbs with insufficient tailroom appeared.
> 
> This race was probably never seen in the wild
> because a device driver would have to crash AND
> recover within 0.5s which is very unlikely.
> 
> I was able to prove this race exists after
> changing the delay to 10s locally and crashing
> ath10k via debugfs immediately after GTK
> rekeying. In case of ath10k the counter went below
> 0. This was harmless but other drivers which
> actually require tailroom (e.g. for WEP ICV or
> MMIC) could end up with the counter at 0 instead
> of >0 and introduce insufficient skb tailroom
> failures because mac80211 would not resize skbs
> appropriately anymore.
> 
> Fixes: 8d1f7ecd2af5 ("mac80211: defer tailroom counter manipulation when roaming")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Applied.

johannes


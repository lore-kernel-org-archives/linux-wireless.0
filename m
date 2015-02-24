Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37955 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbBXJuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:50:04 -0500
Message-ID: <1424771401.2192.4.camel@sipsolutions.net> (sfid-20150224_105008_908477_29A33CCF)
Subject: Re: [PATCH] mac80211_hwsim: fix error handling in tx_frame_nl
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 10:50:01 +0100
In-Reply-To: <1423143943-17526-1-git-send-email-me@bobcopeland.com> (sfid-20150205_144723_163608_814CBCA8)
References: <1423143943-17526-1-git-send-email-me@bobcopeland.com>
	 (sfid-20150205_144723_163608_814CBCA8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-05 at 08:45 -0500, Bob Copeland wrote:
> Correct two problems with the error handling when using the netlink
> forwarding API: first, the netlink skb is never freed if nla_put()
> fails; and second, genlmsg_unicast() can fail if the netlink socket
> is full.  In the latter case, the corresponding data skb is not counted
> as a drop and userspace programs like wmediumd will see TCP stalls
> due to lost packets.

Applied, thanks.

johannes


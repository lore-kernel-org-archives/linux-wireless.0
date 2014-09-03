Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60766 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbaICLkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 07:40:51 -0400
Message-ID: <1409744447.911.0.camel@jlt4.sipsolutions.net> (sfid-20140903_134054_609739_687722A3)
Subject: Re: [PATCH v2] mac80211: fix offloaded BA session traffic after hw
 restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Sep 2014 13:40:47 +0200
In-Reply-To: <1409659510-13624-1-git-send-email-michal.kazior@tieto.com> (sfid-20140902_141505_891790_530C0F9C)
References: <1409659510-13624-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140902_141505_891790_530C0F9C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-02 at 14:05 +0200, Michal Kazior wrote:
> When starting an offloaded BA session it is
> unknown what starting sequence number should be
> used. Using last_seq worked in most cases except
> after hw restart.
> 
> When hw restart is requested last_seq is
> (rightfully so) kept unmodified. This ended up
> with BA sessions being restarted with an aribtrary
> BA window values resulting in dropped frames until
> sequence numbers caught up.
> 
> Instead of last_seq pick seqno of a first Rxed
> frame of a given BA session.
> 
> This fixes stalled traffic after hw restart with
> offloaded BA sessions (currently only ath10k).

Applied.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35899 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbcCAOp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 09:45:26 -0500
Message-ID: <1456843521.3926.30.camel@sipsolutions.net> (sfid-20160301_154541_069623_A1E0A2ED)
Subject: Re: [PATCH] mac80211: Fix Public Action frame RX in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Mar 2016 15:45:21 +0100
In-Reply-To: <1456784940-32328-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456784940-32328-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-01 at 00:29 +0200, Jouni Malinen wrote:
> Public Action frames use special rules for how the BSSID field
> (Address
> 3) is set. A wildcard BSSID is used in cases where the transmitter
> and
> recipient are not members of the same BSS. As such, we need to accept
> Public Action frames with wildcard BSSID.
> 
> Commit db8e17324553 ("mac80211: ignore frames between TDLS peers when
> operating as AP") added a rule that drops Action frames to TDLS-peers
> based on an Action frame having different DA (Address 1) and BSSID
> (Address 3) values. This is not correct since it misses the
> possibility
> of BSSID being a wildcard BSSID in which case the Address 1 would not
> necessarily match.
> 
> Fix this by allowing mac80211 to accept wildcard BSSID in an Action
> frame when in AP mode.
> 
Applied, thanks.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3DVNtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:49:53 -0400
Message-ID: <1366638588.8637.15.camel@jlt4.sipsolutions.net> (sfid-20130422_154957_712550_0E1DFBE5)
Subject: Re: [PATCH V7 1/3] cfg80211: introduce critical protocol indication
 from user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 22 Apr 2013 15:49:48 +0200
In-Reply-To: <1366292942-21038-1-git-send-email-arend@broadcom.com>
References: <1366292942-21038-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 15:49 +0200, Arend van Spriel wrote:
> Some protocols need a more reliable connection to complete
> successful in reasonable time. This patch adds a user-space
> API to indicate the wireless driver that a critical protocol
> is about to commence and when it is done, using nl80211 primitives
> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
> 
> There can be only on critical protocol session started per
> registered cfg80211 device.
> 
> The driver can support this by implementing the cfg80211 callbacks
> .crit_proto_start() and .crit_proto_stop(). Examples of protocols
> that can benefit from this are DHCP, EAPOL, APIPA. Exactly how the
> link can/should be made more reliable is up to the driver. Things
> to consider are avoid scanning, no multi-channel operations, and
> alter coexistence schemes.

Applied.

johannes


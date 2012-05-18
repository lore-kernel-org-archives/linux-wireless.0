Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:51481 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933560Ab2ERNjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 09:39:49 -0400
Date: Fri, 18 May 2012 09:39:35 -0400
From: Jouni Malinen <j@w1.fi>
To: Amit SHAKYA <amit.shakya@stericsson.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
	"Johannes Berg (johannes@sipsolutions.net)"
	<johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Handle race condition in replay handling
Message-ID: <20120518133935.GA13088@w1.fi> (sfid-20120518_153953_380001_17039993)
References: <ECD438FDEF6BD742895E554C24725A4022946BBD16@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ECD438FDEF6BD742895E554C24725A4022946BBD16@EXDCVYMBSTM005.EQ1STM.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 17, 2012 at 11:40:16AM +0200, Amit SHAKYA wrote:
> Added fix for the issue where the Rx throughput use to get stuck,
> with unicast key rotation feature enabled in the Cisco AP.
> The issue is that due to race condition during EAPOL key
> handshake and packet reception, the PN gets reset at MAC, while
> it still receives previous PN range packets for a while from AP.

How would that happen? I would assume the previous PN range is still
used with the old key and as such, the PN updates should not be accepted
for the new key.

> At MAC, there is a memcpy of the PN from the received PN
> and as a result the maintained PN is overwritten with the
> previous PN sequence value after being reset at the time, new
> key is plumbed by supplicant.
> 
> As a result, when this change in sequence number happens, the
> replay detection handling in MAC gets triggered, causing the
> traffic to stops for some while till PN re-match, with the
> one last updated at MAC.
> 
> The fix takes care of selectively updating the Rx PN during
> this transition phase.

This sounds incorrect.. I don't really like the idea of adding the extra
hack here and the additional memcmp() calls either.

Would you be able to provide more detailed description on how the PN
values are used based on the key (old/new) and how the PN value for the
new key gets updated based on the old range?

-- 
Jouni Malinen                                            PGP id EFC895FA

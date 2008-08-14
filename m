Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50740 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYHNLJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 07:09:50 -0400
Date: Thu, 14 Aug 2008 14:09:03 +0300
From: Jouni Malinen <j@w1.fi>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Improvement in mac80211 to move to a proper state when channel
	is set from user space
Message-ID: <20080814110902.GA4864@jm.kir.nu> (sfid-20080814_130954_064034_673E9678)
References: <20080814100501.GA5486@vasanth-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080814100501.GA5486@vasanth-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2008 at 03:35:01PM +0530, Vasanthakumar Thiagarajan wrote:

> The problem with the current behaviour of mac80211 when setting a
> new channel from user space while interface is in associated state
> is, it is still maintainig the associated state even after the h/w 
> is set to a different channel and it is sending packets destined 
> to the connected AP/STA which is operating in a different freq/band 
> in the new channel before detecting that the AP is no more in the 
> channel

Please note that AP may change channels with associated STA remaining
associated on the new channel (see Channel Switch Announcement).

> Handle proper state transition in wireless handler (ieee80211_ioctl_siwfreq):
> For STA mode, move the interface to disassociated state with the associated AP 
> in the current channel and move it to scan state to find an appropriate 
> AP in the new channel.

If client MLME is in user space, siwfreq could be used to handle channel
switch announcement from the AP and in this case the STA should not be
moved into disassociated state.

> For IBSS, mark all the joined ibss stations as not joined in the
> current chanel and move the inteface state to scan in the new channel.

IBSS can also use channel switch announcement and in addition, merging
of separate IBSSes into a single one may end up changing channels for
some STAs. If this is managed from user space, siwfreq should not
tricker this type of changes.

> For AP mode, move the interface to disassociated state with all
> associated stations in current channel and start a BSS in the new
> channel.

Same here and taken into account that we only support AP MLME in user
space (i.e., hostapd), I would say it is up to userspace to do this.
mac80211 should not start marking STAs disassociated in AP mode.

-- 
Jouni Malinen                                            PGP id EFC895FA

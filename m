Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:44471 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab3GHKE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 06:04:27 -0400
Date: Mon, 8 Jul 2013 13:04:18 +0300
From: Jouni Malinen <j@w1.fi>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional
 channels
Message-ID: <20130708100418.GA10670@w1.fi> (sfid-20130708_120429_950200_5440BE81)
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 02, 2013 at 03:28:15PM +0300, Ilan Peer wrote:
> Allow GO operation on a channel marked with
> IEEE80211_CHAN_INDOOR_ONLY or IEEE80211_CHAN_GO_CONCURRENT
> iff there is an active station interface that is associated to
> an AP operating on this channel.
> 
> Note that this is a permissive approach to the FCC definitions,
> that require a clear assessment that either the platform device
> is an indoor device, or the device operating the AP is an indoor
> device, i.e., AC powered.
> It is assumed that these restrictions are enforced by user space.

The introduction in 0/3 mentioned DFS, but I did not see it being
addressed in any of the actual changes. Is this only for indoors vs.
outdoors?

> Furthermore, it is assumed, that if the conditions that allowed for
> the operation of the GO on such a channel change, it is the
> responsibility of user space to evacuate the GO from the channel.

Do you have plans or changes to address this? I'd assume wpa_supplicant
could stop the group on channel list changes, but I don't think it does
that currently.

-- 
Jouni Malinen                                            PGP id EFC895FA

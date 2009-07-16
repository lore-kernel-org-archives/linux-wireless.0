Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51404 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580AbZGPXX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:23:29 -0400
Message-ID: <4A5FB662.5070500@openwrt.org>
Date: Fri, 17 Jul 2009 01:23:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net,
	Gabor Juhos <juhosg@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: Re: [PATCH v2 16/21] mac80211: add helper for management / no-ack
 frame rate decision
References: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> All current rate control algorithms agree to send management and no-ack
> frames at the lowest rate. They also agree to do this when sta
> and the private rate control data is NULL. We add a hlper to mac80211
> for this and simplify the rate control algorithm code.
> 
> Developers wishing to make enhancements to rate control algorithms
> are for broadcast/multicast can opt to not use this in their
> gate_rate() mac80211 callback.
> 
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: ipw3945-devel@lists.sourceforge.net
> Cc: Gabor Juhos <juhosg@openwrt.org>
> Cc: Felix Fietkau <nbd@openwrt.org>
> Cc: Derek Smithies <derek@indranet.co.nz>
> Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/rc.c        |   14 +------------
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   13 ++---------
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    7 +-----
>  include/net/mac80211.h                     |   23 ++++++++++++++++++++++
>  net/mac80211/rate.c                        |   29 ++++++++++++++++++++++++++++
>  net/mac80211/rc80211_minstrel.c            |   22 +--------------------
>  net/mac80211/rc80211_pid_algo.c            |   11 +---------
>  7 files changed, 59 insertions(+), 60 deletions(-)

Acked-by: Felix Fietkau <nbd@openwrt.org>

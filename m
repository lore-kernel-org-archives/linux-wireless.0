Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57053 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbbLRMHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 07:07:44 -0500
Message-ID: <1450440458.2849.0.camel@sipsolutions.net> (sfid-20151218_130747_066138_815580C6)
Subject: Re: [RFC/RFT v2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Date: Fri, 18 Dec 2015 13:07:38 +0100
In-Reply-To: <1450439850-1587-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151218_125749_993352_562C800A)
References: <1450439850-1587-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20151218_125749_993352_562C800A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-12-18 at 12:57 +0100, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
> aligned skbs to four-byte boundaries.
> 
> Before we have to do memmove() in the driver before
> pass this to HW and memmove() back in tx completion.
> This patch allow to save CPU and skip such memmoves.
> For each skb we call memmove(ieee80211_hdrsize()) twice.
> 
> Currently this was tested with ath9k, both hw/sw crypt for
> tkip/ccmp.
> For sure more tests required (eg. fast path isn't used for
> ath9k STA, wep sw crypt).
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  include/net/mac80211.h     |  4 ++++
>  net/mac80211/debugfs.c     |  1 +
>  net/mac80211/ieee80211_i.h |  1 +
>  net/mac80211/sta_info.h    |  4 ++--
>  net/mac80211/tkip.c        | 15 ++++++++++++---
>  net/mac80211/tx.c          | 38 +++++++++++++++++++++++++++++++++---
> --
>  net/mac80211/util.c        |  7 ++++++-
>  net/mac80211/wep.c         | 11 ++++++-----
>  net/mac80211/wep.h         |  1 +
>  net/mac80211/wpa.c         | 14 ++++++--------
>  10 files changed, 72 insertions(+), 24 deletions(-)
> 
Btw, how can you get away without changing the status path?

johannes

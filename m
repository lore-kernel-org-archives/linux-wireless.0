Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:44513 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYJ1MCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 08:02:05 -0400
Date: Tue, 28 Oct 2008 14:00:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: print reason code for deauth/dissoc frames
Message-ID: <20081028120059.GM19710@jm.kir.nu> (sfid-20081028_130211_826889_127223EC)
References: <1225180711-5204-1-git-send-email-yi.zhu@intel.com> <1ba2fa240810280431m21080a96i7655e67769cb1579@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240810280431m21080a96i7655e67769cb1579@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 01:31:13PM +0200, Tomas Winkler wrote:

> Do anyone has idea how to push it to the user space?
> We already use ieee80211_sta_send_apinfo (SIOCGIWAP) for notification.
> Can be reason code attached without breaking user space?  The
> iwreq_data it self has enough space to add this and this can be queued
> at the end.

Taken into account how broken WEXT events are already on 64/32-bit
systems, it would probably be better to add this as a new nl80211 event
which we will hopefully get in the near future. I'm looking for that to
fix the association info reporting, too (and issue that I fixed with
WEXT, but the fix was reverted due to userspace interop issues..).

-- 
Jouni Malinen                                            PGP id EFC895FA

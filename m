Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0EEMM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 08:12:26 -0400
Subject: Re: [PATCH] cfg80211/mac80211: better channel handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1273055797.3728.14.camel@jlt3.sipsolutions.net>
References: <1273055797.3728.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 14:12:23 +0200
Message-ID: <1273061543.3728.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-05 at 12:36 +0200, Johannes Berg wrote:

> In order to improve this situation, first make the
> configuration APIs (cfg80211 and nl80211) aware of
> multi-channel operation -- we'll eventually need
> that in the future anyway. There's one userland API
> change and one API addition. The API change is that
> now SET_WIPHY must be called with virtual interface
> index rather than only wiphy index in order to take
> effect for that interface -- luckily all current
> users (hostapd) do that. For monitor interfaces, the
> old setting is preserved, but monitors are always
> slaved to other devices anyway so no guarantees.

Withdrawn, contains a locking bug, sorry!

johannes


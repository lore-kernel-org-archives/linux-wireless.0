Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60054 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbZHMKqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 06:46:44 -0400
Date: Thu, 13 Aug 2009 13:46:35 +0300
From: Jouni Malinen <j@w1.fi>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] nl80211 connect API support
Message-ID: <20090813104635.GA7330@jm.kir.nu>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com> <1250153731-17208-2-git-send-email-yi.zhu@intel.com> <20090813091103.GA1826@jm.kir.nu> <1250155777.4972.9.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250155777.4972.9.camel@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 05:29:37PM +0800, Zhu Yi wrote:

> The connect API wraps auth/assoc commands in cfg80211 SME. For example,
> when cfg80211 receives NL80211_CMD_CONNECT (cfg80211_connect), it checks
> if connect API is supported or not. If it is not supported (for all
> mac80211 based drivers), it uses the common cfg80211_conn_do_work() to
> do auth/assoc the same way as it handles NL80211_CMD_AUTHENTICATE. So
> from user space point of view, if connect API is supported, it can use
> it directly and let cfg80211 to maintain the state of auth and assoc.

It is not about whether it would be possible to use connect or not; it
is about whether the additional features provided by separate auth/assoc
commands are of use--and they are. wpa_supplicant will provide more
functionality, e.g., FT, when using these commands. Any change to add
support for the new NL80211_CMD_CONNECT must not break this existing
mechanism; it is only to add support for drivers that cannot support the
auth/assoc interface that provides more control to user space.

-- 
Jouni Malinen                                            PGP id EFC895FA

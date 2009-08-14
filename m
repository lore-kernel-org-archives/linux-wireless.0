Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZHNESG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 00:18:06 -0400
Subject: Re: [PATCH] nl80211 connect API support
From: Zhu Yi <yi.zhu@intel.com>
To: Jouni Malinen <j@w1.fi>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20090813104635.GA7330@jm.kir.nu>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
	 <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
	 <20090813091103.GA1826@jm.kir.nu> <1250155777.4972.9.camel@debian>
	 <20090813104635.GA7330@jm.kir.nu>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 12:17:54 +0800
Message-Id: <1250223474.4972.47.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-13 at 18:46 +0800, Jouni Malinen wrote:
> It is not about whether it would be possible to use connect or not; it
> is about whether the additional features provided by separate auth/assoc
> commands are of use--and they are. wpa_supplicant will provide more
> functionality, e.g., FT, when using these commands. Any change to add
> support for the new NL80211_CMD_CONNECT must not break this existing
> mechanism; it is only to add support for drivers that cannot support the
> auth/assoc interface that provides more control to user space.

Ah, I see. This makes sense to me. I ignored the 11r code when I wrote
the code. Now I realized what it is used for (i.e. sme_event_auth). I'm
not sure if it can be done in cfg80211 SME easily, but it doesn't help
for connect API anyway. I'll send V2 according to your suggestion.

Johannes, I think we need a way in cfg80211 to tell connect vs.
auth/assoc. The current capability method (nl80211_send_wiphy) cannot do
this. For example,

	if (dev->ops->connect || dev->ops->auth)
		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);

We need to either make NL80211_CMD_CONNECT only depends on ops->connect
or make NL80211_CMD_AUTH depends on ops->auth. Johannes, which one do
you prefer?

Thanks,
-yi




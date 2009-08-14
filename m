Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZHNHz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 03:55:27 -0400
Subject: Re: [PATCH] nl80211 connect API support
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1250229046.7696.0.camel@johannes.local>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
	 <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
	 <20090813091103.GA1826@jm.kir.nu> <1250155777.4972.9.camel@debian>
	 <20090813104635.GA7330@jm.kir.nu>  <1250223474.4972.47.camel@debian>
	 <1250229046.7696.0.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 15:55:27 +0800
Message-Id: <1250236527.4972.64.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-14 at 13:50 +0800, Johannes Berg wrote:
> On Fri, 2009-08-14 at 12:17 +0800, Zhu Yi wrote:
> 
> > Johannes, I think we need a way in cfg80211 to tell connect vs.
> > auth/assoc. The current capability method (nl80211_send_wiphy) cannot do
> > this. For example,
> > 
> > 	if (dev->ops->connect || dev->ops->auth)
> > 		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
> > 
> > We need to either make NL80211_CMD_CONNECT only depends on ops->connect
> > or make NL80211_CMD_AUTH depends on ops->auth. Johannes, which one do
> > you prefer?
> 
> The latter is already there as far as I can see?
> 
>         CMD(auth, AUTHENTICATE);
>         CMD(assoc, ASSOCIATE);
>         CMD(deauth, DEAUTHENTICATE);
>         CMD(disassoc, DISASSOCIATE);
> 
> so you should be able to check for these.

My bad. I'll use NL80211_CMD_AUTHENTICATE.

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZHMJ3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 05:29:51 -0400
Subject: Re: [PATCH] nl80211 connect API support
From: Zhu Yi <yi.zhu@intel.com>
To: Jouni Malinen <j@w1.fi>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20090813091103.GA1826@jm.kir.nu>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
	 <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
	 <20090813091103.GA1826@jm.kir.nu>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 17:29:37 +0800
Message-Id: <1250155777.4972.9.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Thu, 2009-08-13 at 17:11 +0800, Jouni Malinen wrote:
> On Thu, Aug 13, 2009 at 04:55:31PM +0800, Zhu Yi wrote:
> 
> > -	 * authenticate - Request driver to authenticate
> > +	 * authenticate - Request driver to authenticate (deprecated)
> 
> > +	 * This is an optional function that to make compatibility for wireless
> > +	 * stack that doesn't support connect API when driver SME is used
> > +	 * (WPA_DRIVER_FLAGS_SME).
> 
> Thanks for the patch. If I understood this correctly, wpa_supplicant
> would be converted to use the new connect command whenever it is
> supported. While it is nice to get support for connect added, this is
> not how it should be done as it breaks all the new work we have been
> enabling with mac80211. The separate auth/assoc commands should be the
> default operation and only if the driver does not support this, should
> the connect command be used.

The connect API wraps auth/assoc commands in cfg80211 SME. For example,
when cfg80211 receives NL80211_CMD_CONNECT (cfg80211_connect), it checks
if connect API is supported or not. If it is not supported (for all
mac80211 based drivers), it uses the common cfg80211_conn_do_work() to
do auth/assoc the same way as it handles NL80211_CMD_AUTHENTICATE. So
from user space point of view, if connect API is supported, it can use
it directly and let cfg80211 to maintain the state of auth and assoc.

Thanks,
-yi


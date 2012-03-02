Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62908 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2CBKSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 05:18:23 -0500
Date: Fri, 2 Mar 2012 15:48:30 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Add an attribute to set inactivity timeout
 in AP mode
Message-ID: <20120302101829.GA7154@vasanth-laptop> (sfid-20120302_111828_068295_BCFADBC0)
References: <1330615294-13123-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1330678884.8542.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1330678884.8542.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 02, 2012 at 10:01:24AM +0100, Johannes Berg wrote:
> Hi Vasanth,
> 
> On Thu, 2012-03-01 at 20:51 +0530, Vasanthakumar Thiagarajan wrote:
> > + * @NL80211_ATTR_INACTIVITY_TIMER_SUPPORT: Indicates if the driver has the
> > + *	capability to use %NL80211_ATTR_INACTIVITY_TIMEOUT for freeing up
> > + *	connected stations.
> 
> I think now that we have "enum nl80211_feature_flags" you could just add
> a flag to it.

Good point, thanks.

> 
> > + * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
> > + *	used by the drivers which has MLME in firmware and does not have support
> > + *	to report per station tx/rx activity to free up the staion entry from
> > + *	the list. This should not be sent from userspace when the driver does
> > + *	not register it's capability to timeout the stations.
> 
> Shouldn't that be the other way around -- it needs to be used when the
> driver *does* advertise support for it?
> 
Ah, right, thanks.

> 
> > +	WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER	= BIT(22),
> 
> If you use nl80211_feature_flags you also don't need this wiphy to
> feature translation, the driver can directly set those flags.

Right.

Vasanth

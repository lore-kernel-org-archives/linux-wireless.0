Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38667 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467AbaJ2Ppc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:45:32 -0400
Message-ID: <1414597524.1827.13.camel@jlt4.sipsolutions.net> (sfid-20141029_164654_710948_83F27BD3)
Subject: Re: [PATCH] wireless: nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:45:24 +0100
In-Reply-To: <1414597472.1827.12.camel@jlt4.sipsolutions.net> (sfid-20141029_164440_271307_811CDCBC)
References: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20141027_134340_833740_6984A324) <1414597472.1827.12.camel@jlt4.sipsolutions.net>
	 (sfid-20141029_164440_271307_811CDCBC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 16:44 +0100, Johannes Berg wrote:

> > +	nl80211_notify_iface(rdev, NULL, iftype, id, address, dev,
> > +			     0, NULL, false, info->snd_portid);
> 
> I'm not sure why this needs to be so late in the command, if you put it
> first you don't have the whole argument bloating issue.

And if for some reason it really must be so late, maybe you can split
the message building and sending instead.

johannes


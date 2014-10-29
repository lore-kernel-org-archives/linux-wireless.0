Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38737 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467AbaJ2Pxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:53:38 -0400
Message-ID: <1414598014.1827.18.camel@jlt4.sipsolutions.net> (sfid-20141029_165341_428653_B6C3C9CE)
Subject: Re: [PATCH 2/3] mac80211-hwsim: Provide multicast event for
 HWSIM_CMD_NEW_RADIO
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:53:34 +0100
In-Reply-To: <1414597807.1827.16.camel@jlt4.sipsolutions.net> (sfid-20141029_165015_857664_0FB9784E)
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414406688-3827-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114540_063766_7C3E5B4A) <1414597807.1827.16.camel@jlt4.sipsolutions.net>
	 (sfid-20141029_165015_857664_0FB9784E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 16:50 +0100, Johannes Berg wrote:
> On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:
> 
> > +static void mcast_msg(struct sk_buff *mcast_skb, struct genl_info *info)
> > +{
> > +	if (info)
> > +		genl_notify(&hwsim_genl_family, mcast_skb,
> > +			    genl_info_net(info), info->snd_portid,
> > +			    HWSIM_MCGRP_CONFIG, info->nlhdr, GFP_KERNEL);
> > +	else
> > +		genlmsg_multicast(&hwsim_genl_family, mcast_skb, 0,
> > +				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
> > +}
> 
> Also - given the parameters and what this does, that's a bad name for
> the function. Never mind that it doesn't have any sort of identifier
> (say hwsim_ prefix), it doesn't even do what it says it does.

Or maybe it does? I'm unsure what genl_notify() does...

johannes


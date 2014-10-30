Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832AbaJ3O3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 10:29:01 -0400
Message-ID: <1414679338.2918.6.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141030_152905_523778_2AE2FC7D)
Subject: Re: [PATCH 2/3] mac80211-hwsim: Provide multicast event for
 HWSIM_CMD_NEW_RADIO
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Oct 2014 16:28:58 +0200
In-Reply-To: <1414598014.1827.18.camel@jlt4.sipsolutions.net>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414406688-3827-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114540_063766_7C3E5B4A) <1414597807.1827.16.camel@jlt4.sipsolutions.net>
	 (sfid-20141029_165015_857664_0FB9784E) <1414598014.1827.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On ke, 2014-10-29 at 16:53 +0100, Johannes Berg wrote:
> On Wed, 2014-10-29 at 16:50 +0100, Johannes Berg wrote:
> > On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:
> > 
> > > +static void mcast_msg(struct sk_buff *mcast_skb, struct genl_info *info)
> > > +{
> > > +	if (info)
> > > +		genl_notify(&hwsim_genl_family, mcast_skb,
> > > +			    genl_info_net(info), info->snd_portid,
> > > +			    HWSIM_MCGRP_CONFIG, info->nlhdr, GFP_KERNEL);
> > > +	else
> > > +		genlmsg_multicast(&hwsim_genl_family, mcast_skb, 0,
> > > +				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
> > > +}
> > 
> > Also - given the parameters and what this does, that's a bad name for
> > the function. Never mind that it doesn't have any sort of identifier
> > (say hwsim_ prefix), it doesn't even do what it says it does.
> 
> Or maybe it does? I'm unsure what genl_notify() does...

Yes, genl_notify() will eventually call nlmsg_notify() which will
multicast the message because we have set the group id in the call.

http://lxr.free-electrons.com/source/net/netlink/af_netlink.c#L2856


Cheers,
Jukka



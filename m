Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3ARLwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 06:52:17 -0500
Message-ID: <1358509959.5035.0.camel@jlt4.sipsolutions.net> (sfid-20130118_125221_428673_B1C5F597)
Subject: Re: [PATCHv2 6/6] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 18 Jan 2013 12:52:39 +0100
In-Reply-To: <50F82808.6040206@cozybit.com> (sfid-20130117_173422_125602_E9681D63)
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
	  <1357571093-12868-7-git-send-email-marco@cozybit.com>
	  (sfid-20130107_160510_532684_9863E9B0) <1358374485.15012.20.camel@jlt4.sipsolutions.net>
	 <50F82808.6040206@cozybit.com> (sfid-20130117_173422_125602_E9681D63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-17 at 17:34 +0100, Marco Porsch wrote:
> On 01/16/2013 11:14 PM, Johannes Berg wrote:
> > On Mon, 2013-01-07 at 16:04 +0100, Marco Porsch wrote:
> >
> >> mode determines when non-peer mesh STA may send Probe Requests and Mesh Peering
> >
> > Please break lines to less than 72 characters, I personally prefer
> > around 60 or so but I'll apply 72 too.
> >
> >> +static inline bool ieee80211_has_qos_mesh_ps(__le16 qc)
> >> +{
> >> +	return (qc & cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL)) != 0;
> >
> > bool means you don't need the !=0 and parentheses.
> 
> Actually, then it pops the following warning:
>    CHECK   net/mac80211/mesh_ps.c
> include/linux/ieee80211.h:584:19: warning: incorrect type in return 
> expression (different base types)
> include/linux/ieee80211.h:584:19:    expected bool
> include/linux/ieee80211.h:584:19:    got restricted __le16
> 
> 
> Other functions in that file have following style:
> static inline int ieee80211_has_pm(__le16 fc)
> {
> 	return (fc & cpu_to_le16(IEEE80211_FCTL_PM)) != 0;
> }
> 
> What do you recommend?

I'm clearly not quick enough for you, sorry. I guess we should keep it
as is then, but I see you removed it entirely later? Anyway ... I just
wasn't aware sparse would then complain, that's a bit stupid but hey.

johannes


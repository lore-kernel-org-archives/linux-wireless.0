Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeEUHXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 03:23:12 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
        "'Jeff Johnson'" <jjohnson@codeaurora.org>,
        "'Dedy Lansky'" <dlansky@codeaurora.org>
Cc: <linux-wireless@vger.kernel.org>,
        <linux-wireless-owner@vger.kernel.org>
References: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org>         <a19275473776283a94997b8f5436f3b9@codeaurora.org>         (sfid-20180517_204322_111043_9C68DA25) <1526585345.5351.3.camel@sipsolutions.net>
In-Reply-To: <1526585345.5351.3.camel@sipsolutions.net>
Subject: RE: [PATCH] nl80211: fix nlmsg allocation in cfg80211_ft_event
Date: Mon, 21 May 2018 10:23:07 +0300
Message-ID: <001201d3f0d4$93258900$b9709b00$@codeaurora.org> (sfid-20180521_092316_448754_4B3DD5BF)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org =
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Johannes Berg
>
> On Thu, 2018-05-17 at 11:43 -0700, Jeff Johnson wrote:
> >=20
> > > -	msg =3D nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
> > > +	msg =3D nlmsg_new(100 + ft_event->ies_len + =
ft_event->ric_ies_len,
> > > +			GFP_KERNEL);
> > >  	if (!msg)
> > >  		return;
> >=20
> > should these really be nla_total_size(ft_event->ies_len) +
> > nla_total_size(ft_event->ric_ies_len) to properly account for the =
NLA=20
> > header + padding? or do we consider that to be noise captured by the =

> > "100"?
>
> We do, technically we should have something like nla_total_size() of =
various things including all those wiphy, ifindex, MAC attributes etc.
> so we just get lazy...

nla_total_size is currently not used in nl80211.c (actually not used in =
net\wireless\ for that matters).
IMO, switching nl80211/cfg80211 to use nla_total_size should be done =
separately.
This patch is for fixing a very specific and small bug. Using =
nla_total_size in a single function in the file (cfg80211_ft_event) =
would be awkward.

Thanks,
 Dedy.

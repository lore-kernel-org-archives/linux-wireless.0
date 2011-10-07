Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1JGUF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 16:05:27 -0400
Subject: Re: [PATCH 3/8] cfg80211: process regulatory DFS region for
 countries
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAB=NE6WOvik7hJygC8cTpe+o1W==fsqw2ZgVA=_pbo6fpFhUzw@mail.gmail.com> (sfid-20111007_215756_987265_EF832A47)
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1317772067-6998-4-git-send-email-mcgrof@qca.qualcomm.com>
	 <1318017260.3974.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6WOvik7hJygC8cTpe+o1W==fsqw2ZgVA=_pbo6fpFhUzw@mail.gmail.com>
	 (sfid-20111007_215756_987265_EF832A47)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 22:05:24 +0200
Message-ID: <1318017924.3974.10.camel@jlt3.sipsolutions.net> (sfid-20111007_220530_844693_98D9D6B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 12:57 -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 7, 2011 at 12:54 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-10-04 at 16:47 -0700, Luis R. Rodriguez wrote:
> >
> >>  /**
> >> + * enum nl80211_dfs_regions - regulatory DFS regions
> >> + *
> >> + * @NL80211_DFS_UNSET: Country has no DFS master region specified
> >> + * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
> >> + * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
> >> + * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
> >> + */
> >> +enum nl80211_cflags {
> >> +     NL80211_DFS_UNSET       = 0,
> >
> > That seems odd -- nl80211 convention would be to just leave out the
> > attribute.
> 
> I wonder what seems more odd, having that present or looking at this:
> 
> +bool reg_supported_dfs_region(u8 dfs_region)
> +{
> +       switch (dfs_region) {
> +       case 0:

Yeah I noticed later you were going to use that value internally as
well, guess it's fine.

johannes


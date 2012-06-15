Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2FOJhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 05:37:54 -0400
Message-ID: <1339753070.13702.1.camel@jlt3.sipsolutions.net> (sfid-20120615_113758_124340_B709DCDF)
Subject: Re: [PATCH] mac80211: fix the assignment of mesh element TTL
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 15 Jun 2012 11:37:50 +0200
In-Reply-To: <CAEFj9846z0=Lif42m_Fd4wq3XvS=o_OZ7rTZw2V5gJaHLJ0onA@mail.gmail.com> (sfid-20120615_112628_825277_2B9DE7A8)
References: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339700228.9786.11.camel@jlt3.sipsolutions.net>
	 <CAEFj985xi0LNsLqHn1cgAw0oMVsfWrh_ioPuzUva8ZLbUTn=ZQ@mail.gmail.com>
	 <1339748416.4512.9.camel@jlt3.sipsolutions.net>
	 <CAEFj9846z0=Lif42m_Fd4wq3XvS=o_OZ7rTZw2V5gJaHLJ0onA@mail.gmail.com>
	 (sfid-20120615_112628_825277_2B9DE7A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-15 at 17:26 +0800, Yeoh Chun-Yeow wrote:
> Hi, Johannes
> 
> No. I think that I am actually fixing the wrong assignment of the
> previous patch.

Please clarify *which* previous patch.

> > commit 45904f21655cf4f0ae7d0fab5906fe51bf56ecf4
> > Author:     Javier Cardona <javier@cozybit.com>
> > AuthorDate: Fri Dec 3 09:20:40 2010 +0100
> > Commit:     John W. Linville <linville@tuxdriver.com>
> > CommitDate: Mon Dec 6 16:01:28 2010 -0500
> >
> >    nl80211/mac80211: define and allow configuring mesh element TTL

This patch looked like this:

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1024,6 +1024,8 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
                conf->dot11MeshMaxRetries = nconf->dot11MeshMaxRetries;
        if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
                conf->dot11MeshTTL = nconf->dot11MeshTTL;
+       if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
+               conf->dot11MeshTTL = nconf->element_ttl;
        if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
                conf->auto_open_plinks = nconf->auto_open_plinks;
        if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))


Are you telling me you're not fixing that code?

johannes


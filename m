Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1HHTKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 15:10:31 -0400
Subject: Re: [PATCH 4/6] mac80211: update mesh peering frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVN4i5Yh_ea0j3kvPyznUuZmfxog2OzK1Y74eveU2kR6Dg@mail.gmail.com> (sfid-20110808_204803_654787_1BCECA1A)
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
	 <1311638357-28740-5-git-send-email-thomas@cozybit.com>
	 <1312809868.4372.33.camel@jlt3.sipsolutions.net>
	 <CAG6hwVN4i5Yh_ea0j3kvPyznUuZmfxog2OzK1Y74eveU2kR6Dg@mail.gmail.com>
	 (sfid-20110808_204803_654787_1BCECA1A)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 21:10:30 +0200
Message-ID: <1312830630.4372.40.camel@jlt3.sipsolutions.net> (sfid-20110808_211034_973592_4BC8E601)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 11:47 -0700, Thomas Pedersen wrote:

> >> +     case WLAN_CATEGORY_SELF_PROTECTED:
> >> +             switch (mgmt->u.action.u.self_prot.action_code) {
> >> +             case WLAN_SP_MESH_PEERING_OPEN:
> >> +             case WLAN_SP_MESH_PEERING_CLOSE:
> >> +             case WLAN_SP_MESH_PEERING_CONFIRM:
> >> +                     if (!ieee80211_vif_is_mesh(&sdata->vif))
> >> +                             goto invalid;
> >> +                     if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
> >> +                             /* userspace handles this frame */
> >
> > Will this compile in the CONFIG_MAC80211_MESH=n case? It seems like it
> > might not? Do you routinely test that?
> >
> 
> Yes. The CONFIG_MAC80211_MESH check around the ieee80211_if_mesh was
> removed in c80d545da3f7c0e534ccd4a780f322f80a92cff1

I mean the "sdata->u.mesh.security" dereference. I know vif_is_mesh() is
always available, but I thought u.mesh wasn't?

johannes


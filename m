Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40343 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754100AbcJDITc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 04:19:32 -0400
Message-ID: <1475569169.5324.13.camel@sipsolutions.net> (sfid-20161004_101952_789017_28846916)
Subject: Re: [PATCH] mac80211: fix CMD_FRAME for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: "M. Braun" <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 04 Oct 2016 10:19:29 +0200
In-Reply-To: <fb4aeb32-8a13-92e6-a84e-12a6228dc7a1@fami-braun.de>
References: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de>
         <fb4aeb32-8a13-92e6-a84e-12a6228dc7a1@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-03 at 13:31 +0200, M. Braun wrote:
> Am 03.10.2016 um 13:03 schrieb M. Braun:
> > 
> > because the in ieee80211_mgmt_tx the
> 
> ups, that was the patch itself.
> 
> I think I carried it over from ieee80211_add_key, that does
> 
> > 
> > 
> >        if (mac_addr) {
> >                if (ieee80211_vif_is_mesh(&sdata->vif))
> >                        sta = sta_info_get(sdata, mac_addr);
> >                else
> >                        sta = sta_info_get_bss(sdata, mac_addr);
> > 
> 

Ok, so that's there, but I still don't see the point - sta->sdata->bss
will be NULL for any mesh STA.

Thomas, do you remember anything about why you did this back in commit
ff973af74aa6932ca4758266bccec68e8135ddf7
Author: Thomas Pedersen <thomas@cozybit.com>
Date:   Tue May 3 16:57:12 2011 -0700

    nl80211: allow installing keys for a meshif

?

(yeah, long shot, it's 5.5 years ago ...)

johannes

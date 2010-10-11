Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0JKT3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 15:29:03 -0400
Subject: Re: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CB3605D.1040509@candelatech.com>
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
	 <1286822639.3634.84.camel@jlt3.sipsolutions.net>
	 <1286822771.3634.85.camel@jlt3.sipsolutions.net>
	 <4CB3605D.1040509@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 21:28:59 +0200
Message-ID: <1286825339.3634.86.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 12:07 -0700, Ben Greear wrote:
> On 10/11/2010 11:46 AM, Johannes Berg wrote:
> > I think you should just do this (untested):
> 
> >   void
> > @@ -892,8 +889,8 @@ ath5k_debug_init_device(struct ath5k_sof
> >   {
> >   	sc->debug.level = ath5k_debug;
> >
> > -	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
> > -				ath5k_global_debugfs);
> > +	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
> > +				sc->hw->wiphy->debugfsdir);
> 
> This fails to work because sc->hw->wiphy->debugfsdir is null when this
> method is called...

Then it needs to be after registering with mac80211 -- shouldn't really
change much though.

johannes


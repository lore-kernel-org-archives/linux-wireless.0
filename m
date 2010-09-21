Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0IUQaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 12:30:19 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C98DC5D.2000108@candelatech.com>
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
	 <4C98DC5D.2000108@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 18:30:18 +0200
Message-ID: <1285086618.12764.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 09:25 -0700, Ben Greear wrote:

> > -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
> > +	snprintf(mac, sizeof(mac), "%pM-%s",
> > +		 sta->sta.addr, sta->sdata->name);
> >
> >   	/*
> >   	 * This might fail due to a race condition:
> 
> I got to thinking:  Is there any reason to put the sta.addr in there?
> 
> Maybe just use sta->sdata->name?  Seems it might be easier for
> scripts to deal with?

APs have many STAs

johannes


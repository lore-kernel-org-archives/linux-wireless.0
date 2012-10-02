Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2JBGph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 02:45:37 -0400
Message-ID: <1349160371.10698.7.camel@jlt4.sipsolutions.net> (sfid-20121002_084541_014049_8C405056)
Subject: Re: broadcast buffer / TIM map in mesh mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 02 Oct 2012 08:46:11 +0200
In-Reply-To: <5069ED50.4050307@etit.tu-chemnitz.de> (sfid-20121001_214401_534723_29DE8446)
References: <5069ED50.4050307@etit.tu-chemnitz.de>
	 (sfid-20121001_214401_534723_29DE8446)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marco,

> I am working on a mesh powersave implementation. One requirement for 
> that is to buffer broadcasts, set the TIM map and count powersave 
> neighbors. All of these routines are currently bound to the AP-specific 
> ieee80211_if_ap structure.
> Do you have any recommendations how to properly implement this for mesh 
> interfaces?
> 
> a) allocate/free ieee80211_if_ap in 
> iface.c:ieee80211_do_open/ieee80211_do_stop and bind to sdata->bss pointer?
> b) include ieee80211_if_ap into ieee80211_if_mesh structure and use 
> sdata->bss?
> c) completely different?

I don't think a) or b) are appropriate since the if_ap structure
contains a number of fields that you won't use or need. I would
therefore suggest to split out the PS related fields of that structure
into a substructure that you embed in both if_ap and if_mesh, and in the
code you could then pass a pointer to that structure to the powersave
handling functions.

Please do a separate patch to separate it out though, not just one huge
patch to do both mesh & the splitting up :)


> Also, what is the purpose of the sdata->bss pointer? It seems to be used 
> at times and not at others.

The sdata->bss pointer should be used in *most* cases, it's a link to
the "AP data" for the AP interface (where it just points to itself) and
any AP_VLAN interface (where it points to the master AP interface)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KZKjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:39:01 -0500
Message-ID: <1353926367.9488.13.camel@jlt4.sipsolutions.net> (sfid-20121126_113914_104811_A69C3D23)
Subject: Re: [RFC 09/14] mac80211: add power save support structure to mesh
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:39:27 +0100
In-Reply-To: <50AC17ED.60405@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	  <1353134886-13256-10-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353144370.9543.29.camel@jlt4.sipsolutions.net>
	 <50AC17ED.60405@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 15:53 -0800, Marco Porsch wrote:

> > If we know the interface type is AP/AP_VLAN, we can still get the AP
> > sdata from that pointer:
> > 	container_of(sdata->ps, struct ieee80211_sub_if_sdata, u.ap.ps);
> >
> > This is only in a few places, and might keep all the RX/TX code simpler?
> 
> When counting, I found twice as many lines that would need the 
> workaround, as the ones that would benefit. Also I don't really have a 
> clue on the AP/VLAN code.

Heh ok, fair enough. I did see a number of changes that would need the
other way, but I guess I thought that then the fastpath would be better.
Anyway, we can change that later.

johannes


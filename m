Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.129.253]:59803 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358AbZLOO4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 09:56:08 -0500
Received: from mx51.mymxserver.com (mail5104.internal [172.16.51.4])
	by emita2.mittwald.de (Postfix) with ESMTP id 00C065FEBDA
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 15:45:36 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Tue, 15 Dec 2009 15:44:00 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <20091022133043.185554096@mail.mn-solutions.de> <200910260859.39002.hs4233@mail.mn-solutions.de> <1256587966.2110.28.camel@localhost.localdomain>
In-Reply-To: <1256587966.2110.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912151544.00402.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan !

After I conquered

* libertas + cfg80211 + station
* libertas + cfg80211 + monitor
* libertas + cfg80211 + adhoc

I'm at libertas + cfg80211 + Libertas' mesh.


The old idea was to keep WEXT for the little things that mesh 
needs. It occurred to me that maybe this is not necessary, we 
can use cfg80211 for mesh as well.

On your old


> In any case, the code for the mesh channel change was different
> than the code for the STA channel change, we have to be a bit
> careful here.  The sequences were:
> 
> STA:
> 
> 1) get current channel #
> 2) issue a MESH_STOP command with the old channel
> 3) change the channel
> 4) resend WEP keys to firmware if any
> 5) restart adhoc if adhoc is enabled
> 
> mesh:
> 
> 1) if STA is active and in infrastructure, deauth from AP
> 2) if STA is active and in adhoc, issue ADHOC_STOP
> 3) issue MESH_START with new channel

This means that STA/IBSS and Libertas' MESH cannot be active at 
the same time. In the cfg80211 case I can do the same, but 
without doing some magically "deauth from AP" or "send 
ADHOC_STOP" operation. I think it's better to keep this 
explicit. So the user will have to do "iw XXX disconnect" or "iw 
XXX ibss leave" to do that. If you're connected, "connecting" to 
mesh would simply fail.

To start LIBERTAS-MESH without WEXT, I'd generate a second wiphy 
device with .ibss_join and .ibss_leave operations, which in fact 
will use Libertas' mesh commands. Thus a user could do this:

iw wlan0 disconnect
iw wlan0 ibss leave
iw msh0 ibss join MESH 2412 key 0:12345

In another mail Dan wrote:

> There are really only 4 of them (get/set SSID, set channel, get
> mode) that matter for mesh.

Nothing of this is really a WEXT-only, so I'd rather get rid of 
WEXT completely, even for mesh. However, I need to abduct or 
re-use the cfg80211 ibss commands for this, but I guess that's 
not a problem.


Dan, Johannes, does this make sense?

-- 
http://www.holgerschurig.de

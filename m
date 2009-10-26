Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:36383 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZJZIAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 04:00:10 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Mon, 26 Oct 2009 08:59:38 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20091022133043.185554096@mail.mn-solutions.de> <1256315972.12174.168.camel@johannes.local> <1256316179.2164.53.camel@localhost.localdomain>
In-Reply-To: <1256316179.2164.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910260859.39002.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well if you want to push the mesh wext bits through to cfg80211
> > (temporarily) you wouldn't even need to depend on WEXT. I'd prefer,
> > however, to not do this, and just use the cfg80211 wext handlers in
> > libertas and depend on WEXT for now.
> 
> Yeah, I think it's best to handle the mesh WEXT ioctls separately for
> now.  There are really only 4 of them (get/set SSID, set channel, get
> mode) that matter for mesh.  The rest of the ioctls that the mesh
> interface supports get redirected to the cfg80211 handlers because they
> aren't specific to mesh.

We can reduce this to 3, because get/set channel could
simply go via cfg80211.

I'm unsure if we still need an GIWRANGE for mesh, but probably not.


Dan, you once said that you converted the MESH firmware
calls to new style commands. Do you have those around?  Maybe
I can re-work them if they don't apply anymore.

-- 
http://www.holgerschurig.de

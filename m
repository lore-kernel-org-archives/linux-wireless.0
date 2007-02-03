Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXBCRiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Feb 2007 12:38:00 -0500
Subject: Re: [RFC] cfg80211 merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240702021018m2dda838dyb85e956e42694e72@mail.gmail.com>
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070131183255.GB8776@tuxdriver.com>
	 <20070131202549.5ee47bd4@griffin.suse.cz>
	 <20070131200741.GA22448@infradead.org>
	 <20070131204438.GB19669@tuxdriver.com>
	 <1170277561.2236.6.camel@johannes.berg>
	 <1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
	 <1170335262.17068.6.camel@johannes.berg>
	 <1ba2fa240702010604o3cc827d6j1319579e15f28b48@mail.gmail.com>
	 <1170339078.22420.3.camel@johannes.berg>
	 <1ba2fa240702021018m2dda838dyb85e956e42694e72@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 03 Feb 2007 18:37:09 +0100
Message-Id: <1170524230.4629.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-02-02 at 20:18 +0200, Tomas Winkler wrote:

> I don't know who is missing something here, but what I'm saying that
> (1) is not correct. priv ioctls don't work with compatibility  set
> on. 

Yup, looks like a bug. This should fix it.

johannes

--- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-03 18:36:11.809570737 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-02-03 18:36:35.589570737 +0100
@@ -1395,7 +1395,7 @@ int cfg80211_wext_nl_get(struct net_devi
 					      &iw_handler_get_iwstats,
 					      p_buf, p_len);
 	if(request->cmd == SIOCGIWPRIV)
-		return -EOPNOTSUPP;
+		return -ENOSYS;
 
 	/* Basic check */
 	if (!netif_device_present(dev))
@@ -1618,7 +1618,7 @@ int cfg80211_wext_ioctl(struct ifreq *if
 						   &iw_handler_get_iwstats);
 
 		case SIOCGIWPRIV:
-			return -EOPNOTSUPP;
+			return -ENOSYS;
 		default:
 			/* Basic check */
 			if (!netif_device_present(dev))



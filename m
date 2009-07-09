Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19512 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbZGIRNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:13:48 -0400
Subject: Re: nl80211 and wext interoperability
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1247139797.2144.27.camel@johannes.local>
References: <1247139797.2144.27.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 13:13:45 -0400
Message-Id: <1247159625.28654.30.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-09 at 13:43 +0200, Johannes Berg wrote:

> Currently, if you use wpa_supplicant -Dwext and -Dnl80211 mixed,
> -Dnl80211 gets confused because -Dwext will set a 32-byte random SSID to
> "disconnect". When then the interface is brought UP again, the cfg80211
> code assumes that you set configuration while it was DOWN, and tries to
> recover that configuration. This means it will start scanning for the
> network, which means -Dnl80211 gets -EBUSY for the scan and it all gets
> very delayed. This also happens if you set an SSID with iwconfig before
> using -Dnl80211.

I'm seeing delay is I start wpa_supplicant with -Dwext on the current
wireless-testing.  I don't use -Dnl80211 on that system at all, as it
has stock Fedora 11 wpa_supplicant without nl80211 support.

I think using random data is a problem by itself.  Are we exposing
random pieces of kernel memory in probe requests?  That's bad.

> Do we just ignore that issue? It's only added timeout and people using
> purely nl80211 will never have a problem.
> 
> I'm all for ignoring wext issues, but I can also see people complain
> about things like this. Not sure what mac80211 did, did it just ignore
> settings while interfaces were down? I never really made sense of that
> code.

If your description is correct, I think the fix should be easy.

-- 
Regards,
Pavel Roskin

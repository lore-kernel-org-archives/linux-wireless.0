Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39037 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbZGMRzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 13:55:07 -0400
Subject: Re: nl80211 and wext interoperability
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1247161696.22527.1.camel@johannes.local>
References: <1247139797.2144.27.camel@johannes.local>
	 <1247159625.28654.30.camel@mj>  <1247161696.22527.1.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:55:24 -0400
Message-Id: <1247507724.4369.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-09 at 19:48 +0200, Johannes Berg wrote:
> On Thu, 2009-07-09 at 13:13 -0400, Pavel Roskin wrote:
> 
> > I think using random data is a problem by itself.  Are we exposing
> > random pieces of kernel memory in probe requests?  That's bad.
> 
> You misunderstood. wpa_supplicant _explicitly_ tells us it _wants_ to
> use that 32-byte random SSID. It's just like it telling us it wants to
> use the ssid "foobar" or "Pavel's House" or ... I don't see what we can
> do, other than actually take it seriously and at least attempt to
> connect to that network.

That was the idea, expect that this random BSSID/SSID combo will simply
fail to be found in a scan, and either the card driver will just keep
periodically scanning to find the AP until another request comes in, or
they will eventually just give up and idle.  What it was meant to do was
to stop the card from trying to keep re-associating to a previous AP now
that the supplicant has terminated.  See my just-posted mail a bit up in
this thread as to why.  WEXT sucks.

Dan



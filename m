Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab1FHNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:47:26 -0400
Date: Wed, 8 Jun 2011 15:47:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110608134721.GA2283@redhat.com> (sfid-20110608_154729_691770_37BCA87B)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <201106070832.49048.bschmidt@freebsd.org>
 <20110607145435.GA5179@redhat.com>
 <1307474580.2342.7.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307474580.2342.7.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 07, 2011 at 09:23:00PM +0200, Paul Bolle wrote:
> On Tue, 2011-06-07 at 16:54 +0200, Stanislaw Gruszka wrote:
> > That could be useful hint, we do not scan chan by chan, but we
> > have thing called "plcp check health", which "restart radio"
> > by requesting one channel scan. So perhaps disabling that could
> > help.
> 
> At this moment I'm interested in something (a script, some sequence of
> actions, whatever) that (somewhat) reliably triggers this error. Because
> right now I have no clue what triggers it.

Having reliable reproducer will be definitely something that is
nice to have. But bug could be some kind of race condition that happen
in code flow  once per 10000000000 cases ...  

> Is your patch in that category or is it a (crude) fix? If it's a fix,
> I'm not sure it is of much help at this stage.

It could be possible fix. Why you can not simply patch and see if errors
are still there? If after a week or so there will be no errors, we could
consider bug fixed, otherwise well ... still will need looking around
for fix.

I just posted patch that remove these "plcp health check" and related
code on -next anyway, because I don't think this is something that we
need.

Stanislaw

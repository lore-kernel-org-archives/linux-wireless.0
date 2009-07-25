Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:32272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZGYWby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 18:31:54 -0400
Received: by fg-out-1718.google.com with SMTP id e12so288835fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 15:31:54 -0700 (PDT)
Subject: Re: [BUG] Current head of wireless testing unusable
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1248558755.11389.21.camel@mj>
References: <1248531054.15242.16.camel@maxim-laptop>
	 <1248558755.11389.21.camel@mj>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 01:31:49 +0300
Message-Id: <1248561109.4753.9.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 17:52 -0400, Pavel Roskin wrote:
> On Sat, 2009-07-25 at 17:10 +0300, Maxim Levitsky wrote:
> > I probably should work more to did these bugs out myself, but anyway I
> > want to let you know what I currently see.
> > 
> > First system oopses just after NM starts up, happens always, and after
> > planting few test points bug happens somewhere in following lines. 
> 
> We are discussing a bug in the scan state machine in another thread,
> which could have nasty consequences in not caught.  And I don't quite
> understand why my system was catching it immediately, maybe because I'm
> using gcc 4.4, which has array bounds checking.
Yea, there are two patches with same title for this, I applied the
newer.

Currently thanks to Johannes Berg, the patch
[PATCH] nl80211: add missing parameter clearing
Fixes this nasty oops, now wireless more or less works, but plenty of
problems still, first it oopses on reconnect as inilialized from
wpa_supplicant, second iwconfig misses most of its settings, and
probably thus NM think signal level is zero. If I switch to good old
wext in wpa_supplicant, it works just fine and none of above problems
present (I recheck this again to be sure)

Thanks, I soon run kmemcheck as well.

Best regards,
	Maxim Levitsky

> 
> I have also seen two oopses in the code unrelated to wireless
> networking, one of which lead to my .bash_history becoming empty.
> 
> So please be extra careful.  It would be great if somebody could test
> the current kernel extensively with kmemcheck an other options and
> bisect the bad commit, whether it's wireless related or not.

Thanks!


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791AbZE1Huj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 03:50:39 -0400
Date: Thu, 28 May 2009 00:49:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Jason Andryuk <jandryuk@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	karllinuxtest.relton@ntlworld.com
Subject: Re: [Bugme-new] [Bug 13312] New: at76c50x-usb mutex deadlock
Message-Id: <20090528004925.d6d9be31.akpm@linux-foundation.org>
In-Reply-To: <bug-13312-10286@http.bugzilla.kernel.org/>
References: <bug-13312-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 14 May 2009 20:54:54 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13312
> 
>            Summary: at76c50x-usb mutex deadlock
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.30-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: network-wireless
>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>         ReportedBy: karllinuxtest.relton@ntlworld.com
>                 CC: kalle.valo@iki.fi
>         Regression: No
> 
> 
> at76_dwork_hw_scan() does a mutex_lock and then calls
> ieee80211_scan_completed(). This in turn calls at76_config() which then tries
> to do the same mutex_lock and thus the driver goes into deadlock.
> 
> I believe the solution would be for at76_dwork_hw_scan() to unlock the mutex
> before calling ieee80211_scan_completed(). I've tried this with my card, and it
> does indeed avoid the lockup - though I have yet to get the card working
> properly with this driver.
> 

umm, is anyone looking at
drivers_network-wireless@kernel-bugs.osdl.org?  This one seems a bit of
a no-brainer?


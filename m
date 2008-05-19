Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763567AbYESX1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 19:27:17 -0400
Date: Mon, 19 May 2008 16:26:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, jckn@gmx.net
Subject: Re: [Bugme-new] [Bug 10755] New: iwl3945 regression - NULL deref in
 ieee80211_associate
Message-Id: <20080519162655.f79208cd.akpm@linux-foundation.org> (sfid-20080520_012721_451517_D7DB61CF)
In-Reply-To: <bug-10755-10286@http.bugzilla.kernel.org/>
References: <bug-10755-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 May 2008 15:56:01 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10755
> 
>            Summary: iwl3945 regression - NULL deref in ieee80211_associate
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26-rc3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: network-wireless
>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>         ReportedBy: jckn@gmx.net
> 
> 
> Latest working kernel version: 2.6.26-rc2
> Earliest failing kernel version: 2.6.26-rc3
> Distribution: Debian
> Hardware Environment: Lenovo Thinkpad R61 (8943-DLG)
> Software Environment:
> Problem Description: iwl3945 trying to associate to an AP leads to a kernel
> oops. The current (2008/05/19) linuxwireless.org compat-wireless driver is
> affected, too.
> 

A post-2.6.25 regression.

EIP is at ieee80211_associate+0x253/0x640 [mac80211]

and it might not be iwl3945-specific.

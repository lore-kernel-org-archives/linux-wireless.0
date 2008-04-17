Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYDQVaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 17:30:05 -0400
Date: Thu, 17 Apr 2008 14:29:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: thoralf.dassler@gmail.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10471] New: iwl3945 in 2.6.25 ignores state of
 hardware RF kill switch
Message-Id: <20080417142934.be2bdd27.akpm@linux-foundation.org> (sfid-20080417_223011_544049_2E85C246)
In-Reply-To: <bug-10471-10286@http.bugzilla.kernel.org/>
References: <bug-10471-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).


On Thu, 17 Apr 2008 14:17:51 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10471
> 
>            Summary: iwl3945 in 2.6.25 ignores state of hardware RF kill
>                     switch
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.25
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: network-wireless
>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>         ReportedBy: thoralf.dassler@gmail.com
> 
> 
> Latest working kernel version: 2.6.24.3 (possibly 2.6.24.4, but have not had
> it)
> Earliest failing kernel version: 2.6.25
> Distribution: Slackware 12
> Hardware Environment: Toshiba Satellite P200
> Software Environment: n/a
> Problem Description: With the 2.6.25 kernel, iwl3945 sees the state of the
> hardware RF kill switch, but ignores the state. This causes long boot delays
> because the adapter tries to make a connection when the switch is in the OFF
> position.
> 
> Steps to reproduce:
> boot up the system; none of the following showed with 2.6.24.3
> 
> 
> messages during boot:
> -----------------------------------
> SIOCSIFFLAGS: No such device
> [3 lines of irrelevant output on my iwl3945]
> SIOCSIFFLAGS: No such device
> 
> 
> dmesg:
> -----------
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100002,
> writing 100006)
> iwl3945: Radio disabled by HW RF Kill switch
> [message repeated 7 more times]
> 

Yeah, I got bitten by that too.  Apparently it's deliberate and other
wireless drivers will start to do the same thing soon.

It's totally dumb that the initscritps pause *at all* when the kill switch
is in "kill" mode.  Hopefully one day userspace will get fixed (I assume
the problem is in userspace).



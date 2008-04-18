Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:52702 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYDRQg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 12:36:57 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [Bugme-new] [Bug 10471] New: iwl3945 in 2.6.25 ignores state of hardware RF kill switch
Date: Fri, 18 Apr 2008 09:27:30 -0700
Message-ID: <D936D925018D154694D8A362EEB089200438B254@orsmsx416.amr.corp.intel.com> (sfid-20080418_173705_101614_2D3E27EF)
In-Reply-To: <20080417142934.be2bdd27.akpm@linux-foundation.org>
References: <bug-10471-10286@http.bugzilla.kernel.org/> <20080417142934.be2bdd27.akpm@linux-foundation.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
	<thoralf.dassler@gmail.com>
Cc: <bugme-daemon@bugzilla.kernel.org>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First to address the subject of this bug, the driver does not ignore the
state of the hardware RF kill switch. More below.

On , Andrew Morton  wrote:

> On Thu, 17 Apr 2008 14:17:51 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 

>> 
>> 
>> messages during boot:
>> -----------------------------------
>> SIOCSIFFLAGS: No such device
>> [3 lines of irrelevant output on my iwl3945]
>> SIOCSIFFLAGS: No such device

This is exactly the error returned by the driver when it detects that
the hardware RF kill switch is set. With several message like above in
your logs - could it be a user app that keeps trying to bring the
interface up even when it returns an error?


>> dmesg:
>> -----------
>> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
>> PM: Writing back config space on device 0000:04:00.0 at offset 1
>> (was 100002, writing 100006) iwl3945: Radio disabled by HW RF Kill
>> switch [message repeated 7 more times]

It is right after printing this message that the driver returns
"ENODEV".

>From what I can tell the driver is doing the right thing. What is the
expected behavior in this scenario?

Reinette

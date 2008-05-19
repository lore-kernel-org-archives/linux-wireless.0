Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39828 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760979AbYESXsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 19:48:33 -0400
Message-ID: <483211DA.5080205@lwfinger.net> (sfid-20080520_014838_774697_476E215E)
Date: Mon, 19 May 2008 18:48:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	jckn@gmx.net, Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <hschaa@suse.de>
Subject: Re: [Bugme-new] [Bug 10755] New: iwl3945 regression - NULL deref
 in ieee80211_associate
References: <bug-10755-10286@http.bugzilla.kernel.org/> <20080519162655.f79208cd.akpm@linux-foundation.org>
In-Reply-To: <20080519162655.f79208cd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton wrote:
> On Mon, 19 May 2008 15:56:01 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=10755
>>
>>            Summary: iwl3945 regression - NULL deref in ieee80211_associate
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.26-rc3
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: network-wireless
>>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>>         ReportedBy: jckn@gmx.net
>>
>>
>> Latest working kernel version: 2.6.26-rc2
>> Earliest failing kernel version: 2.6.26-rc3
>> Distribution: Debian
>> Hardware Environment: Lenovo Thinkpad R61 (8943-DLG)
>> Software Environment:
>> Problem Description: iwl3945 trying to associate to an AP leads to a kernel
>> oops. The current (2008/05/19) linuxwireless.org compat-wireless driver is
>> affected, too.
>>
> 
> A post-2.6.25 regression.
> 
> EIP is at ieee80211_associate+0x253/0x640 [mac80211]
> 
> and it might not be iwl3945-specific.

This bug looks like the one I found and reported in 
http://marc.info/?l=linux-wireless&m=121097330013277&w=2. I found it for b43 
- it is clearly not iwl3945 specific.

The patch is in version 4 and probably not the final one, but it fixes the 
oops. You will find the patch at 
http://marc.info/?l=linux-wireless&m=121120929012836&w=2.

We know that bss is NULL when mac80211 tries to associate; however, I had 
only one of these that happened after my interface had been connected to my 
AP for ~18 hours, then got disassociated, followed by the oops. It sounds as 
if jckn@gmx.net might be getting this systematically and there is hope to 
find the root cause so as to prevent the problem rather than covering over 
the symptoms as is done with the patch. In any case, there is a fix in the works.

I have added Johannes and Helmut to the CC list.

Larry

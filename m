Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab0BPVQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:16:23 -0500
From: "Nguyen, TrieuX T" <trieux.t.nguyen@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
CC: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Date: Tue, 16 Feb 2010 13:16:11 -0800
Subject: RE: "Monitor and recover the aggregation TX flow failure" goes a
 	little bit nuts
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB95D88F48E@orsmsx502.amr.corp.intel.com>
References: <cb0375e11002161142o48fc45c0r32dfd7538bae28f5@mail.gmail.com>
 	<ADDEBCD9C145E542A8688C29F1FBDCB95D88F3DD@orsmsx502.amr.corp.intel.com>
 <cb0375e11002161240t2e5130acke3a425163d1f533f@mail.gmail.com>
In-Reply-To: <cb0375e11002161240t2e5130acke3a425163d1f533f@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I agreed that this is a work around.  But we do need to tune radio and firmware when external conditions affect the throughput.  It looks like that this patch doesn't work in your case, because it was more specific to NIC 1000.  From the data you provided, only one radio tuning/reset is evoked, the rest is ignored.  It just printed out the debug messages you put in. Please see my explanation below with <--

[128695.217054] call iwl_force_reset(IWL_RF_RESET)  <-- this call is evoked
[128697.515296] call iwl_force_reset(IWL_RF_RESET)  <-- this called is ignored as it was called under 3 secs apart
[128698.034922] call iwl_force_reset(IWL_RF_RESET)  <-- this called is ignored as was called under 3 secs apart
[128699.602022] call iwl_force_reset(IWL_FW_RESET)  <-- this called is ignored as it was called under 3 secs apart 
[128699.710573] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[128699.710586] iwlagn 0000:03:00.0: queue number out of range: 0,
must be 10 to 19
[128701.623101] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:21:d8:49:d6:f2 tid = 0
[128702.526568] call iwl_force_reset(IWL_RF_RESET) <-- this called is ignored as it was called under 3 secs apart   
...
...

We are still working on the new patch to cover this issue.
Thanks,
Trieu "Andrew" Nguyen

-----Original Message-----
From: amluto@gmail.com [mailto:amluto@gmail.com] On Behalf Of Andrew Lutomirski
Sent: Tuesday, February 16, 2010 12:41 PM
To: Nguyen, TrieuX T
Cc: ipw3945-devel@lists.sourceforge.net; linux-wireless@vger.kernel.org; Chatre, Reinette
Subject: Re: "Monitor and recover the aggregation TX flow failure" goes a little bit nuts

On Tue, Feb 16, 2010 at 3:17 PM, Nguyen, TrieuX T
<trieux.t.nguyen@intel.com> wrote:
> Look like you got 1 firmware reset at [128699.602022] which takes about 4 secs to get back to normal from the tx flow throughput issue.
> iwl_force_reset(IWL_RF_RESET) is the radio reset when the throughput drop detected through the ack_count ratio < 50% and the number of agg block ack time out exceed 5.  This function call will be ignored if it is called within 3 secs.

But it keeps happening for a lot longer than 4 seconds.

> Which NIC do you run the test from?

It's a 5350 at 2412 MHz.

It looks like this patch works around some kind of bug without really
fixing it.  What's going so wrong that it takes a firmware reset to
fix it?  I'm pretty sure Windows doesn't have any problems.  These
problems can happen within seconds of associating on Linux.

(For reference, I have a Lenovo X200s that is barely usable at work
with 802.11n enabled on Linux but works just fine on Windows.  A
coworker's T61 has the same problem, and he's also running Linux on a
different NIC (5300 or 4965 I think -- I don't remember exactly).

--Andy

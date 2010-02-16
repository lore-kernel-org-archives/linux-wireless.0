Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59442 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab0BPUlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:41:13 -0500
Received: by fxm7 with SMTP id 7so7711075fxm.28
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:41:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ADDEBCD9C145E542A8688C29F1FBDCB95D88F3DD@orsmsx502.amr.corp.intel.com>
References: <cb0375e11002161142o48fc45c0r32dfd7538bae28f5@mail.gmail.com>
	<ADDEBCD9C145E542A8688C29F1FBDCB95D88F3DD@orsmsx502.amr.corp.intel.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 16 Feb 2010 15:40:50 -0500
Message-ID: <cb0375e11002161240t2e5130acke3a425163d1f533f@mail.gmail.com>
Subject: Re: "Monitor and recover the aggregation TX flow failure" goes a
	little bit nuts
To: "Nguyen, TrieuX T" <trieux.t.nguyen@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0DUUu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 16:50:56 -0400
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
 time out after 500ms
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
	 <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 13:50:56 -0700
Message-ID: <1271883056.4381.1743.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sedat,

On Wed, 2010-04-21 at 00:06 -0700, Sedat Dilek wrote:
> >> According to Johannes (on IRC) iwl3945 doesn't use internal scans yet
> >> (see my patch below).
> >> Thus, I am not sure if this needs to be fixed separately for iwl3945
> >> and if I ran into a scan race condition here.
> >
> > Does this patch make any difference for you?
> >
> 
> Speaking of my patch "iwl3945-fix-scan-races.patch" from [3]?
> I was guessing iwl3945 has internal scans support - is that the fact?
> Johannes told me someone is working on it.

It has some support ... but nothing that currently requests an internal
scan.

> To answer your question: Not sure, but it seems not to help.

Weird.

> >
> > It does. Thank you. As a sanity check, could you please try this patch?
> >
> 
> In general, it would be very helpful to give some comments on what
> this offered patch is doing.
> Not sure, if I can test it today.
> 

>From your logs I see that it is right after disconnecting from AP (after
loosing probe responses) that the problem occurs. I see that we send QOS
commands to the device, to which it responds, but after that you start
to get errors. I looked at when those QOS commands are sent and they are
sent in ieee80211_set_disassoc _after_ the queues have been disabled. I
am not sure if that is the right thing to do and wanted to check if it
is indeed those commands that are causing the issue. The patch I asked
you to test modified the code to not send QOS commands after queues have
been disabled.

> By the way, might help to set one of the module-options for iwl3945?
> 
> parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both]) (int)
> parm:           swcrypto:using software crypto (default 1 [software]) (int)
> parm:           debug:debug output mask (uint)
> parm:           disable_hw_scan:disable hardware scanning (default 0) (int)
> parm:           fw_restart3945:restart firmware in case of error (int)
> 
> Especially "fw_restart3945" in my case?

It should be set by default.

>  On which errors it is
> restarting firmware?

Firmware errors. 

Reinette



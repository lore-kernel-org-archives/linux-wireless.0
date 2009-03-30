Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:2721 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753269AbZC3RkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:40:07 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rfkill: rewrite
Date: Mon, 30 Mar 2009 10:39:51 -0700
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local>
In-Reply-To: <1238406057.24972.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903301039.52153.inaky@linux.intel.com> (sfid-20090330_194011_616611_A0EEDB75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009, Johannes Berg wrote:
>
>  * wimax
>    -> need help, seems to report rfkill states to input device?
>       don't understand

Not really. 

What it does is if the device exposes a hw rfkill key, export that 
key as an input device, as well as using it to report the state
change. 

So there are three main entry points:

wimax_report_rfkill_hw() -- device driver report to stack
  
   device reports a change in the hw rfkill key; switch the radio to
   whichever state AND report a key event through the input layer

wimax_report_rfkill_sw() -- device driver report to stack

   device reports a change in the sw rfkill state; this is needed for
   cases where the radio is shared amongst different technologies (wifi
   and wimax, for example, in the case of the 5150). When you turn on
   Wifi, WiMAX switches off (and vice versa).

   As well, if from SW you flip it off, this gets called back but does
   nothing as the state is updated already.

wimax_rfkill / wimax_rfkill_toggle_radio -- user interface

   The user wants to flip the SW switch on/off

-- 
Inaky

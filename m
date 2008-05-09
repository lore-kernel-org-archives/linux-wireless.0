Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:62062 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYEIXlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 19:41:16 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0M00D4MKGR91C0@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Fri, 09 May 2008 19:41:15 -0400 (EDT)
Date: Fri, 09 May 2008 19:41:14 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -	2.6.26-rc1
 kernel
In-reply-to: <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1210376474.3856.7.camel@X61.NetworkingUnlimited.com> (sfid-20080510_014121_408712_C5C9409D)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-05-10 at 00:23 +0300, Tomas Winkler wrote:
> On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
> <v.jones@networkingunlimited.com> wrote:
> > The channel/frequency reporting by iwlwifi is incompatible with
> >  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
> >  versus wpa_supplicant scan results are below. Association still works if
> >  the correct channel is specified using iwconfig, but that is
> >  incompatible with roaming.
> 
> Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'
> 
> Thanks
> Tomas

This patch did not apply cleanly to plain 2.6.26-rc1: off by -4 lines in
iwl-3945.c and by 1078 lines in iwl-4965.c. More important, it did not
fix the problem of wpa_supplicant thinking the 802.11A access points are
on channel 0. Same results with 2.6.26-rc1-git7, with & without patch.
Any idea when this patch (and the patches it appears to depend on) will
make it into the 2.6.26 release? 

Vince

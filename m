Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:48585 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbYDBTDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 15:03:08 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JYP00B6ZOX6SI20@mta1.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Wed, 02 Apr 2008 15:03:06 -0400 (EDT)
Date: Wed, 02 Apr 2008 15:03:06 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
In-reply-to: <D936D925018D154694D8A362EEB0892004194819@orsmsx416.amr.corp.intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1207162986.12301.32.camel@X61.NetworkingUnlimited.com> (sfid-20080402_200322_442172_AA2D2074)
MIME-version: 1.0
Content-type: text/plain
References: <1207092107.12301.18.camel@X61.NetworkingUnlimited.com>
 <D936D925018D154694D8A362EEB0892004194819@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 11:21 -0700, Chatre, Reinette wrote:
> On , Vincent C Jones  wrote:
> 
> > Agree, it should not be necessary to use both iwconfig &
> > wpa_supplicant, but somewhere between the last official release for
> > Intel 4965 and the latest the 3/27/2008 release, it has become
> > necessary, at least for some of us. SuSE 10.3, all kernels tried from
> > 2.6.22 through 2.6.25-rc4. Some data points which might give
> > you a clue:
> 
> To check we are using the same code ... could you please use the latest
> iwlwifi driver by making use of the compat-wireless project
> (http://linuxwireless.org/en/users/Download)?
> 
> > 
> > Incidentally, should the 802.11n work using 802.11n draft on 5Ghz?
> 
> yes
> 
> Reinette

Downloaded, compiled and tested with today's version
(compat-wireless-2008-04-02) compat-release "2.8-50-g7b9853d".

Same results as before:

iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26k
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:c1:8a:23:40
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:c1:8a:23:40
wlan0: RX authentication from 00:1a:c1:8a:23:40 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:1a:c1:8a:23:40
wlan0: authentication frame received from 00:1a:c1:8a:23:40, but not in
authenticate state - ignored
wlan0: RX deauthentication from 00:1a:c1:8a:23:40 (reason=6)
wlan0: deauthenticated

execute - iwconfig wlan0 chan 149

wlan0: authenticate with AP 00:1a:c1:8a:23:40
wlan0: RX authentication from 00:1a:c1:8a:23:40 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:1a:c1:8a:23:40
wlan0: RX AssocResp from 00:1a:c1:8a:23:40 (capab=0x11 status=0 aid=1)
wlan0: associated

Note that upon further testing, I don't need to specify the AP address,
only the channel to use, and only if the channel is in the 5Ghz band.

Other info:
   uname -a
Linux X61 2.6.22.17-0.1-test #2 SMP Tue Apr 1 11:33:27 EDT 2008 x86_64
x86_64 x86_64 GNU/Linux

Lenovo 7675CTO X61 ThinkPad T7500 (2.2MHz Core-2 Duo), SuSE 10.3 X86_64

Any other info that would help (or tests to run), just let me know.

Vince

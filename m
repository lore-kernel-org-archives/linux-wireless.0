Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22477 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab0CCVTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 16:19:34 -0500
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current
 wireless-testing
From: reinette chatre <reinette.chatre@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	 <201003011927.53208.helmut.schaa@googlemail.com>
	 <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
	 <201003022047.10196.helmut.schaa@googlemail.com>
	 <1267640304.15761.121.camel@rchatre-DESK>
	 <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 13:19:33 -0800
Message-ID: <1267651173.15761.155.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-03 at 12:14 -0800, Daniel Halperin wrote:
> On Mar 3, 2010, at 10:18 AM, reinette chatre wrote:
> > 	Band 2:
> > [...]
> > 		Frequencies:
> > 			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
> > 			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
> > 			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
> > 			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
> > 			* 5260 MHz [52] (disabled)
> > 			* 5280 MHz [56] (disabled)
> > 			* 5300 MHz [60] (disabled)
> > 			* 5320 MHz [64] (disabled)
> > 			* 5500 MHz [100] (disabled)
> > 			* 5520 MHz [104] (disabled)
> > 			* 5540 MHz [108] (disabled)
> > 			* 5560 MHz [112] (disabled)
> > 			* 5580 MHz [116] (disabled)
> > 			* 5600 MHz [120] (disabled)
> > 			* 5620 MHz [124] (disabled)
> > 			* 5640 MHz [128] (disabled)
> > 			* 5660 MHz [132] (disabled)
> > 			* 5680 MHz [136] (disabled)
> > 			* 5700 MHz [140] (disabled)
> 
> Is this really correct?

This is the information that iw provides. I am not familiar with how it
obtains it and is perhaps just a reflection of the regulatory domain in
use as opposed to what the device actually supports. The above does not
reflect what the device is capable of and since it does its own
regulatory things should work. When I load the module with debug=0x1 I
do see that the channels listed above as disabled can be used (just not
for beaconing) since they are radar channels.


[13071.468278] ieee80211 phy0: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
[13071.476329] ieee80211 phy0: U iwl_init_channel_map Ch. 36 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
[13071.487587] ieee80211 phy0: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
[13071.495646] ieee80211 phy0: U iwl_init_channel_map Ch. 40 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
[13071.506902] ieee80211 phy0: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
[13071.514952] ieee80211 phy0: U iwl_init_channel_map Ch. 44 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
[13071.526210] ieee80211 phy0: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
[13071.534260] ieee80211 phy0: U iwl_init_channel_map Ch. 48 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
[13071.545520] ieee80211 phy0: U iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.556293] ieee80211 phy0: U iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.567032] ieee80211 phy0: U iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.577770] ieee80211 phy0: U iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.588509] ieee80211 phy0: U iwl_init_channel_map Ch. 100 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.599332] ieee80211 phy0: U iwl_init_channel_map Ch. 104 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.610157] ieee80211 phy0: U iwl_init_channel_map Ch. 108 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.620999] ieee80211 phy0: U iwl_init_channel_map Ch. 112 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.631822] ieee80211 phy0: U iwl_init_channel_map Ch. 116 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.642646] ieee80211 phy0: U iwl_init_channel_map Ch. 120 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.653471] ieee80211 phy0: U iwl_init_channel_map Ch. 124 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.664294] ieee80211 phy0: U iwl_init_channel_map Ch. 128 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.675120] ieee80211 phy0: U iwl_init_channel_map Ch. 132 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.685977] ieee80211 phy0: U iwl_init_channel_map Ch. 136 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.696802] ieee80211 phy0: U iwl_init_channel_map Ch. 140 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[13071.707624] ieee80211 phy0: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
[13071.715762] ieee80211 phy0: U iwl_init_channel_map Ch. 149 Flags 0 [5.2GHz] - No traffic
[13071.723897] ieee80211 phy0: U iwl_init_channel_map Ch. 153 Flags 0 [5.2GHz] - No traffic
[13071.732041] ieee80211 phy0: U iwl_init_channel_map Ch. 157 Flags 0 [5.2GHz] - No traffic
[13071.740185] ieee80211 phy0: U iwl_init_channel_map Ch. 161 Flags 0 [5.2GHz] - No traffic
[13071.748322] ieee80211 phy0: U iwl_init_channel_map Ch. 165 Flags 0 [5.2GHz] - No traffic


>  With some update between now and a while ago (October?) I can no
> longer even monitor on most 11a channels. (E.g., "iwconfig wlan0 mode
> monitor ; iwconfig wlan0 channel 64" returns an error). This was not
> the old behavior, and seems to be wrong to me.

What error do you get? Have you tried to set up monitor channel using
iw? Is bisect an option to try to find out what caused this?

Reinette




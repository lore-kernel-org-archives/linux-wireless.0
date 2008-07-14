Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYGNSFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 14:05:49 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] iwl3945 random firmware crashes
Date: Mon, 14 Jul 2008 11:05:40 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com> (sfid-20080714_200553_697427_3E61D4AC)
In-reply-to: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com>
References: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "drago01" <drago01@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try loading driver using module param:

debug=0x43fff

This will provide more information in the log, including an event log
(where you see "Microcode SW Error detected" in your log, you would have
captured Event Log if you had the debug=0x43fff setting).

-- Ben --

> -----Original Message-----
> From: ipw3945-devel-bounces@lists.sourceforge.net 
> [mailto:ipw3945-devel-bounces@lists.sourceforge.net] On 
> Behalf Of drago01
> Sent: Monday, July 14, 2008 7:38 AM
> To: linux-wireless; ipw3945-devel
> Subject: [ipw3945-devel] iwl3945 random firmware crashes
> 
> Hi,
> I noticed some weird firmware restarts with iwl3945 lately.
> -----------------
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> 0x4419 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.
> Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
> 0x0408 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.
> Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
> 0x0408 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.
> Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
> 0x0407 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.
> ---------------
> There seem to be random (can not reproduce them always) but 
> the only way to get the wireless working is to
> 1) unload the module
> 2) go to another room
> 3) load module
> 4) connect to AP
> 5) go back to the room and it works
> 
> If I stay in the same room after reloading the module the 
> firmware crashes happen again.
> 
> I have no output with the event log because they happen 
> randomly and I cannot reproduce them.
> 
> Any ideas?
> 
> --------------------------------------------------------------
> -----------
> Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
> Studies have shown that voting for your favorite open source 
> project, along with a healthy diet, reduces your potential 
> for chronic lameness and boredom. Vote Now at 
> http://www.sourceforge.net/community/cca08
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
> 

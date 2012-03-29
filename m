Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2C2LkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 07:40:23 -0400
Message-ID: <1333021216.3575.6.camel@jlt3.sipsolutions.net> (sfid-20120329_134031_221512_071A51F1)
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhong Hongbo <hongbo.zhong@windriver.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>,
	"'Foglia, Michael'" <Michael.Foglia@windriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Mark Zhan <rongkai.zhan@windriver.com>
Date: Thu, 29 Mar 2012 13:40:16 +0200
In-Reply-To: <4F71E566.50802@windriver.com>
References: <4F687667.1030605@windriver.com>
	   <1332247526.3329.17.camel@jlt3.sipsolutions.net>
	   <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com>
	  <1332248855.3329.18.camel@jlt3.sipsolutions.net>
	  <4F6B1D8B.8060306@windriver.com>
	 <1332751883.3511.5.camel@jlt3.sipsolutions.net>
	 <4F71E566.50802@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zhong,

> Mar 23 12:44:48 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:44:48 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:44:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:44:50 localhost last message repeated 3 times
> Mar 23 12:44:51 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:44:53 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:44:53 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:44:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:44:55 localhost last message repeated 3 times

This is a bit strange -- any idea what was happening at this time? It
seems to repeat for quite a while until it finally associates properly:

> Mar 23 12:45:16 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:45:16 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:45:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:17 localhost kernel: br0: port 1(wlan0) entering forwarding state
> Mar 23 12:45:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:18 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a RADIUS: starting accounting session 4F6C702C-00000000
> Mar 23 12:45:18 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a WPA: pairwise key handshake completed (RSN)

Is it possible that the system you're running the AP on doesn't have
enough entropy to do the 4-way handshake earlier?

> Mar 23 12:45:48 localhost dhcpd: Internet Systems Consortium DHCP Server 4.2.1-P1
> Mar 23 12:45:48 localhost dhcpd: Copyright 2004-2011 Internet Systems Consortium.
> Mar 23 12:45:48 localhost dhcpd: All rights reserved.
> Mar 23 12:45:48 localhost dhcpd: For info, please visit https://www.isc.org/software/dhcp/
> Mar 23 12:45:48 localhost dhcpd: Wrote 0 leases to leases file.
> Mar 23 12:45:48 localhost dhcpd: Listening on LPF/br0/a0:88:b4:18:64:a0/192.168.0.0/24
> Mar 23 12:45:48 localhost dhcpd: Sending on   LPF/br0/a0:88:b4:18:64:a0/192.168.0.0/24
> Mar 23 12:45:48 localhost dhcpd: 
> Mar 23 12:45:48 localhost dhcpd: No subnet declaration for eth0 (128.224.163.192).
> Mar 23 12:45:48 localhost dhcpd: ** Ignoring requests on eth0.  If this is not what
> Mar 23 12:45:48 localhost dhcpd:    you want, please write a subnet declaration
> Mar 23 12:45:48 localhost dhcpd:    in your dhcpd.conf file for the network segment
> Mar 23 12:45:48 localhost dhcpd:    to which interface eth0 is attached. **
> Mar 23 12:45:48 localhost dhcpd: 
> Mar 23 12:45:48 localhost dhcpd: Sending on   Socket/fallback/fallback-net

Are you really starting dhcpd this late, after the client connected?
Does the client then even get a proper IP address?

> Mar 23 12:45:57 localhost dhcpd: DHCPDISCOVER from 00:1f:e2:cc:f5:0a via br0
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:58 localhost dhcpd: DHCPOFFER on 192.168.0.52 to 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0
> Mar 23 12:45:58 localhost dhcpd: DHCPREQUEST for 192.168.0.52 (192.168.0.1) from 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0
> Mar 23 12:45:58 localhost dhcpd: DHCPACK on 192.168.0.52 to 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0

Ok, I guess it looks like it does get an IP address.

The remainder of this log looks perfectly normal, just like you'd expect
with a client in powersave.

Do you think you could get a wireless sniffer and record over-the-air
traffic?

johannes


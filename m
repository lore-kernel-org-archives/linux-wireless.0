Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33450 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755823Ab0JVRnQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 13:43:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Subject: RE: Help: Guidance on "AP/VLAN" mode
Date: Fri, 22 Oct 2010 13:43:07 -0400
Message-ID: <0E78D47E19ECA44893BC64D10E0D130E014FA568@efjrocmx01.EFJDFW.local>
In-Reply-To: <20101022152753.GA4853@jm.kir.nu>
References: <loom.20101021T172706-705@post.gmane.org> <20101022152753.GA4853@jm.kir.nu>
From: Chaoxing Lin <clin@3eti.com>
To: Jouni Malinen <j@w1.fi>
CC: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Thanks Jouni. I appreciate your response. My comments/discussion are
below interleaved in email.

-----Original Message-----
From: Jouni Malinen [mailto:j@w1.fi] 
Sent: Friday, October 22, 2010 11:28 AM
To: Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: Re: Help: Guidance on "AP/VLAN" mode

On Thu, Oct 21, 2010 at 03:54:30PM +0000, Chaoxing wrote:
> 1. Can any one here help me understand what mac80211 "AP/VLAN" mode is
and how
> it's used? I googled and could not find a good document on this. 

See dynamic-VLAN configuration in hostapd.conf.

CLIN: I saw that dynamic-VLAN section. And did not quite understand how
to setup. Is there any further documentation on dynamica-VLAN?

Must the interface in /etc/hostapd.vlan be type of __ap_vlan? Or it can
be any AP interface specified in "bss=xxx" in multi-BSSID case?


> 2. If it's meant for VLAN interface for multiple-SSID, how is the VLAN
ID
> configured?

In theory, it could be used with multiple-SSID (i.e., mapping from SSID
to VLAN), but there is no support for that in hostapd. The main use for
this AP/VLAN interface is to get VLAN ID from a RADIUS server (or for
more limited testing, from a local text file based on the station MAC
address).

CLIN: Getting VLAN ID from Radius server means all VLANs must use 802.1x
way for authentication. This limits the flexibility of multiple-SSID. My
current AP with proprietary driver&app allow different VLAN to use any
authentication/encryption. Although hostapd provide build-in radius
server, it's kind of a hack to use it just to add VLAN ID for clients
using WEP/WPA-PSK

> 3. In my AP with proprietary driver, there's multiple-SSID over the
same BSSID.
> (Meaning they share the same MAC address.) Each SSID is mapped to one
VLAN.
> Broadcasting SSID is disabled.
> On receiving packet from clients, AP adds VLAN tag per SSID client
associates.
> On transmitting packet to clients, AP remove VLAN tag.
> Is it possible to achieve the above functionality through existing
open source
> software(mac80211, iw, hostapd, radio driver, etc)?

You can do similar setup with RADIUS-based VLAN ID allocation. Though,
mac80211 will leave the VLAN tagging or other upper layer configuration
to other parts of the networking stack (VLAN, bridge, IP routing).
hostapd can set that up for the bridge and WLAN interfaces and if
desired, you can then bind those to tagged ethernet interface.

Since we support multi-BSSID configuration (which is superior to
multi-SSID for most cases), I haven't seen enough justification to work
with multi-SSID functionality. Do you have a use case that would need it
or would the RADIUS-based VLAN ID allocation or multi-BSSID support
address your needs?

CLIN: 
1. Most of the time multi-BSSID is superior to multi-SSID. But
multi-BSSID uses multiple MAC addresses and each radio actually has only
reserved one MAC address. Meaning, all other MAC addresses used are
actually reserved by other radio/Ethernet adapter, etc. When product
like this goes on market, it's bound to have MAC address conflict,
unless vendor reserves enough MAC for its product. It's kind of a waste
to reserve 32 (in my case) MAC addresses per radio since most of the
time multi-BSSID won't be used in SOHO. 

2. The other thing regarding hostapd dynamic VLAN is that it creates a
bridge for each VLAN and tag is only added at a certain interface e.g.
"vlan_tagged_interface=eth0". There are a few problems with this design.

	a. One bridge for each VLAN overloads system unnecessarily. It
means that all protocols over bridge have to run multiple copies, one
per bridge. This is expensive for embedded devices.

	b. In case there multiple interfaces need vlan tag, does hostapd
allow me to put multiple interfaces in "vlan_tagged_interface=xxx"
option? Even if it allows that, it's still inconvenient if the interface
list is dynamic. My current product has one bridge which encloses 
one Ethernet port, 
AP/VLAN interface, 
and multiple(dynamic, auto detect by proprietary app) WDS interfaces. 

Only AP/VLAN interface adds/removes/checks VLAN tag per SSID, while all
other interfaces in the bridge pass packet as is (In other words, they
behave as VLAN trunk ports). Eventually, it's up to the VLAN switch
attached at the Ethernet port to distribute packet per VLAN rules. It
seems hard for me to use current (mac80211, hostapd, iw, etc) to achieve
what I need.


 
-- 
Jouni Malinen                                            PGP id EFC895FA



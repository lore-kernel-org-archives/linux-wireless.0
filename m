Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48860 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab0JVP16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:27:58 -0400
Date: Fri, 22 Oct 2010 18:27:53 +0300
From: Jouni Malinen <j@w1.fi>
To: Chaoxing <clin@3eti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Help: Guidance on "AP/VLAN" mode
Message-ID: <20101022152753.GA4853@jm.kir.nu>
References: <loom.20101021T172706-705@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20101021T172706-705@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 03:54:30PM +0000, Chaoxing wrote:
> 1. Can any one here help me understand what mac80211 "AP/VLAN" mode is and how
> it's used? I googled and could not find a good document on this. 

See dynamic-VLAN configuration in hostapd.conf.

> 2. If it's meant for VLAN interface for multiple-SSID, how is the VLAN ID
> configured?

In theory, it could be used with multiple-SSID (i.e., mapping from SSID
to VLAN), but there is no support for that in hostapd. The main use for
this AP/VLAN interface is to get VLAN ID from a RADIUS server (or for
more limited testing, from a local text file based on the station MAC
address).

> 3. In my AP with proprietary driver, there's multiple-SSID over the same BSSID.
> (Meaning they share the same MAC address.) Each SSID is mapped to one VLAN.
> Broadcasting SSID is disabled.
> On receiving packet from clients, AP adds VLAN tag per SSID client associates.
> On transmitting packet to clients, AP remove VLAN tag.
> Is it possible to achieve the above functionality through existing open source
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

-- 
Jouni Malinen                                            PGP id EFC895FA

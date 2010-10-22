Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36643 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab0JVLqN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 07:46:13 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1P9G4X-0000hu-Sa
	for linux-wireless@vger.kernel.org; Fri, 22 Oct 2010 13:46:10 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 13:46:09 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 13:46:09 +0200
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: Help: Guidance on &quot;AP/VLAN&quot; mode
Date: Fri, 22 Oct 2010 11:45:58 +0000 (UTC)
Message-ID: <loom.20101022T132016-729@post.gmane.org>
References: <loom.20101021T172706-705@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chaoxing <clin@...> writes:
> 
> 1. Can any one here help me understand what mac80211 "AP/VLAN" mode is and how
> it's used? I googled and could not find a good document on this. 

I think it's not what you think it is. My understanding is, that this is a
special AP mode that allows one to bridge traffic through the AP *AND* the
client. For this to work the 802.11 frames have to carry 4 addresses instead
of the normal 3. 

> 2. If it's meant for VLAN interface for multiple-SSID, how is the VLAN ID
> configured?

I think it's not, see above.
> 
> 3. In my AP with proprietary driver, there's multiple-SSID over the same BSSID.
> (Meaning they share the same MAC address.) Each SSID is mapped to one VLAN.
> Broadcasting SSID is disabled.
> On receiving packet from clients, AP adds VLAN tag per SSID client associates.
> On transmitting packet to clients, AP remove VLAN tag.
> Is it possible to achieve the above functionality through existing open source
> software(mac80211, iw, hostapd, radio driver, etc)?

I have not done this, but since nobody else replied I'll explain what I think
you have to do:

Lets say you have two VLANs, tagged with 5 and 6.

1) create two VAP interfaces with iw:
   iw phy phy0 interface add vap5 type managed
   iw phy phy0 interface add vap6 type managed
   (I think managed is ok, hostapd will change this to ap)
2) run hostapd on each of the VAP interfaces, use different SSIDs
3) create VLAN interfaces on top of your VLAN trunk interface (e.g. where you
   get the tagged frames). Use either vconfig or ip to do this.
   vconfig add eth0 5
   vconfig add eth0 6
   this will create the VLAN interfaces eth0.5 and eth0.6
4) create bridges to connect the AP interfaces with the VLANs
   brctl addbr "br5"
   brctl addbr "br6"
5) connect the APs with the corresponding VLANs
   brctl addif br5 eth0.5
   brctl addif br5 vap5
   brctl addif br6 eth0.6
   brctl addif br6 vap6

   Now the *untagged* traffic from VLAN 5 should be bridged to vap5 and from
   VLAN 6 to vap6.

Once again, this is untested! This is just how I think this could be done.

Regards
  Joerg


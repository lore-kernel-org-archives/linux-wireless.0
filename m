Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53142 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab2JXRt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:49:56 -0400
Received: from pip.localnet ([93.200.124.211]) by smtp.web.de (mrweb102) with
 ESMTPSA (Nemesis) id 0LpO93-1Sxoog0M9F-00fXUp for
 <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 19:49:55 +0200
From: Marquel <marquel@web.de>
To: linux-wireless@vger.kernel.org
Subject: [SOLVED] Setting up hostapd for dynamic 802.1Q VLAN support in a bridged environment
Date: Wed, 24 Oct 2012 19:49:53 +0200
Message-ID: <3490279.UoOPdvO576@pip> (sfid-20121024_195001_501132_6B7E4CFB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

Quick reader version:
Create an interface pair with vEth, add one of the pair's interfaces to the 
bridge the AP's should be connected to, set up hostapd's dynamic VLAN 
tagging feature as described in the example configuration file with the 
other interface of the pair as the interface where tagged frames should 
appear and comment 'bridge=' from the wifi interface's configuration 
options. Restart hostapd.

Long version:

I'm running a quite peculiar setup of my main server at home and that made 
some special setups necessary. First an overview of my setup:
 _____________                    ________________________________________
| Core Switch |                  |              Server  ________________  |
|             |------------------|eth0\                |   KVM-router   | |
|        LAG 1| (un)tagged VLANs |     bond0-br0-tap0--|eth0            | |
|             |------------------|eth1/       |        |________________| |
|_____________|                  |        WIFI/                           |
                                 |________________________________________|
(I sincerely hope someone can make sense of this graphic...)

The problem about this setup is the KVM-based router above: It has one 
interface (among others removed for understandability) which transmits and 
receives frames for all known VLANs. Thus the bridge br0 has to maintain 
those 802.1Q tags on all frames passing through it. Services running on the 
server itself are thus bound to br0.<vlan-id> as needed.

Transferring frames from one VLAN to another is only done within the KVM-
based router, nowhere else.

Now with hostapd this posed a problem:
The default setup with nl80211 driver is to specify the bridge to which the 
AP's interface should be added. All frames passing through the AP appear on 
that very bridge.
In my setup this doesn't work anymore, as untagged frames would always be 
part of VLAN 1, the last one where wifi-clients are supposed to appear not 
to mention this renders VLAN-ID assignment by radius useless.

The solution to this problem (thanks to Paul Fertser for pointing me in that 
direction) was to disable the general bridging in hostapd and putting a pair 
of ethernet interfaces to perform communication with the bridge.

The setup now looks like this:
 _____________                    ________________________________________
| Core Switch |                  |              Server  ________________  |
|             |------------------|eth0\                |   KVM-router   | |
|        LAG 1| (un)tagged VLANs |     bond0-br0-tap0--|eth0            | |
|             |------------------|eth1/       |        |________________| |
|_____________|                  |       veth0/                           |
                                 |         |                              |
                                 | WIFI--veth1                            |
                                 |________________________________________|

In other words: A pair of virtual ethernet interfaces is created 
(CONFIG_VETH and iproute2 is needed here) of which one is then added to the 
bridge the AP is supposed to be connected to.

The other interface of the pair is specified as vlan_tagged_interface.

The changes in hostapd configuration look like this now:

> #bridge=br0 # Commented in favor of using vlan_tagged_interface
> dynamic_vlan=2
> vlan_file=/etc/hostapd/hostapd.vlan
> vlan_tagged_interface=veth1

This setup works well, including IPv4 DHCP and IPv6 autoconfiguration.

I hope this helps anyone running into a similar problem with hostapd.

Kind regards,
Marquel


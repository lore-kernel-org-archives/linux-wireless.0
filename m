Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from columbi.unine.ch ([130.125.1.54]:39518 "EHLO unine.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530Ab1CKOBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 09:01:08 -0500
Received: from mail-10.unine.ch ([130.125.5.93])
	by unine.ch stage1 with esmtps
	(Exim MailCleaner)
	id 1Py2oN-00040O-JQ
	for <linux-wireless@vger.kernel.org>
	from <alexey.monakhov@unine.ch>; Fri, 11 Mar 2011 14:55:23 +0100
From: MONAKHOV Alexey <alexey.monakhov@unine.ch>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 11 Mar 2011 14:54:13 +0100
Subject: question about setting up mesh network
Message-ID: <96025834431BF6428294777AA66CB92B027A0A66420D@MAIL-2.UNINE.CH>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

I have several questions about 802.11s, 802.11n and mesh networks in Linux (2.6.37.1 kernel)
with these devices
alix3d2 device (http://pcengines.ch/alix3d2.htm) with this card (http://pcengines.ch/dnma92.htm  Atheros AR9220  chipset).
and I am trying to configure mesh netwroks with these commands

 iw dev wlan0 interface add mesh_iface type mp mesh_id mesh_id
 iwconfig mesh_iface essid monaale_mesh
 ifconfig mesh_iface 192.168.3.80
 ifconfig mesh_iface up

1.
I am using node with 2 wi-fi interfaces - my question is how to make a bridge with these 2 interfaces? Now I set 1 channel for one interface and 2 channel for the other one and traffic goes from one interface to other without any bridge - why?

2.
I can see that olsrd daemon is running, my question is how can I enable 802.11s routing ? (kernel was compiled with CONFIG_MAC80211_MESH=y option)

3.
how to be sure that mesh is operationg in 802.11n mode? now the speed is 54 Mb\sec but accoring to iwconfig command I can see wlan1 IEEE 802.11abgn interface enabled.

4.
how can I determine my neighbors IP addresses. i.e. I  get a list of nearest nodes with
iw dev mesh station dump command, abd how determine IP of MAC? ( without arp cache because it is empty).
also do you know if it is possible to determine MAC (or IP) address of the neighbor from which IP package came to my node (not the source IP by my 1-hop neighbor who forwarded package to me). As I understand there is no such information in the IP or layer2 header.

thanks in advance,
Alexey.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:44881 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZI0Nvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 09:51:48 -0400
Received: from ion.localnet (ion.storm.lieberbiber.de [217.28.107.11])
	by hogsmeade.leitwerk.net (Postfix) with ESMTPSA id 8A33EA8904
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 15:41:59 +0200 (CEST)
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: linux-wireless@vger.kernel.org
Subject: Unable to create an 802.11s mesh using compat-wireless-2009-09-27
Date: Sun, 27 Sep 2009 15:41:58 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909271541.58448.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello List,

I built todays compat-wireless (compat-wireless-2009-09-27) on two different 
Ubuntu machines:

- kernel 2.6.28-15-generic i686 using rt73usb
- kernel 2.6.31-11-generic x86_64 using ath5k (AR2425)

and tried to create an 802.11s Mesh following the HOWTO - unsuccessfully:

root@ion:/home/sturmflut# export MESH_IFACE=mesh
root@ion:/home/sturmflut# export MESH_ID=test
root@ion:/home/sturmflut# iw dev wlan0 interface add $MESH_IFACE type mp 
mesh_id $MESH_ID

root@ion:/home/sturmflut# ifconfig -a | grep mesh
mesh      Link encap:Ethernet  HWaddr 00:22:75:50:13:c2

root@ion:/home/sturmflut# ifconfig $MESH_IFACE up
SIOCSIFFLAGS: Name not unique on network

if I remove wlan0 the mesh device can be brought up through ifconfig:

root@ion:/home/sturmflut# iw dev wlan0 del
root@ion:/home/sturmflut# ifconfig $MESH_IFACE up

The strange thing is that iwconfig lists the interface as Mode "Auto" 
immediately after it is added:

root@ion:/home/sturmflut# iwconfig mesh
mesh      IEEE 802.11bg  Mode:Auto  Tx-Power=11 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on

and falls back to "Managed" after about five seconds:

root@ion:/home/sturmflut# iwconfig mesh
mesh      IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
          Tx-Power=11 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

Symptoms are identical on both machines. I remember this working some weeks 
ago, at least using the ath5k driver, and without any "Name not unique on 
network" errors.

I could try with a full wireless-testing.git checkout but I doubt anything 
will change, Ubuntus 2.6.31-11-generic is quite recent and all relevant 
modules should have been overwritten by those in compat-wireless.

regards,
Simon Raffeiner

University of Applied Sciences Offenburg

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from david.siemens.de ([192.35.17.14]:19824 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0C2MsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 08:48:21 -0400
Received: from mail2.siemens.de (localhost [127.0.0.1])
	by david.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2TCmJYw011076
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 14:48:19 +0200
Received: from [139.25.3.71] (marco-laptop.mchp.siemens.de [139.25.3.71] (may be forged))
	by mail2.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2TCmJCe013504
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 14:48:19 +0200
Message-ID: <4BB0A16A.7080400@siemens.com>
Date: Mon, 29 Mar 2010 14:47:38 +0200
From: Marco Porsch <marco.porsch@siemens.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iw station del broken?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

is it just me or is 'iw dev <devname> station del <MAC address>' broken?

I am using it in mesh mode to build generic topologies out of a fully 
meshed net. I am using it first since Javiers latest patch "[PATCH v2] 
mac80211: Handle mesh action frames in ieee80211_rx_h_action" which 
fixed mesh mode successfully.

I didn't try it in anything other than mesh. Running latest OpenWrt with 
compat-wireless-2010-03-24 and kernel 2.6.32.10 including Javiers patch. 
Maybe a fix for nl80211 is missing?


root@OpenWrt:/# iw dev imesh5g station get xx:xx:xx:xx:xx:xx
Station xx:xx:xx:xx:xx:xx (on imesh5g)
        inactive time:  410 ms
        rx bytes:       8569
        rx packets:     132
        tx bytes:       321
        tx packets:     5
        signal:         -19 dBm
        tx bitrate:     6.0 MBit/s
        mesh llid:      2784
        mesh plid:      64165
        mesh plink:     ESTAB
root@OpenWrt:/# iw dev imesh5g station del xx:xx:xx:xx:xx:xx
command failed: Invalid argument (-22)


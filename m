Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1BKLGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 06:06:38 -0500
Received: by wyb28 with SMTP id 28so2345974wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 03:06:37 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Feb 2011 14:06:37 +0300
Message-ID: <AANLkTinOMu1yr+XYqhRiaBfHut4jUL-ZXbP9-PFyamKG@mail.gmail.com>
Subject: 802.11s power save improvement
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

We have noticed that Linux kernel does not implement power save in a mesh
networking (802.11s). We have compared Linux kernel sources and IEEE 802.11s
standard and discovered next issues in power save mesh implementation:

1. Add peer-plink power mode (See 11C.13.2).
Add nl80211 interface and cfg80211 parameter, accessible via iw:
   * iw dev <devname> station set <MAC address> plink_power <active|light|deep>
   * iw dev <devname> station get <MAC address> plink_power

2. Indicate non-peer power mode in relevant frames (11C.13.3):
   * beacon
   * probe response
   * QoS control field in group addressed mesh data

3. Indicate link-specific power mode in relevant frames (11C.13.4.1):
   * individually addressed mesh data
   * QoS Null

4. Track mesh peer power mode in sta_info.
Use indication in acknowledged unicast mesh data/QoS Null frames to record
current peer power mode.

5. Buffer mesh data frames for sleeping peers.
Make indication for unicast frames in TIM bitmap.
Deliver group addressed frames after DTIM.

6. Indicate mesh awake window in beacon/probe response frames (11C.13.7).

7. Implement peer service periods (11C.13.10)

We are going to fix this problems.
Has someone looked into the issue before, what was the major problem that
is preventing this from being fixed?
May be someone is already working in this area?
Also all commentaries, advices and tips are appreciated.

Thank you.

Ivan Bezyazychnyy,
Open Source & Linux Lab

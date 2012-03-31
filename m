Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64248 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab2CaKAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 06:00:00 -0400
Received: by bkcik5 with SMTP id ik5so1261605bkc.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 02:59:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Why is throughput so bad with lots of virtual stations?
Date: Sat, 31 Mar 2012 11:59:54 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4F76806E.2010101@candelatech.com>
In-Reply-To: <4F76806E.2010101@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201203311159.55238.chunkeey@googlemail.com> (sfid-20120331_120040_307018_E5B4CF45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 March 2012 05:56:30 Ben Greear wrote:
> I notice that when I get, say, 200 virtual stations on a radio (ath9k),
> the total throughput becomes about 100 packets per second.  It can run
> several thousands of packets per second with 10 or so stations.
is this tcp or udp "throughput"?

Anyway, I don't know much about your AP. But If it's mac80211 based
then you might also run into a problem with ath9k vs mac80211 for
every sta_info_get_bss [used by ieee80211_find_sta et. al] call.
You see, the station hash table uses the last byte of a station's
MAC as the "HASH" [see STA_HASH]. So for 00:11:22:33:44:55, the hash
is "55". Now, ath9k uses a mac mask for it's VIFs as well, only it 
starts from the other direction [i.e.:] xy:11:22:33:44:55. 
[e.g.: vif1: 00:11:22:33:44:55, vif2: 04:11:22:33:44:55,
vif3: 0c:11:22:33:44:55, ...]

So, mac80211's sta hash table really becomes a "long list". Which has
to be traversed by the driver and stack several times. 

> According to the xmit debugfs file, the radio is basically idle.
> It's queues are empty almost all of the time, few retransmits, etc.
> 
> This is on the 3.0.26 kernel.
> 
> If anyone has any ideas of what might need work, please let me know.
> 
> I'll start digging into the code to see what I can see.

Regards,
	Chr

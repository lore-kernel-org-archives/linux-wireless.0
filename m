Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58025 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab1AJXIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 18:08:14 -0500
Received: by wwa36 with SMTP id 36so1157143wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 15:08:13 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 18:08:13 -0500
Message-ID: <AANLkTi=2N5A0ZBoULj3d0Bp_GeWQouHGFA_LRWWu1k22@mail.gmail.com>
Subject: packet injection not working on rt2800usb, ath9k
From: Andy Pyles <andy.pyles@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using linux-wireless snapshot from December, 2010 with the
following driver: rt2800usb

The linux-wireless snapshot for ath9k is from last summer ( July)

As an example I'm building a program based on:
http://wireless.kernel.org/en/users/Documentation/packetspammer

Steps to test:
( Sender Host A rt2800usb: usbid: Bus 001 Device 002: ID 148f:3070
Ralink Technology, Corp. )
1.) sudo iw phy phy0 interface add moni0 type monitor
2.) sudo iw dev moni0 set channel 11
3.) run packet injector via: pcap_inject()
4.) run tcpdump on moni0 and observe injected packet

( Receiver Host B: 04:02.0 Network controller: Atheros Communications
Inc. AR5008 Wireless Network Adapter (rev 01))
1.) sudo iw phy phy0 interface add moni0 type monitor
2.) sudo iw dev moni0 set channel 11
4.) run tcpdump on moni0 injected packet NOT received.

Sanity test1: When I send a packet from A to B, packet is observed on moni0
Sanity test2: ran standalone packetspammer with no modifications with
the same result.

Question: Is this operation supported on these two devices? If not,
what device can you recommend a device where this does work?

regards,
Andy

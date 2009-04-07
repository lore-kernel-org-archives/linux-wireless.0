Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:49233 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZDGAP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 20:15:58 -0400
Received: by bwz17 with SMTP id 17so2095470bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 17:15:55 -0700 (PDT)
Subject: Making promisc mode work with WPA encryption?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 03:15:52 +0300
Message-Id: <1239063352.4705.40.camel@maxim-laptop> (sfid-20090407_021606_189492_3B4B42DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my last question I want  to ask.
I finally got time to learn how WPA2 encryption works.
so there is per station key (temporal key), and one multicast key (group
key). TK is derived from PSK by throwing together macs or both ends, two
random numbers, and PMK (whick in case of wpa personal == PSK

This means kernel can't automatically decrypt other stations traffic.
But I could arrange small program that listens to device in monitor or
maybe even just promisc mode, and records WPA handshakes. For every
handshake it could install the key in kernel driver, so it would use it
for decryption, and show the traffic on device in promisc mode. Is it
possible to do today? I guess not.
All this program has to know is the PSK.
(I could even arrange WPA supplicant to do this job - it knows all keys
already)

Best regards,
	Maxim Levitsky


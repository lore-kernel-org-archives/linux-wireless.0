Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34349 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1GDUI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:08:58 -0400
Received: by fxd18 with SMTP id 18so5527298fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:08:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id ACB92100455
	for <linux-wireless@vger.kernel.org>; Mon,  4 Jul 2011 22:08:55 +0200 (CEST)
Received: from blech.mobile ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BepzFHmw+i04 for <linux-wireless@vger.kernel.org>;
	Mon,  4 Jul 2011 22:08:55 +0200 (CEST)
Received: from blech.localnet (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id 2CABD10038F
	for <linux-wireless@vger.kernel.org>; Mon,  4 Jul 2011 22:08:55 +0200 (CEST)
To: linux-wireless@vger.kernel.org
Subject: Re: carl9170: Problems setting up Virtual Interface
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 4 Jul 2011 22:08:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201107042208.54936.chunkeey@googlemail.com> (sfid-20110704_220912_362490_FA8F4C54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 04, 2011 09:46:46 PM Alex wrote:
> I am using the carl9170 interface from the 2.6.39.2 kernel with the
> newest carl9170 firmware. I have set-up an AP with hostapd. Everything
> is working so far:
> 
> root@box:~# ifconfig
> mon.wlan0 Link encap:UNSPEC  HWaddr <deleted>
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:27070 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:4583087 (4.3 MiB)  TX bytes:0 (0.0 B)
> 
> wlan0     Link encap:Ethernet  HWaddr <deleted>
>           inet addr:192.168.80.1  Bcast:192.168.80.255  Mask:255.255.255.0
>           inet6 addr: fe80::76ea:3aff:fe8f:130c/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:320 errors:0 dropped:1 overruns:0 frame:0
>           TX packets:231 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:28815 (28.1 KiB)  TX bytes:26887 (26.2 KiB)
> 
> I am now trying to create an additional virtual intereface to connect
> wireless to my router as described on:
> 
> http://linuxwireless.org/en/users/Documentation/iw/vif/
> 
> with
> iw dev wlan0 interface add wlan1 type station
> 
> However, ifconfig does not list the additional wlan1 interface.
The virtual interface might not be listed because it can't be
brought up since it shares the same mac with the main interface.



so try "ifconfig -a" ?



Regards,
	Chr

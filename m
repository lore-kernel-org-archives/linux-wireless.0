Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:55682 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZANNaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 08:30:05 -0500
Received: by yx-out-2324.google.com with SMTP id 8so217493yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 05:30:04 -0800 (PST)
Message-ID: <40f31dec0901140530n7ff2029em67687dcd1eab590f@mail.gmail.com> (sfid-20090114_143012_870261_36556A3A)
Date: Wed, 14 Jan 2009 15:30:03 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Glenn Burkhardt" <gbburkhardt@verizon.net>
Subject: Re: poor performance with ath5k; reverting to ath_pci
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200901140003.31693.gbburkhardt@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200901140003.31693.gbburkhardt@verizon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/14 Glenn Burkhardt <gbburkhardt@verizon.net>:
> I just upgraded my system to Suse 11.1, and it installed the ath5k driver.  I
> started having trouble with network access, and found that the response time
> to the wireless router in my house was lousy:
>
> glenn@DepotRd:~> ping 192.168.2.1
> PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=1233 ms
> 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1901 ms
> 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=1550 ms
>
> So I pulled the madwifi-0.9.4-1.src.rpm, and re-configured to use the ath_pci
> driver.  The results were much better:
>
> glenn@DepotRd:~> ping 192.168.2.1
> PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.493 ms
> 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.485 ms
> 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.501 ms
> 64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=0.518 ms
>
> The card I have is the Netgear WG311T, which reports with PCI ID
> 0x168c:0x0013, and in the log as "Atheros Communications Inc. Atheros AR5001X+
> Wireless Network Adapter (rev 01)".
>
> I'd be happy to try to help figure out why the response time is so bad with
> the ath5k driver, but I'm completely new to this code set.

Can you please post the dmesg output from when ath5k loads ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

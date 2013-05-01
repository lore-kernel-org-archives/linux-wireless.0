Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sjcbarracuda02.arubanetworks.com ([199.127.104.60]:45988 "EHLO
	sjcbarracuda02.arubanetworks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab3EAOtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 10:49:41 -0400
Received: from ALPINEMEADOWS.arubanetworks.com ([10.1.8.22]) by sjcbarracuda02.arubanetworks.com with ESMTP id AVnyDkbaa4D5Vnwu (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 07:49:40 -0700 (PDT)
Message-ID: <51812B80.1030705@arubanetworks.com> (sfid-20130501_164945_507119_96BCED7B)
Date: Wed, 1 May 2013 16:49:36 +0200
From: Shawn Adams <sadams@arubanetworks.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi no HT function - is_lq_table_valid
References: <5180F0C0.3070002@arubanetworks.com>
In-Reply-To: <5180F0C0.3070002@arubanetworks.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


All,

Please disregard this post, the issue was /etc/modprobe.d/iwlwifi.conf

This and /etc/modprobe.d/iwlwifi.conf both contained conflicting
11n_disable lines, apparently iwlwifi.conf
takes precedence, HT was in fact, disabled.

 grep . /sys/module/iwlwifi/parameters/*
/sys/module/iwlwifi/parameters/11n_disable:1

Apologies for missing this.




On 05/01/2013 12:38 PM, Shawn Adams wrote:
> Hello,
>
> I'm new to the list, and have one question, apologies if this not
> appropriate for this list.
>
>
> I have recently updated a Lenovo T410s to opensuse 12.3, and noted that the
> PC will no longer connect HT to anything.
>
> It connects fine at both 802.11a and 802.11g, but never with HT.
>
> throughout is ~30Mbps,  both AP and card list the connection at 54Mbps
>
>
> This worked before the update from opensuse 12.2 and the older
> kernel/iwlwifi driver, using
> 5Ghz HT at throughput at 90Mbps
>
>
> I see these messages in the debug, regardless of which band or channel
> is used:
>
>
> 2013-04-30T21:33:02.853629+02:00 lamda kernel: [ 6355.226711] iwlwifi
> 0000:03:00.0: I is_lq_table_valid Channel 48 is not an HT channel
>
>
> This event occurs in 802.11g and 802.11a bands, and on a variety of APs,
> channels.
>
> At the same moment a number of different clients are happily using HT on
> the same channel and AP.
>
>
> I read through some of the related patch, but not being a coder, was not
> able to answer tihs question:
>
> What is the driver detecting that tells it this is not an HT channel ?
>
>
> hints very much appreciated.
>
> Best regards,
>
>
>
>
>
>
> Background info:
>
> Linux lamda 3.7.10-1.1-default #1 SMP Thu Feb 28 15:06:29 UTC 2013
> (82d3f21) i686 i686 i386 GNU/Linux
>
>
> 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200
> (rev 35)
>     Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN
>     Flags: bus master, fast devsel, latency 0, IRQ 44
>     Memory at f2400000 (64-bit, non-prefetchable) [size=8K]
>     Capabilities: [c8] Power Management version 3
>     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>     Capabilities: [e0] Express Endpoint, MSI 00
>     Capabilities: [100] Advanced Error Reporting
>     Capabilities: [140] Device Serial Number 58-94-6b-ff-ff-57-31-cc
>     Kernel driver in use: iwlwifi
>
>
> Connected to d8:c7:c8:9e:dd:09 (on wlan0)
>     SSID: priv_cert
>     freq: 5240
>     RX: 13154608 bytes (28155 packets)
>     TX: 1411780 bytes (6962 packets)
>     signal: -57 dBm
>     tx bitrate: 54.0 MBit/s
>
>     bss flags:    short-slot-time
>     dtim period:    0
>     beacon int:    100
>
>
>
>


-- 

Shawn Adams
ACMA,ACMP,CPPA
Principle Network Engineer, Customer Advocacy
Tel: +49 151 1265 4997
Email: sadams@arubanetworks.com <mailto:sadams@arubanetworks.com>

*AIRHEADS SOCIAL*

Wireless Network Headaches? Find Your Cure.
community.arubanetworks.com <http://community.arubanetworks.com/>



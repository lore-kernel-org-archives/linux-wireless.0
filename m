Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60848 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2E2SX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 14:23:28 -0400
Message-ID: <4FC51418.5000104@candelatech.com> (sfid-20120529_202332_168812_2246E0D8)
Date: Tue, 29 May 2012 11:23:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL> <4FC2437C.9090106@candelatech.com>
In-Reply-To: <4FC2437C.9090106@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2012 08:08 AM, Ben Greear wrote:
> On 05/26/2012 09:39 AM, Sujith Manoharan wrote:

>> With UDP, these are the numbers I get:
>>
>> Server: [ iperf -i1 -s -u -l 8K ]
>>
>> [  3] 29.0-30.0 sec  38.9 MBytes   327 Mbits/sec   0.246 ms   10/ 4993 (0.2%)
>> [  3] 30.0-31.0 sec  38.6 MBytes   323 Mbits/sec   0.260 ms   34/ 4970 (0.68%)
>> [  3] 31.0-32.0 sec  39.3 MBytes   330 Mbits/sec   0.212 ms   14/ 5045 (0.28%)
>> [  3] 32.0-33.0 sec  37.2 MBytes   312 Mbits/sec   0.229 ms   15/ 4777 (0.31%)
>> [  3] 33.0-34.0 sec  39.0 MBytes   327 Mbits/sec   0.253 ms   13/ 5002 (0.26%)

We started testing with two AR9380 NICs today (one AP, the other STA).
I applied Felix's skb optimization patch, and the ath9k memleak fix patch
on top of 3.3.7+.

When we generate traffic using a modified version of pktgen,
the STA interface transmits at around 310Mbps for a minute or
two, but then the system dies of OOM (and maybe worse..having
trouble getting useful serial console log).  It died much faster
before Felix's two patches were applied.

I disabled all of our network related buffer adjustments
(ie, no longer increasing tcp_wmem, etc), and it still
crashes.

The system has 2GB RAM, but it is 32-bit kernel, so not all
is available to the networking code...  That said, the OOM
killer kills VNC and such.

Anyway, I'll try some memleak debugging to see if
I can find any leaks.  It seems to me that we should
not actually OOM just by trying to transmit too fast
on a station interface :P

PS.  If anyone knows how to make minicom ignore page
refreshes so that it doesn't obscure the last bit of
the crash log when BIOS starts up again, please let me know!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


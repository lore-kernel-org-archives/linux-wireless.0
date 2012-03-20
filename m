Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55395 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2CTUrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 16:47:02 -0400
Message-ID: <4F68ECC3.3000802@candelatech.com> (sfid-20120320_214708_938805_BECAD34A)
Date: Tue, 20 Mar 2012 13:46:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: avg-signal is weird in ath9k in 3.3.0
References: <4F68DEE8.60506@candelatech.com>
In-Reply-To: <4F68DEE8.60506@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 12:47 PM, Ben Greear wrote:
> I'm testing out some code to get a stations's avg-signal through ethtool-stats,
> and both it and /proc/net/wireless show ranges bouncing all over
> (from around -48 to -110) on an interface running heavy traffic.
>
> Are there any known bugs in 3.3.0 related to this?

Same with iw station dump:

[root@lec2010-ath9k-1 lanforge]# iw dev sta1 station dump
Station 00:88:99:88:99:01 (on sta1)
	inactive time:	2 ms
	rx bytes:	3646300587
	rx packets:	10768068
	tx bytes:	3444260988
	tx packets:	10706688
	tx retries:	187471399
	tx failed:	2
	signal:  	-47 dBm
	signal avg:	-64 dBm
	tx bitrate:	130.0 MBit/s MCS 15
[root@lec2010-ath9k-1 lanforge]# iw dev sta1 station dump
Station 00:88:99:88:99:01 (on sta1)
	inactive time:	1 ms
	rx bytes:	3655139651
	rx packets:	10775853
	tx bytes:	3452330988
	tx packets:	10714184
	tx retries:	187604280
	tx failed:	2
	signal:  	16 dBm
	signal avg:	-92 dBm
	tx bitrate:	130.0 MBit/s MCS 15

Thanks,
Ben

>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


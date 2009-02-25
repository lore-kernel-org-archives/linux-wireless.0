Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43553 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbZBYRsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 12:48:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Latest test  with open-source firmware
Date: Wed, 25 Feb 2009 18:46:31 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <49A56B1F.80702@lwfinger.net>
In-Reply-To: <49A56B1F.80702@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200902251846.31531.mb@bu3sch.de> (sfid-20090225_184818_720128_02CD0FE6)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 February 2009 17:00:31 Larry Finger wrote:
> Francesco and Lorenzo,
> 
> In my latest test, I cut the RX and TX queue depths to 32 and ran my usual
> stress test. This time I logged whenever there was an increase in the depth of
> the txstatus queue, and whenever the queue depth was 16. The results were as
> follows:
> 
> Feb 24 19:27:08 mtech kernel: b43: Max Queue depth is now 2
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 3
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 4
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 5
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 6
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 7
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 8
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 9
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 10
> Feb 24 19:28:46 mtech kernel: b43: Max Queue depth is now 11
> Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 12
> Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 13
> Feb 25 00:09:12 mtech kernel: b43: Max Queue depth is now 14
> Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 15
> Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 16
> Feb 25 00:09:50 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:09:54 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:10:55 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:26:24 mtech kernel: eth1: No ProbeResp from current AP
> 00:1a:70:46:ba:b1 - assume out of range
> 
> The 00:26:24 event was the interface going offline. That happens with
> proprietary firmware, thus I think that problem is with the driver, rather than
> the firmware.

Are you sure it's a problem at all and not just simply failure to deliver
certain important management frames due to _extreme_ queue pressure?
Especially the tight RX queue will have effects like dropped frames.

-- 
Greetings, Michael.

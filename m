Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48506 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaBFQYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 11:24:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21235.46879.960127.346448@gargle.gargle.HOWL> (sfid-20140206_172444_551204_75A79404)
Date: Thu, 6 Feb 2014 21:53:59 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: Remove ath9k rate control
In-Reply-To: <52F3B155.6010308@candelatech.com>
References: <1391662375-28781-1-git-send-email-sujith@msujith.org>
	<52F3B155.6010308@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Can you let us know the details on how your set up that TCP
> traffic?  For instance, number of streams, write size, socket
> buffer sizes, etc?  Upload, download, or are both similar
> throughput in your testing?

Stock OpenWrt (trunk) running on a 3x3 Scorpion board (AP136/AP135) as AP.
Windows 7 as client, using a 3x3 AR9300 card.

iperf with window size 512k, 4 parallel threads. With both
TX and RX, 290+ Mbps is seen. UDP traffic: 330 Mbps in both directions.
Environment: open air and the station is located about 1 meter from the AP.

> I find that those settings influence throughput a great deal,
> and I have not yet been able to reach 295Mbps of TCP throughput
> in our testing w/out hacking the tcp-ack logic to increase ack delays.

By adjusting TCP parameters using sysctl or hacking the code ?

Sujith

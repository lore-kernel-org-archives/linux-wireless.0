Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42310 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaCaG2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 02:28:15 -0400
Message-ID: <53390AE4.4030705@candelatech.com> (sfid-20140331_082828_142851_5D73CD1E)
Date: Sun, 30 Mar 2014 23:27:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Here are some ath10k performance graphs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally have a firmware stable enough to do some throughput
tests (only locked station machine up once doing these!).

I find the download test interesting where the rx link rate goes very low
after 12 or so stations.

tx link rate is not reported properly yet by ath10k, so ignore that.

http://www.candelatech.com/examples/cap-ath10k-tcp-download-open/
http://www.candelatech.com/examples/cap-ath10k-tcp-download-wpa2/
http://www.candelatech.com/examples/cap-ath10k-tcp-upload-open/
http://www.candelatech.com/examples/cap-ath10k-tcp-upload-wpa2/

Some notes are near the top of each report, and in general:

The station machine is sending to/from wired Eth1 to/from the
stations, ie it is both sides of the network.
The AP is configured as router.  Both systems are running
our customized 10.1.467-ct firmware, and near the latest ath10k kernel.  Station
machine is Fedora 17, AP is Fedora 19.  Both are 64-bit, CPU is a mobile core-i7,
8GB RAM, SSD hard drives (not that it should matter).

Due to the vagaries of ath10k hardware and our firmware, we get hardware acceleration when
sending encrypted packets, but we have to decrypt received packets on the CPU.

I am not sure why open TCP throughput is so bad compared to upload.
I'll run some UDP tests when I get a chance.


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


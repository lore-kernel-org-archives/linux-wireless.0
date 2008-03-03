Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:41884 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbYCCPkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 10:40:47 -0500
Message-ID: <47CC1926.1090708@aitel.hist.no> (sfid-20080303_154102_528147_0AF8F74E)
Date: Mon, 03 Mar 2008 16:28:38 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with iwl3945, hard to connect to encrypted networks
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Dell830 that uses the 3945 driver.
I have tried kernels 2.6.23, 2.6.24 and 2.6.35-rc3.

Unencrypted networks seems to work well,
I usually connect on first try.

Encrypted networks are harder. They work fine
once I get connected, but I have to try
very many times before the connection works.

I bring up the interface using
ifconfig wlan0 up
and configure it with
iwconfig wlan0 essid SSID key s:password

If I run iwconfig first, I usually get something
like this in the dmesg log:
ADDRCONF(NETDEV_UP): wlan0: link is not ready

If I run iwconfig after ifconfig, I get:
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:14:1b:5a:13:40
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wlan0: RX authentication from 00:14:1b:5a:13:40 (alg=0 transaction=2 
status=0)
wlan0: authenticated
wlan0: associate with AP 00:14:1b:5a:13:40
wlan0: mismatch in privacy configuration and mixed-cell disabled - abort 
association
wlan0: RX deauthenticaion from 00:14:1b:5a:13:40 (reason=2)
wlan0: deauthenticated


Try fifty times - and sometimes it just works. Most of the time I get 
this exact failure.  The same happens with other access points that uses 
encryption. Retrying manually is tedious though.

I compiled the kernels myself using gcc-4.2.3 from debian.
The kernel is 64-bit and SMP, to take full advantage of
the core2duo processor.


Helge Hafting








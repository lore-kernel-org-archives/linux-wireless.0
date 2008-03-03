Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he2.nervous.it ([87.230.21.66]:50330 "EHLO he2.nervous.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbYCCPqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 10:46:33 -0500
Message-ID: <47CC1D54.7030302@atsystem.org> (sfid-20080303_154750_770177_CCEEBEC2)
Date: Mon, 03 Mar 2008 16:46:28 +0100
From: Antonio Quartulli <quartulli@atsystem.org>
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problems with iwl3945, hard to connect to encrypted networks
References: <47CC1926.1090708@aitel.hist.no>
In-Reply-To: <47CC1926.1090708@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

try using the iwlwifi module in the compat-wireless-2.6
It seems to work very well here.
In past, I got same problem with kernel module.

Helge Hafting ha scritto:
> I have a Dell830 that uses the 3945 driver.
> I have tried kernels 2.6.23, 2.6.24 and 2.6.35-rc3.
> 
> Unencrypted networks seems to work well,
> I usually connect on first try.
> 
> Encrypted networks are harder. They work fine
> once I get connected, but I have to try
> very many times before the connection works.
> 
> I bring up the interface using
> ifconfig wlan0 up
> and configure it with
> iwconfig wlan0 essid SSID key s:password
> 
> If I run iwconfig first, I usually get something
> like this in the dmesg log:
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> If I run iwconfig after ifconfig, I get:
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:14:1b:5a:13:40
> wlan0: privacy configuration mismatch and mixed-cell disabled - 
> disassociate
> wlan0: RX authentication from 00:14:1b:5a:13:40 (alg=0 transaction=2 
> status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:14:1b:5a:13:40
> wlan0: mismatch in privacy configuration and mixed-cell disabled - abort 
> association
> wlan0: RX deauthenticaion from 00:14:1b:5a:13:40 (reason=2)
> wlan0: deauthenticated
> 
> 
> Try fifty times - and sometimes it just works. Most of the time I get 
> this exact failure.  The same happens with other access points that uses 
> encryption. Retrying manually is tedious though.
> 
> I compiled the kernels myself using gcc-4.2.3 from debian.
> The kernel is 64-bit and SMP, to take full advantage of
> the core2duo processor.
> 
> 
> Helge Hafting
> 
> 
> 
> 
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Antonio Quartulli,
  Student of Computer Science at University of Pisa
  Web: www.quartulli.org

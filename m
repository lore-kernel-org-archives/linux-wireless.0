Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:62508 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYHHACm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 20:02:42 -0400
Received: by ik-out-1112.google.com with SMTP id c28so660577ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 17:02:40 -0700 (PDT)
Message-ID: <489B8D15.6060705@gmail.com> (sfid-20080808_020247_772319_311140D6)
Date: Fri, 08 Aug 2008 01:02:29 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH 00/19] orinoco: WPA for Agere based cards
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com> <1217975917.2908.27.camel@dv>
In-Reply-To: <1217975917.2908.27.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> I'm sorry, I'm really limited in time right now to do more tests, and
> I'm afraid I'll be mostly offline for the next 3 weeks.

Not a problem. Again thanks for testing. I'm just replying here for completeness.

> I could associate to a WPA1 AP with TKIP, but only on a 32-bit system.
> It still fails on the 64-bit system.  wpa_supplicant prints this in a
> loop:
> 
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> Wireless event: cmd=0x8c07 len=40
> AssocReq IE wireless event - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> Wireless event: cmd=0x8b15 len=24
> Wireless event: new AP: 00:0f:66:2f:ef:59
> Association info event
> req_ies - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> State: ASSOCIATED -> ASSOCIATED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> Associated with 00:0f:66:2f:ef:59
> WPA: Association event - clear replay counter
> WPA: Clear old PTK
> Setting authentication timeout: 10 sec 0 usec
> Cancelling scan request

This association looks like the usual aftermath of the SIOCSIWESSID. Comparing to what I see, wpa_supplicant should be moving on to identify the required network configuration, we should receive an RX EAPOL, and a 4WAY handshake should kick off. 

I assume this problem is related to the 64 bit userspace/kernel issue that you're seeing, so wpa_supplicant somehow misidentifies the AP or its configuration.
 
> And the kernel log is:
> 
> [ 7729.202964] eth1: New link status: Connected (0001)
> [ 7738.072382] eth1: New link status: Disconnected (0002)
> [ 7739.238773] eth1: New link status: Connected (0001)
> [ 7748.527988] eth1: New link status: Disconnected (0002)
> [ 7749.683346] eth1: New link status: Connected (0001)
> [ 7758.983565] eth1: New link status: Disconnected (0002)

That looks like the AP kicking us off after we miss the handshake.


Regards,

Dave.

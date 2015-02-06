Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:41368 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbBFPLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 10:11:44 -0500
Message-ID: <54D4D9AE.1050203@lwfinger.net> (sfid-20150206_161148_010523_A5EDC783)
Date: Fri, 06 Feb 2015 09:11:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ken D'Ambrosio <ken@jots.org>
CC: linux-wireless@vger.kernel.org,
	linux-wireless-owner@vger.kernel.org
Subject: Re: rtl8192ee (Thinkpad T440s)
References: <10a90ab7a6c186362f339481b531832f@webmail.jots.org> <54D00FA4.2060907@lwfinger.net> <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org> <54D430E1.6030904@lwfinger.net> <de7f2cdbf497b402a9083ee5748cad3c@webmail.jots.org> <51aca46b667b27dc7530a39e9e85de78@webmail.jots.org>
In-Reply-To: <51aca46b667b27dc7530a39e9e85de78@webmail.jots.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2015 12:11 AM, Ken D'Ambrosio wrote:
> P.S.  I'm sorry, I left this out: I only get the same errors during a manual
> module load.  At boot time, things seem to go somewhat more smoothly -- though
> still fails to connect to anything.  I've attached my dmesg text so you can
> parse it more fully.

That log is useful. You do not need to boot Windows. I have two things for you 
to try.

1. Your wireless is authenticating and associating, but is being kicked off by 
the watchdog timer. Please create a file named /etc/modprobe.d/50-rtl8192ee.conf 
with one line in it that says "disable_watchdog=1". Then reboot to see if that 
helps. Send me the dmesg output starting with

wlan0: send auth to c0:3f:0e:dd:30:98 (try 1/3)
wlan0: authenticated
wlan0: associate with c0:3f:0e:dd:30:98 (try 1/3)
wlan0: RX AssocResp from c0:3f:0e:dd:30:98 (capab=0x421 status=0 aid=3)

2. Reboot with your USB adapter in and send me the whole dmesg output.

Thanks,

Larry


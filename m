Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28342 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZGJO7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 10:59:49 -0400
Subject: Re: Fwd: 4318 misbehaving with bleeding edge kernels
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Celejar <celejar@gmail.com>
In-Reply-To: <200907101131.41781.mb@bu3sch.de>
References: <200907101131.41781.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 10:59:46 -0400
Message-Id: <1247237986.3210.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-10 at 11:31 +0200, Michael Buesch wrote:

> I have a 4318 (rev 02), which has been working fine with b43.
> Recently, with 2.6.31-rc2 kernels from the wireless-testing git repo,
> I've been having trouble.  Sometimes the card simply fails to associate
> after doing 'iwconfig eth0 essid xxxx'.  It doesn't even seem to try;
> i.e., when it does associate, I see log entries like these:

I believe is that the ESSID support in the wext compatibility layer is
seriously broken.  It's not shown originally at all.  Once it's set, it
cannot be changed.

[root@mj proski]# modprobe rt73usb
[root@mj proski]# iwconfig wlan5
wlan5     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated   
          Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
[root@mj proski]# iwconfig wlan5 essid foo
[root@mj proski]# iwconfig wlan5
wlan5     IEEE 802.11bg  ESSID:"foo"  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
[root@mj proski]# iwconfig wlan5 essid bar
[root@mj proski]# iwconfig wlan5
wlan5     IEEE 802.11bg  ESSID:"foo"  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
[root@mj proski]# ifconfig wlan5 up
[root@mj proski]# iwconfig wlan5
wlan5     IEEE 802.11bg  ESSID:"foo"  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=7 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
[root@mj proski]# iwconfig wlan5 essid bar
[root@mj proski]# iwconfig wlan5
wlan5     IEEE 802.11bg  ESSID:"foo"  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=7 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
> and subsequent invocations, when the card is still not working, gives:
> 
> ~# iwlist eth0 scan
> eth0      Interface doesn't support scanning : Device or resource busy

This thread may be related:
http://marc.info/?t=124713997300002&r=1&w=2

-- 
Regards,
Pavel Roskin

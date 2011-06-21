Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:58411 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1FUMvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 08:51:39 -0400
Date: Tue, 21 Jun 2011 20:49:54 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: r8712u driver for the rtl8192su chip.
Message-ID: <20110621124954.GA8462@internetdog.org> (sfid-20110621_145143_001781_1AC0FEC9)
Reply-To: ali@internetdog.org
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
 <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
 <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4DC06BF3.6070208@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

this is more of a quick FYI, regarding Staging's r8712u driver.

On Tue, May 03, 2011 at 03:56:19PM -0500, Larry Finger wrote:
> On 05/03/2011 03:38 PM, Gábor Stefanik wrote:
> >2011/5/3 Larry Finger<Larry.Finger@lwfinger.net>:
> >>On 05/03/2011 03:19 PM, Gábor Stefanik wrote:

> code. The r8712u driver in staging is for the RTL8192SU, and it
> works perfectly well. It just doesn't use mac80211, which is why it
> needs to be replaced.
> 
> Larry

I ran iwconfig on this device in order to put it into Monitor mode, or
even to change its ssid. Both failed because the Set ioctls were not
permitted.
Again, this is more of an FYI, since I don't really use this device.

regards,
ali
PS I did not CC the thread's original list of recipients, because this
tangents somewhat from its main topic.

PPS for the benefit of googlers: the device is the ASUS WL-167G V3
wireless USB adapter.


Additional Info:
~~~~~~~~~~~~~~~
root@hashbang Tue Jun 21 18:24:39 ~$ ifconfig wlan2
wlan2     Link encap:Ethernet  HWaddr 48:5b:39:eb:d2:7c  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@hashbang Tue Jun 21 18:24:57 ~$ iwconfig wlan2
wlan2     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@hashbang Tue Jun 21 18:25:02 ~$ ethtool -i wlan2
driver: r8712u
version: 
firmware-version: 
bus-info: 1-1:1.0
root@hashbang Tue Jun 21 18:25:09 ~$ lsusb|grep :1791
Bus 001 Device 002: ID 0b05:1791 ASUSTek Computer, Inc. 
root@hashbang Tue Jun 21 18:28:48 ~$ iwconfig wlan2 mode Monitor
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan2 ; Invalid argument.
root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
Error for wireless request "Set ESSID" (8B1A) :
    SET failed on device wlan2 ; Operation not permitted.
root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
3.0.0-rc2-wl_m_Sat12jun2011
root@hashbang Tue Jun 21 18:36:57 ~$ 



root@hashbang Tue Jun 21 20:17:28 ~$ iwconfig wlan2
wlan2     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@hashbang Tue Jun 21 20:18:26 ~$ iwconfig wlan2 mode Managed
root@hashbang Tue Jun 21 20:18:37 ~$ iwconfig wlan2 essid "h55m"
channel 11
Error for wireless request "Set ESSID" (8B1A) :
    SET failed on device wlan2 ; Operation not permitted.
root@hashbang Tue Jun 21 20:19:00 ~$ iwconfig wlan2
wlan2     unassociated  Nickname:"rtl_wifi"
          Mode:Managed Access Point: Not-Associated Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@hashbang Tue Jun 21 20:19:10 ~$ 


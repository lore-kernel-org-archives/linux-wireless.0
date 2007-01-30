Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UN6vHM030560	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 18:07:23 -0500
Received: by an-out-0708.google.com with SMTP id c38so14051ana	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 15:06:56 -0800 (PST)
Date: Tue, 30 Jan 2007 17:36:21 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: Getting dscape running
In-reply-to: <1170195897.11455.6.camel@dv>
Sender: wireless-bounces@tuxdriver.com
To: Pavel Roskin <proski@gnu.org>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301436m2bdb903cpb2089a1c395b489c@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <1170195897.11455.6.camel@dv>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

Here's the same rt2570 device using the ifconfig commands. I was
trying to get NetworkManager running on it in case it was doing
something that I wasn't doing manually. Some is not quite right with
the WEP exchange.

jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  IEEE 802.11g  Frequency:2.412 GHz
          RTS thr:off   Fragment thr=2346 B

wlan0     IEEE 802.11g  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          RTS thr:off   Fragment thr=2346 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0 channel 1
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
key F491B8B905
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
essid Smirl
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo iwconfig wlan0
ap 00:11:95:18:15:31
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$ sudo dhclient wlan0
Internet Systems Consortium DHCP Client V3.0.4
Copyright 2004-2006 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/00:15:e9:2d:76:57
Sending on   LPF/wlan0/00:15:e9:2d:76:57
Sending on   Socket/fallback
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 14
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 19
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 20
No DHCPOFFERS received.
No working leases in persistent database - sleeping.
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$

I'm unable to connect to it using WEP. The same device works on the Intel stack.

wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: RX WEP frame with unknown keyidx 0 (A1=01:00:5e:00:00:38
A2=00:11:95:18:15:31 A3=00:07:e9:55:4b:7e)
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: RX WEP frame with unknown keyidx 0 (A1=01:00:5e:00:00:38
A2=00:11:95:18:15:31 A3=00:07:e9:55:4b:7e)
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
wmaster0: TX to low-level driver (len=26) FC=0x00a0 DUR=0x013a
A1=00:11:95:18:15:31 A2=00:15:e9:2d:76:57 A3=00:11:95:18:15:31
jonsmirl@jonsmirl:/extra/wireless-dev/net/d80211$




-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

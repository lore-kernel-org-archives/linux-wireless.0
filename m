Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:39560 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752131Ab2BEOwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 09:52:23 -0500
Message-ID: <4F2E9651.5020601@kingswood-consulting.co.uk> (sfid-20120205_155228_074027_1A14B91D)
Date: Sun, 05 Feb 2012 14:46:41 +0000
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org> <4F2E6C34.6060903@broadcom.com>
In-Reply-To: <4F2E6C34.6060903@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/12 11:47, Arend van Spriel wrote:
> On 02/04/2012 06:02 PM, Frank A. Kingswood wrote:
>    
>> On a new (Samsung 305U1A) laptop with BRCM4313 wireless I have not been
>> able to use the wireless at all, although occasionally a flicker of life
>> can be seen in it.
>>
>> "iwconfig scan" usually fails to report more than one access point.
>> Disabling the local AP makes it show up a different one, suggesting it
>> is actually able to see it but somewhere fails to pass the data along.
>>      
> Could you sent me the output of 'iwconfig scan' or better 'iw scan'?
> What is the SSID of the 'local AP'?
>    
Thanks for picking this up.

Full current dmesg is at http://pastebin.com/6yV0AgA1 which does not 
have a kernel panic but has brcmsmac debugging enabled.
The syslog has some NM messages:

Feb  5 22:38:21 ceres NetworkManager[1372]: <warn> Activation 
(wlan0/wireless): association took too long.
Feb  5 22:38:21 ceres NetworkManager[1372]: <info> (wlan0): device state 
change: config -> need-auth (reason 'none') [50 60 0]
Feb  5 22:38:21 ceres NetworkManager[1372]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Feb  5 22:38:21 ceres NetworkManager[1372]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Feb  5 22:38:21 ceres NetworkManager[1372]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Feb  5 22:38:32 ceres dbus[1351]: [system] Activating service 
name='org.freedesktop.PackageKit' (using servicehelper)
Feb  5 22:38:32 ceres dbus[1351]: [system] Successfully activated 
service 'org.freedesktop.PackageKit'
Feb  5 22:40:27 ceres NetworkManager[1372]: <warn> No agents were 
available for this request.
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> (wlan0): device state 
change: need-auth -> failed (reason 'no-secrets') [60 120 7]
Feb  5 22:40:27 ceres NetworkManager[1372]: <warn> Activation (wlan0) 
failed for access point (002257217de0)
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> Marking connection 
'002257217de0 - Home' invalid.
Feb  5 22:40:27 ceres NetworkManager[1372]: <warn> Activation (wlan0) 
failed.
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> (wlan0): device state 
change: failed -> disconnected (reason 'none') [120 30 0]
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> (wlan0): deactivating 
device (reason 'none') [0]
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> Policy set 'Wired 
connection 1' (eth0) as default for IPv4 routing and DNS.
Feb  5 22:40:27 ceres NetworkManager[1372]: <info> Policy set 'Wired 
connection 1' (eth0) as default for IPv4 routing and DNS.

On the Samsung the scan only finds my local AP.  With that AP off 
yesterday it found a neighbour's AP.
Another laptop finds 13 APs, the next one down is at -88dBm.

$ iw dev wlan0 scan

BSS 00:22:57:21:7d:e0 (on wlan0)
     TSF: 73342264677 usec (0d, 20:22:22)
     freq: 2462
     beacon interval: 333
     capability: ESS Privacy ShortSlotTime (0x0411)
     signal: -47.00 dBm
     last seen: 316 ms ago
     SSID: 002257217de0
     Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
     DS Parameter set: channel 11
     Extended supported rates: 6.0 12.0 24.0 48.0
     Country: GB    Environment: Indoor/Outdoor
         Channels [1 - 11] @ 16 dBm
     TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
     ERP: Barker_Preamble_Mode
     HT capabilities:
         Capabilities: 0x11ee
             HT20/HT40
             SM Power Save disabled
             RX HT20 SGI
             RX HT40 SGI
             TX STBC
             RX STBC 1-stream
             Max AMSDU length: 3839 bytes
             DSSS/CCK HT40
         Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
         Minimum RX AMPDU time spacing: 4 usec (0x05)
         HT RX MCS rate indexes supported: 0-15, 32
         HT TX MCS rate indexes are undefined
     HT operation:
          * primary channel: 11
          * secondary channel offset: below
          * STA channel width: any
          * RIFS: 0
          * HT protection: 20 MHz
          * non-GF present: 1
          * OBSS non-GF present: 0
          * dual beacon: 0
          * dual CTS protection: 0
          * STBC beacon: 0
          * L-SIG TXOP Prot: 0
          * PCO active: 0
          * PCO phase: 0
     Extended capabilities: HT Information Exchange Supported
     RSN:     * Version: 1
          * Group cipher: CCMP
          * Pairwise ciphers: CCMP
          * Authentication suites: PSK
          * Capabilities: PreAuth (0x0001)
     WMM:     * Parameter version 1
          * BE: CW 15-1023, AIFSN 3
          * BK: CW 15-1023, AIFSN 7
          * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
          * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
>> Fiddling with NetworkManager produces this kernel panic:
>>      
> What does 'Fiddling with NetworkManager' mean exactly?
>    
Hard to say :-)
I was trying to get NM to first find and then connect to the AP. This is 
not really reproducable, sorry, it took perhaps a dozen attempts.

Frank

-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-7545-209 100



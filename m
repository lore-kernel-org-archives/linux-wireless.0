Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:64512 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZJTPmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:42:43 -0400
Received: by fg-out-1718.google.com with SMTP id 16so2823353fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 08:42:46 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: ath9k-devel@lists.ath9k.org
Subject: Test for N-mode from userspace?
Date: Tue, 20 Oct 2009 21:12:30 +0530
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910202112.30660.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is it possible to check for whether the N-mode is alive on the laptop and not 
blocked by the OEM (HP)?

I don't have access to an N-mode AP to try to associate and check; but I'm 
planning to buy a new AP/router - so, might as well go for one having N-mode 
now that it's standardised.

The device I have is AR9285 - which does have N mode support as per the 
following iwconfig output:

kunal@plutonium:~$ iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"Kunal-home"
          Mode:Managed  Frequency:2.432 GHz  Access Point: 00:1A:70:EE:8D:62
          Bit Rate=5.5 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=70/70  Signal level=-35 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


lspci -v output:
08:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)                                                  
        Subsystem: Hewlett-Packard Company Device 3040
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at d1200000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0Enable-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [160] Device Serial Number 12-14-24-ff-ff-17-15-00
        Capabilities: [170] Power Budgeting <?>
        Kernel driver in use: ath9k
        Kernel modules: ath9k


iw list output:
Wiphy phy0                                               
        Band 1:                                          
                HT capabilities: 0x104e                  
                        * 20/40 MHz operation            
                        * SM PS disabled                 
                        * 40 MHz short GI                
                        * max A-MSDU len 3839            
                        * DSSS/CCK 40 MHz                
                HT A-MPDU factor: 0x0003 (65535 bytes)   
                HT A-MPDU density: 0x0006 (8 usec)       
                HT MCS set: ff 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00
                HT TX/RX MCS rate indexes supported:                       
                        MCS index 0                                        
                        MCS index 1                                        
                        MCS index 2                                        
                        MCS index 3                                        
                        MCS index 4                                        
                        MCS index 5                                        
                        MCS index 6                                        
                        MCS index 7                                        
                Frequencies:                                               
                        * 2412 MHz [1] (20.0 dBm)                          
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm) (passive scanning)
                        * 2472 MHz [13] (20.0 dBm) (passive scanning)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point

Thanks,
Kunal

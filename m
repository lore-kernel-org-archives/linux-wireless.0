Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934313Ab0KQJYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 04:24:03 -0500
From: "Zheng, Jiajia" <jiajia.zheng@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Date: Wed, 17 Nov 2010 17:23:00 +0800
Subject: RE: experimental iwlwifi 1000 uCode available
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF27D53BD27C@shsmsx502.ccr.corp.intel.com>
References: <1289950075.476.2.camel@wwguy-ubuntu>
In-Reply-To: <1289950075.476.2.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We ran BAT for the new experimental ucode with 1000 card. The testing result is good. 
One cases failed because of an old bug 2250 that 5000 series failed to connect to AP in channel 8 or 9 with channel width 40 MHZ on N_2.4g band.

Testing Environment
=====================================================================================================
iwlwifi-2.6	    :  commit b2cd3777a63857504a8fe28927b74f5c1b303fe4
                    :  (Mon Nov 15 14:17:33 2010)
-----------------------------------------------------------------------------------------------------
AP		    :  Cisco 1252
=====================================================================================================
Intel WiFi Link |Platform    |	OS             |		Ucode		        	
-----------------------------------------------------------------------------------------------------
1000		|PineTrail   |Fedora 10(32bit) |iwlwifi-1000-exp.ucode experimental version 39.31.5.1
=====================================================================================================

Summary Test Report
=========================================================
Intel WiFi Link |  Total  |  Pass  |  Fail  | Pass rate
---------------------------------------------------------
1000		|   34    |   33   |    1   |    97%
=========================================================

Bug status
=========================================================
New bugs     : 		
---------------------------------------------------------
Old bugs     :  Bug 2250 - failed to connect to AP in channel 8 or 9 with channel width 40 MHZ on N_2.4g band
                http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2250             
---------------------------------------------------------
Verified bugs:  
=========================================================

Detail Test Report:

====================================================================
tpname         Short Description                            1000     
--------------------------------------------------------------------
Build          Build Kernel and Reboot Kernel               PASS     
BSS1_b         Broadcast AP                                 PASS    
BSSDATA1_b     BSS unicast                                  PASS     
WEPBSS1_b      BSS Open WEP40                               PASS   
fragbss1_b     Fragementation Basic                         PASS     
wpa112200_b    WPA-WPA-PSK-TKIP-TKIP                        PASS     
BSS1_n2        Broadcast AP                                 PASS     
BSSDATA1_n2    BSS unicast                                  PASS     
BSS11NCHAN1_n2 BSS fat channel                              [FAIL]   
WEPBSS2_n2     BSS Open WEP104                              PASS     
fragbss1_n2    Fragementation Basic                         PASS    
LOAD12_n2      Disable 11n functionality                    PASS     
wpa122210_n2   WPA-WPA-EAP-TKIP-TKIP-TLS                    PASS    
wpa211100_n2   WPA2-WPA-PSK-CCMP-CCMP                       PASS     
wpa221121_n2   WPA2-WPA-EAP-CCMP-CCMP-PEAP-MD5              PASS   
BSS1_g         Broadcast AP                                 PASS     
BSS2_g         Hidden AP                                    PASS     
BSSDATA1_g     BSS unicast                                  PASS     
BSSCHAN1_g     BSS all channels                             PASS    
IBSS1_g        IBSS Unicast                                 PASS    
IBSSCHAN1_g    IBSS all channel                             PASS    
WEPIBSS1_g     IBSS WEP40                                   PASS   
WEPIBSS2_g     IBSS WEP104                                  PASS    
fragbss1_g     Fragementation Basic                         PASS     
fragibss1_g    Fragmentation IBSS basic                     PASS     
wpa221121_g    WPA2-WPA-EAP-CCMP-CCMP-PEAP-MD5              PASS    
wpa122232_g    WPA-WPA-EAP-TKIP-TKIP-TTLS-MSCHAPV2          PASS    
wpa040300_g    NONE-WEP104                                  PASS   
wpa211100_g    WPA2-WPA-PSK-CCMP-CCMP                       PASS    
wpa040600_g    Shared-WEP40                                 PASS    
wpa030421_g    IEEE8021X-WEP40-PEAP-MD5                     PASS    
LOAD8_g        Software scan                                PASS   
LOAD10_2_g     WPA2 PSK CCMP (SW)                           PASS   
MODE4_g        Moving from monitor mode -> ad-hoc mode      PASS     

Thanks,
jiajia
Guy, Wey-Yi wrote:
> Hi,
> 
> Experimental version 39.31.5.1 of uCode for Intel(r) 1000 Series Wi-Fi
> Adapters is now available for download from
> http://www.intellinuxwireless.org/?n=experimental
> 
> 
> Experimental uCode is the WiFi uCode released by the Intel uCode team
> with the latest bug fixes to address issues being reported by external
> parties. The Experimental uCode has not gone through the full
> regression test procedures, and the goal is to address the issue(s)
> that can't be easily reproduced within the internal testing
> environment. 
> 
> Wey
> 
> --



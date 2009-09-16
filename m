Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46820 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZIPVAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 17:00:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/2] b43: Add lpphy_clear_tx_power_offsets to improve TX Power handling
Date: Wed, 16 Sep 2009 23:00:03 +0200
Cc: Thomas Ilnseher <illth@gmx.de>,
	=?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1253129879.2989.48.camel@note> <69e28c910909161240p7739edebi653b5d402a792856@mail.gmail.com> <1253132275.2989.75.camel@note>
In-Reply-To: <1253132275.2989.75.camel@note>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909162300.07342.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 September 2009 22:17:55 Thomas Ilnseher wrote:
> Am Mittwoch, den 16.09.2009, 21:40 +0200 schrieb Gábor Stefanik:
> > You are essentially implementing dead code at this point - this will
> > only ever be called if hardware-accelerated TX power control is
> > enabled - and HW TX power control is unsupported, even for G-PHYs.
> Then the question remains, why this brings my device to 54 MBit/s ?
> 
> I did double check again with the old driver:
> 
> wlan0     IEEE 802.11bg  ESSID:"tommy"  
>           Mode:Managed  Frequency:2.412 GHz  Access Point:    
>           Bit Rate=9 Mb/s   Tx-Power=20 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=70/70  Signal level=5 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> Patched driver:
> 
> wlan0     IEEE 802.11bg  ESSID:"tommy"  
>           Mode:Managed  Frequency:2.412 GHz  Access Point: XXX 
>           Bit Rate=54 Mb/s   Tx-Power=20 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=70/70  Signal level=10 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

The iwconfig output doesn't tell you anything about the actual net TX rate.
Please benchmark it with iperf.

-- 
Greetings, Michael.

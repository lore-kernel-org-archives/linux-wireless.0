Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:52651 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757723Ab0LBOYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 09:24:52 -0500
Message-ID: <4CF7AC31.2020206@gmx.net>
Date: Thu, 02 Dec 2010 15:24:49 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: EAP Identity Response dropped on 5GHz
References: <4CF66912.8050302@gmx.net>
In-Reply-To: <4CF66912.8050302@gmx.net>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wolfgang Breyha wrote, on 01.12.2010 16:26:
> In the same moments I see
>> Dec  1 15:53:18 hpwb kernel: [15439.900071] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)
>> Dec  1 15:53:19 hpwb kernel: [15440.894484] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)
>> Dec  1 15:53:20 hpwb kernel: [15441.893895] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)

These are IPv6 discovery packets of ethertype 0x86DD. So that's correct.

But introducing a usleep(100000) in
wpa_supplicant/src/eap_peer/eap.c:136, or in other words....
> wpa_supplicant logs:
> 
>> 1291215721.998646: Process pending EAPOL frame that was received just before association notification
>> 1291215721.998677: RX EAPOL from 00:26:cb:xx:xx:xx
>> 1291215721.998713: Setting authentication timeout: 70 sec 0 usec
>> 1291215721.998747: EAPOL: Received EAP-Packet frame
>> 1291215721.998778: EAPOL: SUPP_PAE entering state RESTART
>> 1291215721.998806: EAP: EAP entering state INITIALIZE
............ HERE ................
>> 1291215721.998835: EAP: EAP entering state IDLE
>> 1291215721.998865: EAPOL: SUPP_PAE entering state AUTHENTICATING
>> 1291215721.998895: EAPOL: SUPP_BE entering state REQUEST
>> 1291215721.998924: EAPOL: getSuppRsp
>> 1291215721.998952: EAP: EAP entering state RECEIVED
>> 1291215721.998998: EAP: Received EAP-Request id=1 method=1 vendor=0 vendorMethod=0
>> 1291215721.999034: EAP: EAP entering state IDENTITY
>> 1291215721.999065: CTRL-EVENT-EAP-STARTED EAP authentication started
>> 1291215721.999087: EAP: EAP-Request Identity data - hexdump_ascii(len=40):
>> 1291215721.999159: EAP: using real identity - hexdump_ascii(len=15):
>> 1291215721.999198: EAP: EAP entering state SEND_RESPONSE
>> 1291215721.999220: EAP: EAP entering state IDLE
>> 1291215721.999267: EAPOL: SUPP_BE entering state RESPONSE
>> 1291215721.999290: EAPOL: txSuppRsp
>> 1291215721.999318: TX EAPOL: dst=00:26:cb:xx:xx:xx
.... lets path this packet through to the AP over air.

I haven't found the source of this race condition which causes this. The
reason why it only happens on 5GHz channels is unknown as well.

With kind regards,
Wolfgang Breyha
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria


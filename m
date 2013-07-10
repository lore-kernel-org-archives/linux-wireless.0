Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36223 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GJJXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 05:23:07 -0400
Message-ID: <1373448177.8385.22.camel@cumari.coelho.fi> (sfid-20130710_112311_330813_A9CB1CA3)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
From: Luciano Coelho <coelho@ti.com>
To: =?ISO-8859-1?Q?Jos=E9?= Miguel =?ISO-8859-1?Q?Gon=E7alves?=
	<jose.goncalves@inov.pt>
CC: Arik Nemtsov <arik@wizery.com>, <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jul 2013 12:22:57 +0300
In-Reply-To: <51DCA3EF.8090900@inov.pt>
References: <51DB0ACC.7050800@inov.pt>
	 <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
	 <51DB4195.8090103@inov.pt>
	 <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
	 <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>
	 <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>
	 <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>
	 <51DC0E7C.9080306@inov.pt>
	 <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>
	 <51DCA3EF.8090900@inov.pt>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-10 at 00:59 +0100, José Miguel Gonçalves wrote:
> Hi Arik,
> 
> On 09-07-2013 20:10, Arik Nemtsov wrote:
> > On Tue, Jul 9, 2013 at 4:22 PM, José Miguel Gonçalves
> > <jose.goncalves@inov.pt> wrote:
> >> http://pastebin.com/XmEzqjHs
> >>
> >> The dmesg output with debug mask set to 0x63c20:
> >>
> >> http://pastebin.com/zGE0Gfp8
> >>
> >> Note that with debug activated I did not see the driver's "Beacon loss
> >> detected" messages.
> > You have this line in the log:
> > [   72.435000] wlan0: deauthenticated from 88:43:e1:57:79:c0 (Reason: 23)
> >
> > This means:
> > Association request rejected because the information in the Power
> > Capability element is
> > unacceptable

Actually, I think this is "IEEE 802.1X authentication failed".  This is
the reason_code in the deauth frame.  If it were the status_code in the
association response, mac80211 would print "denied association instead".


> > In other words the AP is disconnecting you since your Tx power is
> > inadequate (probably too high?). I'd try to limit it using iw, or just
> > set a different regdomain where its limited.
> > Also I'd try with a different AP.
> 
> I think that return code is a bogus caused by the driver debug code, 
> because when I remove all the debug I see a different behaviour, i.e., 
> after brief associating with the AP, I see 3 driver messages;

I think this is happening here because of timing.  I suspect that the
signal is bad so there are probably lots of retransmissions and with
debugging, things can become so slow that the authentication times out.
IIRC EAP has very strict timing requirements.


> wlcore: Beacon loss detected. roles:0xff
> 
> and then receive from wpa_supplicant;
> 
> wlan0: CTRL-EVENT-DISCONNECTED bssid=88:43:e1:57:79:c0 reason=4 
> locally_generated=1
> wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="A. Guidance" 
> auth_failures=1 duration=10
> 
> and I've not make any mistake on the pre-shared key.
> 
> Also I've used this AP for tests of different wireless adapters with 
> success. Inclusive have use it with the same hardware platform and same 
> kernel and sysapps (ifconfig, iw, wpa_supplicant, etc...) and a TP-Link 
> TL-WN722N Wi-Fi adapter (ath9k_htc driver) and had no problems in 
> associating that adapter.

Still, there may be some interoperability issue with this AP and the
wl127x chip. ;)

I would try with another AP, just to see how things go.  Also, I'd try
with an open connection to rule out problems with authentication.


> Can my problems be related with an inadequate NVS file? I've generated 
> it with the calibrate tool from ti-utils and the INI file TQS_D_1.7.ini 
> with the command "calibrator plt calibrate". Is this the correct INI for 
> my module (Jorjin's WG7350 - wl1273 based)?

Yes, the problem can be because of a bad NVS file.  Try with the
"default" NVS file that is provided in linux-firmware.git.  That one
won't be optimal, but should work okay.

I'm not sure which FEM Jorjin's module use.  Can you ask them?

I found this on github (Dick Chiang appears to work for Jorjin):
https://github.com/dickychiang/compat-wireless-r5/blob/master/jorjin/ini_files/TQS_D_1.7_WG7350_NLCP.ini

DISCLAIMER: I have no clue whether this is the correct INI file or not
and I'm not claiming it's associated with TI in any way, so use it at
your own risk.

> Any ideas also why I can not get a complete APs list with the command 
> "iw wlan0 scan"? No one as seen this behaviour before?

Many people have seen this kind of behavior and it usually indicates bad
RF performance. ;)

--
Cheers,
Luca.


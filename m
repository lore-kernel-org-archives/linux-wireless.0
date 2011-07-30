Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:12359 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1G3T7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 15:59:34 -0400
Date: Sat, 30 Jul 2011 20:59:31 +0100
From: Laurence Darby <ldarby@tuffmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: I'm no longer confused and angry
Message-Id: <20110730205931.3cc8a004.ldarby@tuffmail.com> (sfid-20110730_215942_375862_E44F83EA)
In-Reply-To: <4E344F90.4040003@lwfinger.net>
References: <20110730181433.50bd32db.ldarby@tuffmail.com>
	<4E3442ED.90206@lwfinger.net>
	<20110730191422.3b2931ba.ldarby@tuffmail.com>
	<4E344F90.4040003@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sat__30_Jul_2011_20_59_31_+0100_Cl+IX.uIEEd_Xnx7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Sat__30_Jul_2011_20_59_31_+0100_Cl+IX.uIEEd_Xnx7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Larry Finger wrote:

> On 07/30/2011 01:14 PM, Laurence Darby wrote:
> >
> > I have now enabled rfkill.  The hostapd error message is now:
> >
> > Hardware does not support configured mode
> > wlan0: IEEE 802.11 Hardware does not support configured mode (2)
> > Could not select hw_mode and channel. (-2)
> > wlan0: Unable to setup interface.
> > rmdir[ctrl_interface]: No such file or directory
> 
> Please post your hostapd.conf. I don't have any ath9k hardware and
> cannot check that it works with, but other wireless devices work with
> 
> interface=wlan0
> driver=nl80211
> hw_mode=g
> channel=1
> ssid=test2
> #wpa=2
> #wpa_key_mgmt=WPA-PSK
> #wpa_pairwise=CCMP
> #wpa_passphrase="deleted"
> 
> Larry

Ah, thanks, that does work and my other devices can see it now!

I was using the unmodified hostapd.conf, which has hw_mode=a, but
this device only supports modes b,g & n.  That is what the error is
talking about, not the Master/Ad-Hoc mode which I thought it was trying
to configure (which it is as well, actually).  Would be good if the
error message included the mode it's trying to configure, instead of
"(2)", that would definitely have stopped me getting confused here.

Some more reasons I didn't think this supported AP mode:
http://linuxwireless.org/en/users/Drivers has 'no' for AP support for
the ath9k_htc, that conflicts with the driver page, and

 # iwconfig wlan0 mode Managed

works, while

 # iwconfig wlan0 mode Master
always gives:
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

With hostapd running, iwconfig says:

wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=20
dBm Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          
and reverts to Mode:Managed if I stop hostapd, so I'm not sure why
iwconfig can't change it...

Ok, http://linuxwireless.org/en/users/Documentation/hostapd does say
that hw_mode needs to be set correctly, but it wasn't obvious enough
that's what the problem was.  The error and solution could be added to
where ./hostapd gets started.  Also, it refers to a
hostapd-minimal.conf, I couldn't see that anywhere, that's why I used
the default hostapd.conf.

Laurence

--Multipart=_Sat__30_Jul_2011_20_59_31_+0100_Cl+IX.uIEEd_Xnx7
Content-Type: application/octet-stream;
 name="hostapd.conf"
Content-Disposition: attachment;
 filename="hostapd.conf"
Content-Transfer-Encoding: base64

aW50ZXJmYWNlPXdsYW4wCmRyaXZlcj1ubDgwMjExCmh3X21vZGU9YgpjaGFubmVsPTEKc3NpZD10
ZXN0Mgo=

--Multipart=_Sat__30_Jul_2011_20_59_31_+0100_Cl+IX.uIEEd_Xnx7--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62387 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZIOEEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 00:04:46 -0400
Received: by fxm17 with SMTP id 17so1294598fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 21:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3b0e19890909141951uf8b80c0ta3619045b54efff3@mail.gmail.com>
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>
	 <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>
	 <4AAE53C8.1060100@lwfinger.net>
	 <3b0e19890909140905g4c6bfef3t38cd94a205d26f8@mail.gmail.com>
	 <4AAE7446.3080407@lwfinger.net>
	 <3b0e19890909141056l4a01b8f9w9887af5d6219c3ff@mail.gmail.com>
	 <3ace41890909141351o261f7013u7d050a2f8a41dcb3@mail.gmail.com>
	 <3b0e19890909141434t758a9b3dk2799623dfb19c6a6@mail.gmail.com>
	 <3ace41890909141824i2f274a91rc19e50eac254e950@mail.gmail.com>
	 <3b0e19890909141951uf8b80c0ta3619045b54efff3@mail.gmail.com>
Date: Tue, 15 Sep 2009 05:04:48 +0100
Message-ID: <3ace41890909142104u25ec85b9s4b1999799494fc1d@mail.gmail.com>
Subject: Re: RTL8187B wireless driver issue
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Vignette consultant <vignette75@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2009 at 3:51 AM, Vignette consultant
<vignette75@gmail.com> wrote:
>  1 how can i check if wpa_supplicant is running or not?

(sigh...) well, have a look at 'ps -lax' , e.g.
ps -lax | grep wpa
ps -lax | grep -i net
ps -lax | grep dh

and see if there is anything you don't know the nature of... (and look
it up on the web!).

>  3 are you saying "to use different driver"?

yes, different version/release of the driver

>
>  2 where do i need put essid, so udev can use it?

YMMV, on my system (fedora) these are the system locations for wlan2.

/etc/wpa_supplicant/wpa_supplicant.conf

/etc/sysconfig/networking/devices/ifcfg-wlan2
/etc/sysconfig/networking/devices/keys-wlan2
/etc/sysconfig/networking/profiles/default/ifcfg-wlan2
/etc/sysconfig/networking/profiles/default/keys-wlan2

essid is in /etc/wpa_supplicant/wpa_supplicant.conf and ifcfg-*, and
the key is in keys-* and also in
/etc/wpa_supplicant/wpa_supplicant.conf . Also if you use
NetworkManager, it can take credentials from the gnome-keyring-manager
as well.

In the normal course of event, when one if up a network interface,
udev tells either the network service to configure the interface or
talk to NetworkManger via dbus to do it. both network service and
NetworkManager tells wpa_supplicant to start scanning for known APs or
open APs and try to authenticate.

If you are not aware of what wpa_supplicant might be doing, it could
unset whatever credentials you try to set as it scans and look for
known or open APs. You should try to use the NetworkManager applet or
Wireless assistant to set essid and credentials, rather than by hand
on the command line.

Hmm, your Vista screenshot says the AP is unsecure (and the signal
strength is poor), is that the case?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbbJ1Ouy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 10:50:54 -0400
Message-ID: <1446043853.24757.51.camel@redhat.com> (sfid-20151028_155057_843382_67EE3315)
Subject: Re: mwifiex problem: incompatible network settings
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 28 Oct 2015 09:50:53 -0500
In-Reply-To: <87a8r4ugth.fsf@free.fr>
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	 <87twpd8fk4.fsf@free.fr> <1445972115005.99995@marvell.com>
	 <87a8r4ugth.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-27 at 22:44 +0100, Julien Cubizolles wrote:
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Julien,
> >
> >>Yes, I'm using NetworkManager, version 1.0.4-ubuntu5, and I'm guessing
> >>it's using wpa_supplicant. I deleted the configuration for this network
> >>and created it again. The network is configured for WPA in
> >>NetworkManager but I still get the same error message.
> >
> > Looks like driver has received encryption mode as TKIP, but didn't
> > receive WPA ie. Hence the configuration didn't match with AP. Could
> > you share wpa_supplicant configuration file if possible? 
> 
> Here is /etc/dbus-1/system.d/wpa_supplicant.conf, is this the one you
> need ?

He actually meant the wpa_supplicant configuration file, not the
supplicant's dbus config file.  But when driven by NetworkManager, there
is no supplicant configuration file.

Instead, you can find out what config NM is pushing to the supplicant by
checking the NetworkManager logs, where NM will log lines like:

NetworkManager[1163]: <info>  (wlp4s0): Activation: (wifi) connection
'homewifi' has security, and secrets exist.  No new secrets needed.
NetworkManager[1163]: <info>  Config: added 'ssid' value 'homewifi'
NetworkManager[1163]: <info>  Config: added 'scan_ssid' value '1'
NetworkManager[1163]: <info>  Config: added 'key_mgmt' value 'WPA-PSK'
NetworkManager[1163]: <info>  Config: added 'psk' value '<omitted>'
NetworkManager[1163]: <info>  Config: added 'proto' value 'WPA RSN'
NetworkManager[1163]: <info>  Config: set interface ap_scan to 1

That is almost exactly what would be in the wpa_supplicant config file.
Can you grab this info from your machine for Julien?

Dan

> --8<---------------cut here---------------start------------->8---
> <!DOCTYPE busconfig PUBLIC
>  "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
>  "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
> <busconfig>
>         <policy user="root">
>                 <allow own="fi.epitest.hostap.WPASupplicant"/>
> 
>                 <allow send_destination="fi.epitest.hostap.WPASupplicant"/>
>                 <allow send_interface="fi.epitest.hostap.WPASupplicant"/>
> 
>                 <allow own="fi.w1.wpa_supplicant1"/>
> 
>                 <allow send_destination="fi.w1.wpa_supplicant1"/>
>                 <allow send_interface="fi.w1.wpa_supplicant1"/>
>                 <allow receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
>         </policy>
>         <policy group="netdev">
>                 <allow send_destination="fi.epitest.hostap.WPASupplicant"/>
>                 <allow send_interface="fi.epitest.hostap.WPASupplicant"/>
> 
>                 <allow send_destination="fi.w1.wpa_supplicant1"/>
>                 <allow send_interface="fi.w1.wpa_supplicant1"/>
>                 <allow receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
>         </policy>
>         <policy context="default">
>                 <deny own="fi.epitest.hostap.WPASupplicant"/>
>                 <deny send_destination="fi.epitest.hostap.WPASupplicant"/>
>                 <deny send_interface="fi.epitest.hostap.WPASupplicant"/>
> 
>                 <deny own="fi.w1.wpa_supplicant1"/>
>                 <deny send_destination="fi.w1.wpa_supplicant1"/>
>                 <deny send_interface="fi.w1.wpa_supplicant1"/>
>                 <deny receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
>         </policy>
> </busconfig>
> 
> --8<---------------cut here---------------end--------------->8---
> 
> > Also, check if "sme->ie" is received in mwifiex_cfg80211_assoc()
> > routine.
> 
> Is that what the following debugging is for ? Or should I do something
> else ?
> 
> > Enable driver debug for the test using "echo 0xffffffff >
> > /sys/kernel/debug/mwifiex/mlan0/debug_mask" and share dmesg logs.
> 
> Please find them attached.
> 
> Regards,
> 
> Julien.
> 



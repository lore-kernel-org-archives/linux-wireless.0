Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbbJZQKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 12:10:15 -0400
Message-ID: <1445875814.31216.18.camel@redhat.com> (sfid-20151026_171020_052679_6AB16066)
Subject: Re: mwifiex problem: incompatible network settings
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Oct 2015 11:10:14 -0500
In-Reply-To: <87wpu9632c.fsf@free.fr>
References: <87wpu9632c.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-26 at 16:51 +0100, Julien Cubizolles wrote:
> I can't connect anymore to my home wifi since upgrading my machine from
> Ubuntu 15.04 to Ubuntuy 15.10. I was previously running kernel 4.3.0-rc2
> from kernel.org without any problem. After the upgrade, and with the
> same kernel, I couldn't connect anymore. I built 4.3.0-rc7, and the
> problem remains. However, I can connect to the wifi access point from my
> Android phone.
> 
> Here are the relevant lines from syslog. Let me know if you need more
> information.

The AP uses WPA, but the driver has been told that WPA is disabled.  Are
you using wpa_supplicant (or NetworkManager, or something else?) to
control the WiFi, and if so what version is it?

Dan

> --8<---------------cut here---------------start------------->8---
> Oct 26 16:11:38 touco wpa_supplicant[734]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='southcentral' freq=2462 MHz)
> Oct 26 16:11:38 touco wpa_supplicant[734]: wlx6045bdf646b4: CTRL-EVENT-ASSOC-REJECT status_code=1
> Oct 26 16:11:38 touco kernel: [   66.745281] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
> Oct 26 16:11:38 touco kernel: [   66.745289] usb 1-3: info: mwifiex_is_network_compatible: failed: wpa_ie=0xdd wpa2_ie=0x0 WEP=d	WPA=d WPA2=d EncMode=0xfac02 privacy=0x1
> Oct 26 16:11:38 touco kernel: [   66.745291] usb 1-3: Incompatible network settings
> Oct 26 16:11:38 touco kernel: [   66.745294] usb 1-3: info: association to bssid f4:ca:e5:ef:be:18 failed
> --8<---------------cut here---------------end--------------->8---
> 
> 
> The machine is a Microsoft Surface Pro. I've been having a lot of
> problems getting the wifi to work but never this particular one, and
> they were all fixed in 4.3.0-rc2.
> 
> Julien.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



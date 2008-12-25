Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([69.93.164.18]:39941 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598AbYLYUA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2008 15:00:27 -0500
Received: from 75-92-136-219.sea.clearwire-dns.net ([75.92.136.219]:59423 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LFsdO-0007MD-As
	for linux-wireless@vger.kernel.org; Thu, 25 Dec 2008 10:00:26 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 4965AGN Not Associating
Date: Thu, 25 Dec 2008 08:00:26 -0800
References: <200812241158.29493.Info@delphi-real-estate.com> <1230166611.2688.3.camel@debian.sh.intel.com>
In-Reply-To: <1230166611.2688.3.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812250800.26394.Info@delphi-real-estate.com> (sfid-20081225_210046_735327_5A057F9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wednesday 24 December 2008 16:56:51 Zhu Yi wrote:
> CONFIG_SND_HWDEP?

Actually, it turned out to need snd-emu10k1 enabled, amazingly.  Then it compiled fine, but crashed on boot when it was time to pivot to /dev/sda1.  Found the problem was the disk controller driver needed to be compiled in, not a module.

So I now have kernel 2.6.27-11.22 running and the nice little blue wifi light which I'd never had before, and it twinkles, apparently with network access.  iwconfig, and indeed it is associated as it should be, showing 54Mb/s. No need for the external driver compile.  

All right, so the kernel iwl modules are working with this kernel, good enough for me... although iwconfig shows, "Encryption key:AM32-52G0-50D6-130B-6AF0-201D-9450-H978 [2]   Security mode:open".  

'Open'?  Homey don't think so.  The AP us set to WPA AES.  Why would it say it's open?

Also, I want to switch to 802.11a for streaming media, so I'm not polluting everyone else's bandwidth.  How do I set this card to 'a' or 'n'?  Is there any way to set it to dual-band for the new routers which send normal traffic on 'g' and stream on 'a'?  How do I set it to WPA2?  

IOW, how do I control this card?  Instructions are nowhere to be found.

Currently my /etc/network/interfaces file is set thus and works (Network Manager is uninstalled and I don't trust it):
iface wlan0 inet static
pre-up /sbin/iwconfig wlan0 txpower 5
pre-up ip link set wlan0 up
address 192.168.1.1
netmask 255.255.255.0
gateway 192.168.1.5
wireless-essid Hex
wpa-scan-ssid 0
wpa-ap-scan 1
wpa-ssid Hex
wpa-psk Freeasinfreedom







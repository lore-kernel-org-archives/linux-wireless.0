Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:7460 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDSVoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 17:44:04 -0400
Received: by fk-out-0910.google.com with SMTP id 19so1467367fkr.5
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2008 14:44:02 -0700 (PDT)
Message-ID: <3efd34cc0804191444y458a74bdy3ffbebd806809677@mail.gmail.com> (sfid-20080419_224411_853462_63DDAD65)
Date: Sat, 19 Apr 2008 23:44:02 +0200
From: "bert hubert" <bert.hubert@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: linux 2.6.25 mainline: state of mac80211 and hostapd ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody,

My trusty ASUS WL-300G is dying on me and I'm hoping to use my new
low-power VIA C7 linux server as an access point.

I run Linux 2.6.25, with:
00:08.0 Network controller: RaLink RT2561/RT61 802.11g PCI
Based on:
rt61pci                23808  0
rt2x00pci              11008  1 rt61pci
rt2x00lib              23808  2 rt61pci,rt2x00pci
rfkill                  7700  1 rt2x00lib
input_polldev           5256  1 rt2x00lib
crc_itu_t               2304  1 rt2x00lib
eeprom_93cx6            2432  1 rt61pci

And it works very well. I've tried 'hostapd' 0.5.9 and 0.5.10 in
various modes but all of them fail very early with warnings about:
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
ioctl[PRISM2_IOCTL_PRISM2_PARAM]: Operation not supported
Could not enable hostapd mode for interface wlan0

# Driver interface type (hostap/wired/madwifi/prism54; default: hostap)
driver=hostap

I've trawled the web and found Johannes Berg's patches, but they
appear to indicate that recent hostap & linux kernels don't need any
patches.

Am I trying to do something that can't work? Or do I need patches? I'm
more than willing to patch & test.

Thanks for your attention - if I figure out how this works I'll write
a small HOWTO.

     Bert

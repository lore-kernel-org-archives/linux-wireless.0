Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59027 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZCDVdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 16:33:24 -0500
Received: by bwz26 with SMTP id 26so3006974bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 13:33:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
Date: Wed, 4 Mar 2009 21:33:21 +0000
Message-ID: <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com> (sfid-20090304_223327_310141_74DC31CD)
Subject: ath5k master (AP) mode
From: Alexey Yudichev <ayudichev@yahoo.co.uk>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've just joined the list so don't know how to join the same thread so
to indicate that it's the same matter I use the same subject. I am
trying to make my "04:01.0 Ethernet controller: Atheros Communications
Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)" which is
identified by ath5k as
[=C2=A0=C2=A0 10.356742] ath5k phy0: Atheros AR5213A chip found (MAC: 0=
x59, PHY: 0x43)
[=C2=A0=C2=A0 10.356748] ath5k phy0: RF5112B multiband radio found (0x3=
6)
work in master mode.
I've patched /drivers/net/wireless/ath5k/base.c as was suggested, I
even put a debug printk() to make sure the patched version is used:


=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR "ath5k_pci: =
AP PATCH APPLIED!!!\n");
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw->wiphy->interface_modes =3D
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BIT(NL80211_IFTYPE_STATION) |
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BIT(NL80211_IFTYPE_AP) |
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BIT(NL80211_IFTYPE_ADHOC) |
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BIT(NL80211_IFTYPE_MESH_POINT);


in dmesg I do see this:

[=C2=A0=C2=A0=C2=A0 9.899231] ath5k 0000:04:01.0: PCI INT A -> GSI 17 (=
level, low) -> IRQ 17
[=C2=A0=C2=A0=C2=A0 9.899272] ath5k 0000:04:01.0: registered as 'phy0'
[=C2=A0=C2=A0=C2=A0 9.899275] ath5k_pci: AP PATCH APPLIED!!!
[=C2=A0=C2=A0 10.356742] ath5k phy0: Atheros AR5213A chip found (MAC: 0=
x59, PHY: 0x43)
[=C2=A0=C2=A0 10.356748] ath5k phy0: RF5112B multiband radio found (0x3=
6)

however it still doesn't work:

# iwconfig wlan1 mode master
Error for wireless request "Set Mode" (8B06) :
=C2=A0=C2=A0=C2=A0 SET failed on device wlan1 ; Invalid argument.

Obviously I am missing something, but can't find what. Are there any
other prerequisites? Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

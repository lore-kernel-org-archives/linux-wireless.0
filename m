Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41480 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LYQTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Dec 2013 11:19:39 -0500
Received: by mail-la0-f46.google.com with SMTP id eh20so3295309lab.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Dec 2013 08:19:38 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Dec 2013 11:19:37 -0500
Message-ID: <CAN44aq091tLNVywEqOV7A86K-XSrLD5QjcH0BbPO-oBTPnp8kw@mail.gmail.com> (sfid-20131225_171959_702430_3E89DF3C)
Subject: possibly broken tx_power change under linux 3.10.17 and potentially mainline
From: Alex Gal <a.gal@motsai.com>
To: linux-wireless@vger.kernel.org
Cc: Jean-Samuel Chenard <js.chenard@motsai.com>, luca@coelho.fi
Content-Type: multipart/mixed; boundary=001a11c334743981d804ee5e3af5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a11c334743981d804ee5e3af5
Content-Type: text/plain; charset=UTF-8

Hello all,

We had an issue with a custom board we developped using the TIWI-BLE chip.

We use the board to create a soft AP using hostapd but the signal
strength was weak but functional.

The beaglebone with the TIWI-BLE cape would have a very strong signal
instead, using the same hostapd version and the same TI firmware and
calibration file.

We ruled out the firmware, calibration, antenna and other hardware
bugs and started looking into the driver instead.

The driver in question is wl12xx but the problem did not appear to come from it.

In kernel 3.2, "iwconfig wlan0 txpower 10" would work but not in kernel 3.10.

I compared the driver in linux 3.2 and some of the kernel code and it
seems the handling of
SIOCSIWTXPOW has changed.

In kernel 3.10, the tx power would be set to 20 once the AP would be
created but the driver never updated it.

In kernel 3.2, IEEE80211_CONF_CHANGE_POWER was issued and handled in
the driver op_config handler.

However, the 3.10 kernel code no longer issues
IEEE80211_CONF_CHANGE_POWER  but BSS_CHANGED_TXPOWER which is not
handled by the wl12xx driver.

After looking for BSS_CHANGED_TXPOWER, most drivers, if not all of
them, do not handle BSS_CHANGED_TXPOWER so this could affect all
drivers.

I added a a bit of code to wlcore/main.c to handle BSS_CHANGED_TXPOWER
and it seems to be working now. See patch in attachment.

What do you guys think ?

Happy holidays,

Alex

--001a11c334743981d804ee5e3af5
Content-Type: text/x-patch; charset=US-ASCII; name="tx_power_wlcore.patch"
Content-Disposition: attachment; filename="tx_power_wlcore.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpmsf8dy0

ZGlmZiAtLWdpdCBkcml2ZXJzL25ldC93aXJlbGVzcy90aS93bGNvcmUvbWFpbi5jIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL3RpL3dsY29yZS9tYWluLmMKaW5kZXggOTUzMTExYS4uNjJkMWVjMSAxMDA2
NDQKLS0tIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL3dsY29yZS9tYWluLmMKKysrIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL3RpL3dsY29yZS9tYWluLmMKQEAgLTQzMzEsNiArNDMzMSwxNiBAQCBzdGF0
aWMgdm9pZCB3bDEyNzFfb3BfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywKIAlpZiAocmV0IDwgMCkKIAkJZ290byBvdXQ7CiAKKwlpZiAoKGNoYW5nZWQgJiBCU1NfQ0hB
TkdFRF9UWFBPV0VSKSAmJiBic3NfY29uZi0+dHhwb3dlciAhPSB3bHZpZi0+cG93ZXJfbGV2ZWwp
IHsKKworCQlyZXQgPSB3bDEyNzFfYWN4X3R4X3Bvd2VyKHdsLCB3bHZpZiwgYnNzX2NvbmYtPnR4
cG93ZXIpOworCisJCWlmIChyZXQgPCAwKQorCQkJZ290byBvdXQ7CisKKwkJd2x2aWYtPnBvd2Vy
X2xldmVsID0gYnNzX2NvbmYtPnR4cG93ZXI7CisJfQorCiAJaWYgKGlzX2FwKQogCQl3bDEyNzFf
YnNzX2luZm9fY2hhbmdlZF9hcCh3bCwgdmlmLCBic3NfY29uZiwgY2hhbmdlZCk7CiAJZWxzZQo=
--001a11c334743981d804ee5e3af5--

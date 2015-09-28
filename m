Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36768 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbbI1JAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 05:00:08 -0400
Received: by ioii196 with SMTP id i196so168532390ioi.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2015 02:00:08 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Sep 2015 11:00:07 +0200
Message-ID: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com> (sfid-20150928_110016_665043_EF194C0C)
Subject: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: multipart/mixed; boundary=001a113ed8e29240660520caec2b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a113ed8e29240660520caec2b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm using recent brcmfmac and brcmfmac43602-pcie.ap.bin that currently
sits in linux-firmware.git.

In OpenWrt we have hostapd with a feature of banning STAs. It works in
a quite simple way. Whenever hostapd gets NL80211_CMD_NEW_STATION for
STA that is banned it sends NL80211_CMD_DEL_STATION.

The problem is that in such case BCM43602 firmware happens to randomly
send more than 1 BRCMF_E_DEAUTH event. It seems it can send random
amount between 1 and 3. Looks a bit like some kind of race. It's
nothing really critical, just makes hostapd log a bit confusing.

Could someone at Broadcom look at firmware source to see if you can
fix this, please?

--=20
Rafa=C5=82

--001a113ed8e29240660520caec2b
Content-Type: text/plain; charset=US-ASCII; name="syslog-brcmfmac-hostapd.txt"
Content-Disposition: attachment; filename="syslog-brcmfmac-hostapd.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_if3pe47w0

U3VuIFNlcCAyNyAxOToxNToyMiAyMDE1IGtlcm4uaW5mbyBrZXJuZWw6IFsgMTA0Ny44ODY0MzNd
IGJyY21mbWFjOiBbYnJjbWZfbm90aWZ5X2Nvbm5lY3Rfc3RhdHVzX2FwXSBldmVudDo4OkJSQ01G
X0VfQVNTT0NfSU5EIGUtPmFkZHI6Nzg6ZDY6ZjA6OWI6YWE6YmIKU3VuIFNlcCAyNyAxOToxNToy
MiAyMDE1IGRhZW1vbi5pbmZvIGhvc3RhcGQ6IHdsYW4wOiBTVEEgNzg6ZDY6ZjA6OWI6YWE6YmIg
SUVFRSA4MDIuMTE6IGFzc29jaWF0ZWQKU3VuIFNlcCAyNyAxOToxNToyMiAyMDE1IGRhZW1vbi5p
bmZvIGhvc3RhcGQ6IFN0YXRpb24gNzg6ZDY6ZjA6OWI6YWE6YmIgYXNzb2MgcmVqZWN0ZWQgYnkg
dWJ1cyBoYW5kbGVyLgoKU3VuIFNlcCAyNyAxOToxNToyMiAyMDE1IGtlcm4uaW5mbyBrZXJuZWw6
IFsgMTA0Ny44OTc3NTFdIGJyY21mbWFjOiBbYnJjbWZfbm90aWZ5X2Nvbm5lY3Rfc3RhdHVzX2Fw
XSBldmVudDo1OkJSQ01GX0VfREVBVVRIIGUtPmFkZHI6Nzg6ZDY6ZjA6OWI6YWE6YmIKU3VuIFNl
cCAyNyAxOToxNToyMiAyMDE1IGRhZW1vbi5pbmZvIGhvc3RhcGQ6IHdsYW4wOiBTVEEgNzg6ZDY6
ZjA6OWI6YWE6YmIgSUVFRSA4MDIuMTE6IGRpc2Fzc29jaWF0ZWQKClN1biBTZXAgMjcgMTk6MTU6
MjIgMjAxNSBrZXJuLmluZm8ga2VybmVsOiBbIDEwNDcuOTA4MDg1XSBicmNtZm1hYzogW2JyY21m
X25vdGlmeV9jb25uZWN0X3N0YXR1c19hcF0gZXZlbnQ6NTpCUkNNRl9FX0RFQVVUSCBlLT5hZGRy
Ojc4OmQ2OmYwOjliOmFhOmJiClN1biBTZXAgMjcgMTk6MTU6MjIgMjAxNSBkYWVtb24uaW5mbyBo
b3N0YXBkOiB3bGFuMDogU1RBIDc4OmQ2OmYwOjliOmFhOmJiIElFRUUgODAyLjExOiBkaXNhc3Nv
Y2lhdGVkCgpTdW4gU2VwIDI3IDE5OjE1OjIyIDIwMTUga2Vybi5pbmZvIGtlcm5lbDogWyAxMDQ4
LjQxNDAzMV0gYnJjbWZtYWM6IFticmNtZl9ub3RpZnlfY29ubmVjdF9zdGF0dXNfYXBdIGV2ZW50
OjU6QlJDTUZfRV9ERUFVVEggZS0+YWRkcjo3ODpkNjpmMDo5YjphYTpiYgpTdW4gU2VwIDI3IDE5
OjE1OjIyIDIwMTUgZGFlbW9uLmluZm8gaG9zdGFwZDogd2xhbjA6IFNUQSA3ODpkNjpmMDo5Yjph
YTpiYiBJRUVFIDgwMi4xMTogZGlzYXNzb2NpYXRlZAo=
--001a113ed8e29240660520caec2b--

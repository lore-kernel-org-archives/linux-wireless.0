Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64142 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3CZRKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:10:38 -0400
Received: by mail-ob0-f171.google.com with SMTP id x4so7272670obh.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 10:10:38 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 18:10:37 +0100
Message-ID: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com> (sfid-20130326_181054_958567_0E045FFC)
Subject: Scanning regression since "cfg80211: use DS or HT operation IEs to
 determine BSS channel"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: multipart/mixed; boundary=089e0115fac61801f304d8d70070
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e0115fac61801f304d8d70070
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I've just finished bisecting wireless scanning regression I'm
experiencing with my 14e4:432b (BCM4322) and b43 driver.

The problem is getting my network visible in scanning results (iw dev
wlan0 scan). I've to repeat scanning dozens of time to notice my AP.
It's also well visible when using wpa_supplicant. It takes from 20s to
100s before I get the "Trying to authenticate with".
The performance however is not affected. Once I connect to my network,
I can transmit (tested with iperf) with stable 21.5Mb/s which is just
great for 802.11g.

After going back to the kernel before that commit it takes
wpa_supplicant less than 2 seconds to connect to my WiFi network.

My network is at channel 13, I still have to verify if it matters.

Any thought about that?


The first bad commit (I've verified manually after bisecting) appears to be=
:

0172bb75073e11a5aa9d8a953bdaefb8709f00c8 is the first bad commit
commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Nov 23 14:23:30 2012 +0100

    cfg80211: use DS or HT operation IEs to determine BSS channel

    Currently, mac80211 checks the DS params IE if present and
    uses it for the (primary) BSS channel, instead of the one
    that the frame was received on. This is particularly useful
    in the 2.4 GHz band since a frame is often received on one
    of the adjacent channels due to overlap.

    Move this code to cfg80211 so other drivers also do this.

    Additionally, on 5 GHz, in particular with some (possibly)
    upcoming changes in 802.11ai and duplicate transmissions
    when wider channels are used, something similar happens.
    So if present, also use the (primary) channel information
    contained in the HT operation IE.

    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

--=20
Rafa=C5=82

--089e0115fac61801f304d8d70070
Content-Type: text/plain; charset=US-ASCII; name="scanning.txt"
Content-Disposition: attachment; filename="scanning.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_herbli0s0

QlNTIDAwOjExOjIyOjMzOjQ0OjU1IChvbiB3bGFuMCkKCVRTRjogMTY1Mzc2Mzg0IHVzZWMgKDBk
LCAwMDowMjo0NSkKCWZyZXE6IDI0NzIKCWJlYWNvbiBpbnRlcnZhbDogMTAwCgljYXBhYmlsaXR5
OiBFU1MgUHJpdmFjeSBTaG9ydFNsb3RUaW1lICgweDA0MTEpCglzaWduYWw6IC01MC4wMCBkQm0K
CWxhc3Qgc2VlbjogMTUzIG1zIGFnbwoJSW5mb3JtYXRpb24gZWxlbWVudHMgZnJvbSBQcm9iZSBS
ZXNwb25zZSBmcmFtZToKCVNTSUQ6IHphamVjX3Bvem5hbl8xNjAKCVN1cHBvcnRlZCByYXRlczog
MS4wKiAyLjAqIDUuNSogMTEuMCogNi4wIDkuMCAxMi4wIDE4LjAgCglEUyBQYXJhbWV0ZXIgc2V0
OiBjaGFubmVsIDEzCglDb3VudHJ5OiBQTCAgICAgRW52aXJvbm1lbnQ6IEluZG9vci9PdXRkb29y
CgkJQ2hhbm5lbHMgWzEgLSAxM10gQCAyMCBkQm0KCUVSUDogQmFya2VyX1ByZWFtYmxlX01vZGUK
CUV4dGVuZGVkIHN1cHBvcnRlZCByYXRlczogMjQuMCAzNi4wIDQ4LjAgNTQuMCAKCVJTTjogICAg
ICogVmVyc2lvbjogMQoJCSAqIEdyb3VwIGNpcGhlcjogQ0NNUAoJCSAqIFBhaXJ3aXNlIGNpcGhl
cnM6IENDTVAKCQkgKiBBdXRoZW50aWNhdGlvbiBzdWl0ZXM6IFBTSwoJCSAqIENhcGFiaWxpdGll
czogMTYtUFRLU0EtUkMgKDB4MDAwYykKCUhUIGNhcGFiaWxpdGllczoKCQlDYXBhYmlsaXRpZXM6
IDB4MTA0ZQoJCQlIVDIwL0hUNDAKCQkJU00gUG93ZXIgU2F2ZSBkaXNhYmxlZAoJCQlSWCBIVDQw
IFNHSQoJCQlObyBSWCBTVEJDCgkJCU1heCBBTVNEVSBsZW5ndGg6IDM4MzkgYnl0ZXMKCQkJRFNT
Uy9DQ0sgSFQ0MAoJCU1heGltdW0gUlggQU1QRFUgbGVuZ3RoIDY1NTM1IGJ5dGVzIChleHBvbmVu
dDogMHgwMDMpCgkJTWluaW11bSBSWCBBTVBEVSB0aW1lIHNwYWNpbmc6IDggdXNlYyAoMHgwNikK
CQlIVCBUWC9SWCBNQ1MgcmF0ZSBpbmRleGVzIHN1cHBvcnRlZDogMC0xNQoJSFQgb3BlcmF0aW9u
OgoJCSAqIHByaW1hcnkgY2hhbm5lbDogMTMKCQkgKiBzZWNvbmRhcnkgY2hhbm5lbCBvZmZzZXQ6
IGJlbG93CgkJICogU1RBIGNoYW5uZWwgd2lkdGg6IGFueQoJCSAqIFJJRlM6IDAKCQkgKiBIVCBw
cm90ZWN0aW9uOiAyMCBNSHoKCQkgKiBub24tR0YgcHJlc2VudDogMAoJCSAqIE9CU1Mgbm9uLUdG
IHByZXNlbnQ6IDAKCQkgKiBkdWFsIGJlYWNvbjogMAoJCSAqIGR1YWwgQ1RTIHByb3RlY3Rpb246
IDAKCQkgKiBTVEJDIGJlYWNvbjogMAoJCSAqIEwtU0lHIFRYT1AgUHJvdDogMAoJCSAqIFBDTyBh
Y3RpdmU6IDAKCQkgKiBQQ08gcGhhc2U6IDAKCVdNTTogICAgICogUGFyYW1ldGVyIHZlcnNpb24g
MQoJCSAqIEJFOiBDVyAxNS0xMDIzLCBBSUZTTiAzCgkJICogQks6IENXIDE1LTEwMjMsIEFJRlNO
IDcKCQkgKiBWSTogQ1cgNy0xNSwgQUlGU04gMiwgVFhPUCAzMDA4IHVzZWMKCQkgKiBWTzogYWNt
IENXIDMtNywgQUlGU04gMiwgVFhPUCAxNTA0IHVzZWMK
--089e0115fac61801f304d8d70070--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52335 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249AbZJaVYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 17:24:33 -0400
Received: by bwz27 with SMTP id 27so4879164bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 14:24:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: James Grossmann <cctsurf@gmail.com>
Subject: Re: Prism54/p54pci
Date: Sat, 31 Oct 2009 22:24:29 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Lamparter <chunkeey@web.de>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <43e72e890910310626q6d145673he38a3a4e56ca8f7c@mail.gmail.com> <167ae39b0910310711r1552b82ej81f894e5a565f3cc@mail.gmail.com>
In-Reply-To: <167ae39b0910310711r1552b82ej81f894e5a565f3cc@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910312224.29812.chunkeey@googlemail.com>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NsK7KP4/AjUL/BS"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_NsK7KP4/AjUL/BS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Saturday 31 October 2009 15:11:37 James Grossmann wrote:
> [ 4200.794299] cfg80211: Calling CRDA to update world regulatory
> domain
> [ 4200.857330] p54pci 0000:03:00.0: PCI INT A -> Link[LNKA] -> GSI 11
> (level, low) -> IRQ 11
> [ 4200.857408] p54pci 0000:03:00.0: firmware: requesting isl3886pci
> [ 4201.432596] phy0: p54 detected a LM86 firmware
> [ 4201.432604] p54: rx_mtu reduced from 3240 to 2376
> [ 4201.432610] phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> [ 4201.432616] phy0: cryptographic accelerator WEP:YES, TKIP:YES,
> CCMP:YES

> [ 4202.293254] phy0: EEPROM is damaged... you may not be able to use
> all channels with this device.
^^^ = that's the culprit.

do you think, you can get this EEPROM dump?
Just move the attach _patch_ into your compat-wireless' main directory.
Afterward, you have to execute:
patch -p1 < p54-dump-eeprom-to-dmesg.diff

and rebuild & reload the driver and retrieve the data
from dmesg.

> [ 4202.293286] phy0: [iqauto calibration data] is/are missing for
> channel:2 [2417 MHz].
> [ 4202.293293] phy0: [iqauto calibration data] is/are missing for
> channel:3 [2422 MHz].
> [ 4202.293300] phy0: [iqauto calibration data] is/are missing for
> channel:4 [2427 MHz].
> [ 4202.293306] phy0: [iqauto calibration data] is/are missing for
> channel:5 [2432 MHz].
> [ 4202.293313] phy0: [iqauto calibration data] is/are missing for
> channel:6 [2437 MHz].
> [ 4202.293320] phy0: [iqauto calibration data] is/are missing for
> channel:8 [2447 MHz].
> [ 4202.293326] phy0: [iqauto calibration data] is/are missing for
> channel:9 [2452 MHz].
> [ 4202.293333] phy0: [iqauto calibration data] is/are missing for
> channel:10 [2457 MHz].
> [ 4202.293340] phy0: [iqauto calibration data] is/are missing for
> channel:11 [2462 MHz].
> [ 4202.293346] phy0: [iqauto calibration data] is/are missing for
> channel:12 [2467 MHz].

> [ 4202.293356] phy0: hwaddr 00:xx:xx:xx:xx:xx, MAC:isl3880 RF:Frisbee
> [ 4202.293787] phy0: Selected rate control algorithm 'minstrel'
> [ 4202.295616] Registered led device: p54-phy0::assoc
> [ 4202.295657] Registered led device: p54-phy0::tx
> [ 4202.295703] Registered led device: p54-phy0::rx
> [ 4202.295744] Registered led device: p54-phy0::radio
> [ 4202.295758] p54pci 0000:03:00.0: is registered as 'phy0'
> [ 4202.378618] udev: renamed network interface wlan0 to wlan1
> [ 4202.509483] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 4202.724125] phy0: frequency change to channel 2 failed.
> [ 4202.724138] phy0: frequency change to channel 3 failed.
> [ 4202.724145] phy0: frequency change to channel 4 failed.
> [ 4202.724151] phy0: frequency change to channel 5 failed.
> [ 4202.724157] phy0: frequency change to channel 6 failed.
> [ 4202.780179] phy0: frequency change to channel 8 failed.
> [ 4202.780193] phy0: frequency change to channel 9 failed.
> [ 4202.780199] phy0: frequency change to channel 10 failed.
> [ 4202.780206] phy0: frequency change to channel 11 failed.
> [ 4202.780212] phy0: frequency change to channel 12 failed.
> [ 4208.212168] phy0: frequency change to channel 2 failed.
> [ 4208.212180] phy0: frequency change to channel 3 failed.
> [ 4208.212187] phy0: frequency change to channel 4 failed.
> [ 4208.212193] phy0: frequency change to channel 5 failed.
> [ 4208.212199] phy0: frequency change to channel 6 failed.
> [ 4208.276097] phy0: frequency change to channel 8 failed.
> [ 4208.276112] phy0: frequency change to channel 9 failed.
> [ 4208.276119] phy0: frequency change to channel 10 failed.
> [ 4208.276125] phy0: frequency change to channel 11 failed.
> [ 4208.276132] phy0: frequency change to channel 12 failed.
> [ 4208.524788] phy0: frequency change to channel 6 failed.
> [ 4208.524949] wlan1: deauthenticating from 00:xx:xx:xx:xx:xx by local
> choice (reason=3)
> [ 4208.525084] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
> [ 4208.724191] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 2)
[...]

Regards,
	Chr

--Boundary-00=_NsK7KP4/AjUL/BS
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="p54-dump-eeprom-to-dmesg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-dump-eeprom-to-dmesg.diff"

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 8dfe815..7504588 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -540,6 +540,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 	wrap = (struct eeprom_pda_wrap *) eeprom;
 	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
 
+	print_hex_dump_bytes("EEPROM:", DUMP_PREFIX_OFFSET, eeprom, len);
+
 	/* verify that at least the entry length/code fits */
 	while ((u8 *)entry <= end - sizeof(*entry)) {
 		entry_len = le16_to_cpu(entry->len);

--Boundary-00=_NsK7KP4/AjUL/BS--

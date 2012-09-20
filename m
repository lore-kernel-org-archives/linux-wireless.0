Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50236 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2ITKz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 06:55:58 -0400
Received: by wibhi8 with SMTP id hi8so507141wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 03:55:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Sep 2012 12:55:57 +0200
Message-ID: <CANq1E4QzhnVwk1Tt3JAK7Qgp=LbMuS58xd6i147Nvjts0MkmwQ@mail.gmail.com> (sfid-20120920_125602_260229_D214E2A0)
Subject: rt73usb: WARN(x) in check_sdata_in_driver() again
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I reported this earlier this year:
http://www.spinics.net/lists/linux-wireless/msg94318.html
I now run kernel 3.5.3 and still get the warnings. dmesg is attached.
Device is an:
  ASUSTek Computer, Inc. WL-167G v2 802.11g Adapter [Ralink RT2571W]
With USB ID: 0b05:1723. The device is quite old and works only on
short ranges but it does work reliably now. I get the warnings but I
no longer have to reboot, the device simply continues working.
The device looks like this one (if someone is interested):
http://i.discuss.com.hk/d/attachments/day_110626/20110626_036ae8435bb3894c6548lo8K2yBToJq4.jpg

wpa_supplicant was started with:
  wpa_supplicant -B -P /run/wpa_supplicant_wlan0.pid -i wlan0 -D
nl80211,wext -c/run/network/wpa.wlan0/wpa.conf
The /run/..../wpa.conf file looks like this:
  ctrl_interface=/run/wpa_supplicant
  ctrl_interface_group=wheel
  network = {
    ssid="...my ssid..."
    proto=RSN WPA
    psk="...my password..."
  }

dmesg output: https://gist.github.com/3755159
Sorry, its quite long but I think it contains all required information.

I don't know how to reproduce this reliably, but suspending/resuming a
few times does almost always generate these warnings. Also note the
easily overlooked warning before suspending the first time:
[267106.009044] phy0 -> rt73usb_set_device_state: Error - Device
failed to enter state 1 (-16).

The first warning that occurs then goes like this:
[267107.447852] ------------[ cut here ]------------
[267107.447869] WARNING: at net/mac80211/util.c:574
ieee80211_can_queue_work.isra.29+0x2d/0x40()
[267107.447872] Hardware name: N150P/N210P/N220P
[267107.447874] queueing ieee80211 work while going to suspend

So I really think the problem is that the device is not correctly put
to sleep during suspend and then continues sending data. The other
warnings probably are caused by this, too. As I said, the device still
works after resume, and if not, then I simply replug it, as I am not
sure whether it doesn't work because of this error or because of being
out-of-range.

It really doesn't bother me much as it works reliably. But maybe
you're interested in these warnings and Stanislaw asked me to report
whether these warnings still occur with 3.5.1. And yes, they do.

Regards
David

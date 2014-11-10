Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46541 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaKJSMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 13:12:46 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so9847583wgg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 10:12:45 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 10 Nov 2014 12:12:45 -0600
Message-ID: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com> (sfid-20141110_191250_152671_8BBAAC80)
Subject: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: kvalo@qca.qualcomm.com, ath6kl@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending in plain text mode...

Hi Kalle,
   I have a custom built board with an AR6003 WiFi chip running
linux-3.10.40 and hostapd 2.2 that I'm trying to use as an access
point.

My configuration file for hostapd is:
interface=wlan0
driver=nl80211
ssid=testssid
channel=1
own_ip_addr=**********
auth_algs=1
wpa=2
wpa_passphrase=**********
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rns_pairwise=CCMP
ignore_broadcase_ssid=1

I should mention that this configuration works with a USB WiFi stick
with an ath9k chipset running the same linux kernel and hostapd
binary.

When using the AR6003 chipset the client Laptop (HP EliteBook 8440p
running ubuntu 12.04.3 LTS) does not connect and prints the message:
wlan0: disassociating from <device mac> by local choice (reason=17)

Running Wireshark on the Laptop, I see "Key (msg 1/4)", "Key (msg
2/4)", and then "Key (msg 3/4)" before it tries to reauthenticate.

On the access point device, I see the logs from WAP that message 3/4
was sent and the next message received is NL80211_CMD_DEL_STATION.

I've searched online for the reason=17 and haven't come across an
answer yet.  The access point device is not connected to a computer
that is connected to the internet, so while getting log files is
possible, it 's just not the easiest thing to do.  If requested, I
could get a log dump from hostapd and/or debug output from the ath6kl
driver.

Thanks for any help
Brent Taylor

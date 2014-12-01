Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:57621 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaLAStG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 13:49:06 -0500
Received: by mail-qg0-f46.google.com with SMTP id z107so7953370qgd.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 10:49:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
Date: Mon, 1 Dec 2014 12:49:05 -0600
Message-ID: <CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com> (sfid-20141201_194915_624090_64125FF2)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2014 at 12:12 PM, Brent Taylor <motobud@gmail.com> wrote:
> Resending in plain text mode...
>
> Hi Kalle,
>    I have a custom built board with an AR6003 WiFi chip running
> linux-3.10.40 and hostapd 2.2 that I'm trying to use as an access
> point.
>
> My configuration file for hostapd is:
> interface=wlan0
> driver=nl80211
> ssid=testssid
> channel=1
> own_ip_addr=**********
> auth_algs=1
> wpa=2
> wpa_passphrase=**********
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> rns_pairwise=CCMP
> ignore_broadcase_ssid=1
>
> I should mention that this configuration works with a USB WiFi stick
> with an ath9k chipset running the same linux kernel and hostapd
> binary.
>
> When using the AR6003 chipset the client Laptop (HP EliteBook 8440p
> running ubuntu 12.04.3 LTS) does not connect and prints the message:
> wlan0: disassociating from <device mac> by local choice (reason=17)
>
> Running Wireshark on the Laptop, I see "Key (msg 1/4)", "Key (msg
> 2/4)", and then "Key (msg 3/4)" before it tries to reauthenticate.
>
> On the access point device, I see the logs from WAP that message 3/4
> was sent and the next message received is NL80211_CMD_DEL_STATION.
>
> I've searched online for the reason=17 and haven't come across an
> answer yet.  The access point device is not connected to a computer
> that is connected to the internet, so while getting log files is
> possible, it 's just not the easiest thing to do.  If requested, I
> could get a log dump from hostapd and/or debug output from the ath6kl
> driver.
>
> Thanks for any help
> Brent Taylor


Does anyone know where the "reason=17" comes from?  I traced it down
in the kernel and it looks like it comes from the WIFI Chip in the
Laptop, but I can not find what it means.

Is there more information from somewhere that I provide to get some
help with this?

Thanks,
Brent

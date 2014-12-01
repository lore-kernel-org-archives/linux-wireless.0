Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60606 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaLATA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 14:00:26 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so18494722wid.12
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 11:00:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
 <CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 2 Dec 2014 00:30:05 +0530
Message-ID: <CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com> (sfid-20141201_200032_223312_632CF904)
Subject: Re: Laptop disassociating by local choice (reason=17)
To: Brent Taylor <motobud@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2014 at 12:19 AM, Brent Taylor <motobud@gmail.com> wrote:
>
> On Mon, Nov 10, 2014 at 12:12 PM, Brent Taylor <motobud@gmail.com> wrote:
> > Resending in plain text mode...
> >
> > Hi Kalle,
> >    I have a custom built board with an AR6003 WiFi chip running
> > linux-3.10.40 and hostapd 2.2 that I'm trying to use as an access
> > point.
> >
> > My configuration file for hostapd is:
> > interface=wlan0
> > driver=nl80211
> > ssid=testssid
> > channel=1
> > own_ip_addr=**********
> > auth_algs=1
> > wpa=2
> > wpa_passphrase=**********
> > wpa_key_mgmt=WPA-PSK
> > wpa_pairwise=TKIP
> > rns_pairwise=CCMP
> > ignore_broadcase_ssid=1
> >
> > I should mention that this configuration works with a USB WiFi stick
> > with an ath9k chipset running the same linux kernel and hostapd
> > binary.
> >
> > When using the AR6003 chipset the client Laptop (HP EliteBook 8440p
> > running ubuntu 12.04.3 LTS) does not connect and prints the message:
> > wlan0: disassociating from <device mac> by local choice (reason=17)
> >
> > Running Wireshark on the Laptop, I see "Key (msg 1/4)", "Key (msg
> > 2/4)", and then "Key (msg 3/4)" before it tries to reauthenticate.
> >
> > On the access point device, I see the logs from WAP that message 3/4
> > was sent and the next message received is NL80211_CMD_DEL_STATION.
> >
> > I've searched online for the reason=17 and haven't come across an
> > answer yet.  The access point device is not connected to a computer
> > that is connected to the internet, so while getting log files is
> > possible, it 's just not the easiest thing to do.  If requested, I
> > could get a log dump from hostapd and/or debug output from the ath6kl
> > driver.
> >
> > Thanks for any help
> > Brent Taylor
>
>
> Does anyone know where the "reason=17" comes from?  I traced it down
> in the kernel and it looks like it comes from the WIFI Chip in the
> Laptop, but I can not find what it means.
>
> Is there more information from somewhere that I provide to get some
> help with this?
>
> Thanks,
> Brent


Reason code 17 means:
element in 4-Way Handshake different from (Re)Association
Request/Probe Response/Beacon frame.

When the MSG 3/4 is received hostapd valdiates the IE stored from the
beacon/probe and if mismatch it issues deauth with reason code 17.

wpa_supplicant_process_3_of_4: wpa_supplicant_validate_ie in
hostapd/src/rsn_supp/wpa.c
Sniffer capture and hostapd logs might help to try to understand what
is mismatched.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44689 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0GWTfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 15:35:51 -0400
Received: by pwi5 with SMTP id 5so3642292pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 12:35:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
References: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 23 Jul 2010 15:35:30 -0400
Message-ID: <AANLkTinfMiS=+dqi=azF2exJbkrSLYT9nN0aor7gff-Q@mail.gmail.com>
Subject: Re: regulatory hiccup
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 23, 2010 at 3:30 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Then, after fiddling with an AP for a bit, I got:
>
> [11747.264221] cfg80211: Calling CRDA for country: US
> [11747.282664] cfg80211: Current regulatory domain updated by AP to: US
> [11747.282672]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [11747.282680]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)
> [11747.282688]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)
>

It's worse than that.  I reconnected to the AP (it appeared to work
for a few seconds) and I saw:

Wiphy phy0
[...]
	Band 2:
		Capabilities: 0x872
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)
			* 5745 MHz [149] (disabled)
			* 5765 MHz [153] (disabled)
			* 5785 MHz [157] (disabled)
			* 5805 MHz [161] (disabled)
			* 5825 MHz [165] (disabled)

Which is absurd, because:

Connected to 00:02:6f:6e:d7:6c (on wlan0)
	SSID: FFTT5
	freq: 5785        [!!!!!!!!!!!]
	RX: 72058 bytes (310 packets)
	TX: 2568 bytes (20 packets)
	signal: -33 dBm
	tx bitrate: 6.0 MBit/s

The connection died after a little while, presumably because the AP
was outside of its own allowed band.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:12643 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYKAUFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 16:05:43 -0400
Received: by yx-out-2324.google.com with SMTP id 8so758750yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 13:05:41 -0700 (PDT)
Message-ID: <43e72e890811011305i39da7effvf8150d0e65afc3d5@mail.gmail.com> (sfid-20081101_210547_512995_8E6922AC)
Date: Sat, 1 Nov 2008 13:05:41 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Julien HENRY" <henryju@yahoo.fr>
Subject: Re: Not associated with Intel 4965
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <769932.37144.qm@web28516.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <769932.37144.qm@web28516.mail.ukl.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 1, 2008 at 10:08 AM, Julien HENRY <henryju@yahoo.fr> wrote:
> Hi,
>
> I have big difficulties to make my wifi working (stay Not-Associated). After the first installation of my distrib, it worked fine, then after a few reboots it doesn't work anymore. Yesterday I deleted all wifi and wpa configuration and after lot af try I managed to make it work again. I rebooted and it was still working. But today it doesn't work anymore.
>
> My config:
>
> lspci
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
>
> uname -r
> 2.6.27-desktop-0.rc8.2mnb
>
> distrib
> Mandriva 2008.0 64bit
>
> Microcode version was iwlwifi-4965-ucode-228.57.1.21 but I upgraded to iwlwifi-4965-ucode-228.57.2.21 and rebooted but got same problem.
>
> My access point is configured with WPA (TKIP + AES) and ESSID is not hidden.
>
> Here is the result with a genuine configuration:
>
> 1) Just after boot (wlan0 is not configured): messages1.txt
> 2) Just after configuring wlan0 using Mandriva tool: messages2.txt
>
> At this point, we can see the problem:
>
> My access point is correctly listed:
>
> # iwlist wlan0 scanning
> ...
> Cell 03 - Address: 1A:66:DE:7A:AE:DC
>                    ESSID:"MiddleEarth"
>                    Mode:Master
>                    Channel:7
>                    Frequency:2.442 GHz (Channel 7)
>                    Quality=100/100  Signal level:-17 dBm  Noise level=-127 dBm
>                    Encryption key:on
>                    IE: WPA Version 1
>                        Group Cipher : TKIP
>                        Pairwise Ciphers (2) : TKIP CCMP
>                        Authentication Suites (1) : PSK
>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
>                              9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
>                              48 Mb/s; 54 Mb/s
>                    Extra:tsf=0000000833cdef72
>                    Extra: Last beacon: 899ms ago
> ...
>
> But can't manage to be associated:
>
> # iwconfig
> lo        no wireless extensions.
>
> eth0      no wireless extensions.
>
> wmaster0  no wireless extensions.
>
> wlan0     IEEE 802.11abgn  ESSID:"MiddleEarth"
>          Mode:Managed  Frequency:2.442 GHz  Access Point: Not-Associated
>          Tx-Power=15 dBm
>          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>          Encryption key:3266-C437-9DA2-5422-18C3-2621-22BB-35D1-B24C-7E80-E99E-9850-AC21-4F8F-7779-18E3 [2]   Security mode:open
>          Power Management:off
>          Link Quality:0  Signal level:0  Noise level:0
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
>
> So I tried to use latest version of the driver (compat). Compilation and installation worked fine. But I couldn't manage to unload some modules with the script (I had to use rmmod):
>
> # make unload
> Unloading mac80211...
> FATAL: Module mac80211 is in use.
> Unloading cfg80211...
> FATAL: Module cfg80211 is in use.
> make: *** [unload] Erreur 1
>
> # lsmod | grep iw
> iwlagn                104708  0
> iwlcore                87620  1 iwlagn
> rfkill                 13988  3 iwlcore,thinkpad_acpi
> led_class               8456  2 iwlcore,thinkpad_acpi
> mac80211              178600  2 iwlagn,iwlcore
> cfg80211               31504  3 iwlagn,iwlcore,mac80211
> # rmmod iwlagn
> # rmmod iwlcore
> # make unload
> Unloading mac80211...

Thanks I'll add these to the script

> Then I tried to load:
> # modprobe iwl4965
> WARNING: Error inserting iwlcore (/lib/modules/2.6.27-desktop-0.rc8.2mnb/updates/drivers/net/wireless/iwlwifi/iwlcore.ko): Unknown symbol in module, or unknown parameter (see dmesg)

We no longer have iwl4965, the new name is iwlagn, try that.

  Luis

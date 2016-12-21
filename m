Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33422 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcLUPW3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 10:22:29 -0500
Received: by mail-oi0-f46.google.com with SMTP id 128so17372791oig.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2016 07:22:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xaR=KZBOisPSPtamRquce_wLPrCrXPm9Co5OWw5cOu0jw@mail.gmail.com>
References: <CAHdg3xaR=KZBOisPSPtamRquce_wLPrCrXPm9Co5OWw5cOu0jw@mail.gmail.com>
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Wed, 21 Dec 2016 16:21:48 +0100
Message-ID: <CAHdg3xb2TCo6-m36zvNS_SADPM+SxE4bg_aHRc+RBo3zOaGX=Q@mail.gmail.com> (sfid-20161221_162233_464850_82D7B82C)
Subject: Re: ath10k mesh error 80MHz channel
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all again, just an update to the previous message:

looking at iw list I found this situation:

        Frequencies:
            * 5180 MHz [36] (20.0 dBm)
            * 5200 MHz [40] (20.0 dBm)
            * 5220 MHz [44] (20.0 dBm)
            * 5240 MHz [48] (20.0 dBm)
            * 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
            * 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
            * 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
            * 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
            * 5500 MHz [100] (23.0 dBm) (no IR, radar detection)
            * 5520 MHz [104] (23.0 dBm) (no IR, radar detection)
            * 5540 MHz [108] (23.0 dBm) (no IR, radar detection)
            * 5560 MHz [112] (23.0 dBm) (no IR, radar detection)
            * 5580 MHz [116] (23.0 dBm) (no IR, radar detection)
            * 5600 MHz [120] (23.0 dBm) (no IR, radar detection)
            * 5620 MHz [124] (23.0 dBm) (no IR, radar detection)
            * 5640 MHz [128] (23.0 dBm) (no IR, radar detection)
            * 5660 MHz [132] (23.0 dBm) (no IR, radar detection)
            * 5680 MHz [136] (23.0 dBm) (no IR, radar detection)
            * 5700 MHz [140] (23.0 dBm) (no IR, radar detection)
            * 5745 MHz [149] (disabled)
            * 5765 MHz [153] (disabled)
            * 5785 MHz [157] (disabled)
            * 5805 MHz [161] (disabled)
            * 5825 MHz [165] (disabled)
    Supported commands:
         * new_interface
         * set_interface
         * new_key

The no Initial Radiation prevent the interface to start transmitting.
I'm almost sure that it's a regulatory domain issue, but i already
tried to reinstall the CRD Agent, and even changing the regulatory
domain it change only the global (i.e. CH) while the iw list provide
the same results.
root@MrProper:~# iw reg get
global
country CH: DFS-ETSI
    (2402 - 2482 @ 40), (N/A, 20), (N/A)
    (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
    (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
    (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
    (57000 - 66000 @ 2160), (N/A, 40), (N/A)

phy#1
country US: DFS-FCC
    (2402 - 2472 @ 40), (N/A, 30), (N/A)
    (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
    (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
    (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
    (5735 - 5835 @ 80), (N/A, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#0
country US: DFS-FCC
    (2402 - 2472 @ 40), (N/A, 30), (N/A)
    (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
    (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
    (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
    (5735 - 5835 @ 80), (N/A, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#2
country US: DFS-FCC
    (2402 - 2472 @ 40), (N/A, 30), (N/A)
    (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
    (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
    (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
    (5735 - 5835 @ 80), (N/A, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

Is there a way to remove the no IR flags in the allowed channels?

Thanks a lot again

Matteo

2016-12-21 15:19 GMT+01:00 Matteo Grandi <iu5bdp@gmail.com>:
> Dear all,
>
> I'm configuring a simple mesh network using four miniPCIe adapters
> (Compex WLE900VX) on two Gateworks Ventana 5410 boards.
> Actually, based on the guide
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/mesh
> I don't have any problem setting up the mesh network on channels 36,
> 149, 153, respectively 5180 80 5210, 5745 80 5775, and 5765 80 5795
> (even if MIMO is not working).
>
> But while configuring the interfaces to work in 80MHz channel
> bandwidth (802.11ac using ath10k driver) on a different channel  I
> bump into the error:
>
> command failed: Invalid argument (-22)
>
> immediately after launching the command  for joining the mesh: iw dev
> <if_name> mesh join <mesh_name>.
>
> The syslog provide only this:
>
> Dec 21 13:52:03 MrProper kernel: [ 7257.058617] util.c |
> ieee80211_set_wmm_default: ac=0, enable_qos=true, vif.type=7,
> NL80211_IFTYPE_STATION=2
> Dec 21 13:52:03 MrProper kernel: [ 7257.059654] IPv6:
> ADDRCONF(NETDEV_UP): mpp1: link is not ready
> Dec 21 13:52:03 MrProper kernel: [ 7257.205911] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:03 MrProper kernel: [ 7257.581898] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:03 MrProper kernel: [ 7257.613627] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:04 MrProper kernel: [ 7258.084733] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:04 MrProper kernel: [ 7258.180963] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:04 MrProper kernel: [ 7258.325382] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:04 MrProper kernel: [ 7258.661534] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:05 MrProper kernel: [ 7259.029525] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:05 MrProper kernel: [ 7259.392563] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:08 MrProper kernel: [ 7262.386101] ath10k_warn: 18
> callbacks suppressed
> Dec 21 13:52:08 MrProper kernel: [ 7262.386154] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7262.737520] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7262.785597] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7262.971144] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7262.981414] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7263.091578] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7263.445603] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7263.458727] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7263.582180] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:09 MrProper kernel: [ 7263.589649] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:14 MrProper kernel: [ 7267.742838] ath10k_warn: 44
> callbacks suppressed
> Dec 21 13:52:14 MrProper kernel: [ 7267.742887] ath10k_pci
> 0000:07:00.0: no channel configured; ignoring frame(s)!
> Dec 21 13:52:14 MrProper kernel: [ 7267.744466] ath10k_pci
> 0000:07:00.0: no channel
>
> Did someone have a similar issue?
> Are there, maybe, some channels that even present in the regulatory
> domain with the @80 flags are not configurable in this way? (36, 52,
> 100, 116, 132, 149 should be ok, but only 36 and 149 work)
> Or maybe it's my reg-domain issue (see below)?
>
> root@MrProper:~# iw reg get
> global
> country US: DFS-FCC
>     (2402 - 2472 @ 40), (N/A, 30), (N/A)
>     (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
>     (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
>     (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>     (5735 - 5835 @ 80), (N/A, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#1
> country US: DFS-FCC
>     (2402 - 2472 @ 40), (N/A, 30), (N/A)
>     (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
>     (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
>     (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>     (5735 - 5835 @ 80), (N/A, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#0
> country US: DFS-FCC
>     (2402 - 2472 @ 40), (N/A, 30), (N/A)
>     (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
>     (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
>     (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>     (5735 - 5835 @ 80), (N/A, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#2
> country US: DFS-FCC
>     (2402 - 2472 @ 40), (N/A, 30), (N/A)
>     (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
>     (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
>     (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>     (5735 - 5835 @ 80), (N/A, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
>
> Thanks a lot for every hint!
>
> Matteo

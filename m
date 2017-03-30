Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33926 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754922AbdC3Fys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 01:54:48 -0400
Received: by mail-oi0-f46.google.com with SMTP id o67so20493949oib.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 22:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0gsjJvF34eQFQ48TLHv-t1H8W75R1+FkOzN76-K_N8Rw@mail.gmail.com>
References: <CAJ+vNU0gsjJvF34eQFQ48TLHv-t1H8W75R1+FkOzN76-K_N8Rw@mail.gmail.com>
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Thu, 30 Mar 2017 07:54:46 +0200
Message-ID: <CALhHN=oKYS=RRcJ1n2=Se8c0ce1OtYy3LNhmz-DT8EDT+QSSWQ@mail.gmail.com> (sfid-20170330_075453_153395_6F3C4AAC)
Subject: Re: [RESEND] ath9k failure to authenticate WPA2 client mode
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-wireless@vger.kernel.org,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 March 2017 at 19:03, Tim Harvey <tharvey@gateworks.com> wrote:
> Greetings,
>
> (resending plaintext - oops)
>
> I'm seeing failures to authenticate with a WPA2 secured AP using ath9k
> based cards on wireless-next:
>
> root@xenial-armhf:~# wpa_passphrase testssid testpass >
> /etc/wpa_supplicant/wpa_supplicant.conf
>
> root@xenial-armhf:~# iw reg get
> country US: DFS-FCC
>         (2402 - 2472 @ 40), (N/A, 30), (N/A)
>         (5170 - 5250 @ 80), (N/A, 17), (N/A)
>         (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS
>         (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>         (5735 - 5835 @ 80), (N/A, 30), (N/A)
>         (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> root@xenial-armhf:~# wpa_supplicant -i wlan0 -c
> /etc/wpa_supplicant/wpa_supplicant.conf
> Successfully initialized wpa_supplicant
> [ 1882.699010] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> nl80211: send_and_recv->nl_recvms[ 1886.262884] wlan0: authenticate
> with 02:1a:11:f2:35:9c
> gs failed: -33
> wlan0: SME: Trying to authenticate with 02:1a:11:f2:35:9c
> (SSID='testssid' freq=2437 MHz)
> [ 1886.280755] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
> [ 1887.033449] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
> [ 1887.993413] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
> [ 1888.953390] wlan0: authentication with 02:1a:11:f2:35:9c timed out
> wlan0: SME: Trying to authenticat[ 1892.507484] wlan0: authenticate
> with 02:1a:11:f2:35:9c
> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
> [ 1892.527460] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
> [ 1893.993401] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
> [ 1894.953419] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
> [ 1895.993387] wlan0: authentication with 02:1a:11:f2:35:9c timed out
> wlan0: SME: Trying to authenticat[ 1899.997262] wlan0: authenticate
> with 02:1a:11:f2:35:9c
> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
> [ 1900.017252] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
> [ 1901.033259] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
> [ 1901.993345] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
> [ 1902.953270] wlan0: authentication with 02:1a:11:f2:35:9c timed out
> wlan0: SME: Trying to authenticat[ 1907.407446] wlan0: authenticate
> with 02:1a:11:f2:35:9c
> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
> [ 1907.427370] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
> [ 1908.003204] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
> [ 1908.953275] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
> [ 1909.993254] wlan0: authentication with 02:1a:11:f2:35:9c timed out
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
> auth_failures=1 duration=10 reason=CONN_FAILED
> ^Cnl80211: deinit ifname=wlan0 disabled_11b_rates=0
> wlan0: CTRL-EVENT-TERMINATING
>
> I've tried loading ath9k with nohwcrypt=1 and see the same.
>
> I do not have any trouble with an ath10k card in the same system:
>
> root@xenial-armhf:~# wpa_supplicant -i wlan1 -c
> /etc/wpa_supplicant/wpa_supplicant.conf
> Successfully initialized wpa_supplicant
> [  593.401846] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
> wlan1: SME: Trying to authenticat[  596.857230] wlan1: authenticate
> with 02:1a:11:f1:b9:02
> e with 02:1a:11:f1:b9:02 (SSID='testssid' freq=2437 MHz)
> [  596.876749] wlan1: send auth to 02:1a:11:f1:b9:02 (try 1/3)
> [  596.886290] wlan1: authenticated
> wlan1: Trying to associate with 02:1a:11:f1:b9:02 (SSID='testssid'
> freq=2437 MHz)
> [  596.909012] wlan1: associate with 02:1a:11:f1:b9:02 (try 1/3)
> [  596.922374] wlan1: RX AssocResp from 02:1a:11:f1:b9:02 (capab=0x411
> status=0 aid=1)
> [  596.940754] wlan1: associated
> [  596.943954] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> wlan1: Associated with 02:1a:11:f1:b9:02
> wlan1: WPA: Key negotiation completed with 02:1a:11:f1:b9:02 [PTK=CCMP GTK=CCMP]
> wlan1: CTRL-EVENT-CONNECTED - Connection to 02:1a:11:f1:b9:02
> completed [id=0 id_str=]
> wlan1: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=US
> ^^^^ at this point I can dhcp IP config and all is good
>
> Here's the PCI info for the two cards:
>
> 08:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
> 88E8057 PCI-E Gigabit Ethernet Controller [11ab:4380]
> 09:00.0 Network controller [0280]: Qualcomm Atheros AR9580 Wireless
> Network Adapter [168c:0033] (rev 01)
>
> I don't know when ath9k last worked honestly. I usually use them under
> OpenWrt which has its own patches against periodic updates of linux
> backports. I noticed this first with Ubuntu 16.04 with the Ubuntu 4.4
> kernel, saw it still with the Ubuntu 4.8 kernel, then repeated the
> issue in wireless-next.
>
> Any ideas?
>
Interesting. Are you sure wlan0 is ath9k and wlan1 is ath10k?
ath9k is quite stable - I have AR9462 and works fine with 4.4 and current.
So, I would suspect some issues with ath10k :)

What if you will modprobe -r ath10k_pci and next run the test?

BR
Janusz

> Regards,
>
> Tim

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37793 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933005AbdC3XtZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 19:49:25 -0400
Received: by mail-it0-f43.google.com with SMTP id 190so3612317itm.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 16:49:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1HsQFSSDG+0rsnkpF5ao5JP9KkWaosGubUWXnj7E0e1Q@mail.gmail.com>
References: <CAJ+vNU0gsjJvF34eQFQ48TLHv-t1H8W75R1+FkOzN76-K_N8Rw@mail.gmail.com>
 <CALhHN=oKYS=RRcJ1n2=Se8c0ce1OtYy3LNhmz-DT8EDT+QSSWQ@mail.gmail.com> <CAJ+vNU1HsQFSSDG+0rsnkpF5ao5JP9KkWaosGubUWXnj7E0e1Q@mail.gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 30 Mar 2017 16:49:22 -0700
Message-ID: <CAJ+vNU3d6hg620R3qU=MLeALOz7yTE-+EU_o6jOfToCe-qZdzQ@mail.gmail.com> (sfid-20170331_014929_305001_CCC2001D)
Subject: Re: [RESEND] ath9k failure to authenticate WPA2 client mode
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 30, 2017 at 9:22 AM, Tim Harvey <tharvey@gateworks.com> wrote:
> On Wed, Mar 29, 2017 at 10:54 PM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> On 29 March 2017 at 19:03, Tim Harvey <tharvey@gateworks.com> wrote:
>>> Greetings,
>>>
>>> (resending plaintext - oops)
>>>
>>> I'm seeing failures to authenticate with a WPA2 secured AP using ath9k
>>> based cards on wireless-next:
>>>
>>> root@xenial-armhf:~# wpa_passphrase testssid testpass >
>>> /etc/wpa_supplicant/wpa_supplicant.conf
>>>
>>> root@xenial-armhf:~# iw reg get
>>> country US: DFS-FCC
>>>         (2402 - 2472 @ 40), (N/A, 30), (N/A)
>>>         (5170 - 5250 @ 80), (N/A, 17), (N/A)
>>>         (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS
>>>         (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
>>>         (5735 - 5835 @ 80), (N/A, 30), (N/A)
>>>         (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>>>
>>> root@xenial-armhf:~# wpa_supplicant -i wlan0 -c
>>> /etc/wpa_supplicant/wpa_supplicant.conf
>>> Successfully initialized wpa_supplicant
>>> [ 1882.699010] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> nl80211: send_and_recv->nl_recvms[ 1886.262884] wlan0: authenticate
>>> with 02:1a:11:f2:35:9c
>>> gs failed: -33
>>> wlan0: SME: Trying to authenticate with 02:1a:11:f2:35:9c
>>> (SSID='testssid' freq=2437 MHz)
>>> [ 1886.280755] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
>>> [ 1887.033449] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
>>> [ 1887.993413] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
>>> [ 1888.953390] wlan0: authentication with 02:1a:11:f2:35:9c timed out
>>> wlan0: SME: Trying to authenticat[ 1892.507484] wlan0: authenticate
>>> with 02:1a:11:f2:35:9c
>>> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
>>> [ 1892.527460] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
>>> [ 1893.993401] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
>>> [ 1894.953419] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
>>> [ 1895.993387] wlan0: authentication with 02:1a:11:f2:35:9c timed out
>>> wlan0: SME: Trying to authenticat[ 1899.997262] wlan0: authenticate
>>> with 02:1a:11:f2:35:9c
>>> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
>>> [ 1900.017252] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
>>> [ 1901.033259] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
>>> [ 1901.993345] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
>>> [ 1902.953270] wlan0: authentication with 02:1a:11:f2:35:9c timed out
>>> wlan0: SME: Trying to authenticat[ 1907.407446] wlan0: authenticate
>>> with 02:1a:11:f2:35:9c
>>> e with 02:1a:11:f2:35:9c (SSID='testssid' freq=2437 MHz)
>>> [ 1907.427370] wlan0: send auth to 02:1a:11:f2:35:9c (try 1/3)
>>> [ 1908.003204] wlan0: send auth to 02:1a:11:f2:35:9c (try 2/3)
>>> [ 1908.953275] wlan0: send auth to 02:1a:11:f2:35:9c (try 3/3)
>>> [ 1909.993254] wlan0: authentication with 02:1a:11:f2:35:9c timed out
>>> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
>>> auth_failures=1 duration=10 reason=CONN_FAILED
>>> ^Cnl80211: deinit ifname=wlan0 disabled_11b_rates=0
>>> wlan0: CTRL-EVENT-TERMINATING
>>>
>>> I've tried loading ath9k with nohwcrypt=1 and see the same.
>>>
>>> I do not have any trouble with an ath10k card in the same system:
>>>
>>> root@xenial-armhf:~# wpa_supplicant -i wlan1 -c
>>> /etc/wpa_supplicant/wpa_supplicant.conf
>>> Successfully initialized wpa_supplicant
>>> [  593.401846] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>> wlan1: SME: Trying to authenticat[  596.857230] wlan1: authenticate
>>> with 02:1a:11:f1:b9:02
>>> e with 02:1a:11:f1:b9:02 (SSID='testssid' freq=2437 MHz)
>>> [  596.876749] wlan1: send auth to 02:1a:11:f1:b9:02 (try 1/3)
>>> [  596.886290] wlan1: authenticated
>>> wlan1: Trying to associate with 02:1a:11:f1:b9:02 (SSID='testssid'
>>> freq=2437 MHz)
>>> [  596.909012] wlan1: associate with 02:1a:11:f1:b9:02 (try 1/3)
>>> [  596.922374] wlan1: RX AssocResp from 02:1a:11:f1:b9:02 (capab=0x411
>>> status=0 aid=1)
>>> [  596.940754] wlan1: associated
>>> [  596.943954] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
>>> wlan1: Associated with 02:1a:11:f1:b9:02
>>> wlan1: WPA: Key negotiation completed with 02:1a:11:f1:b9:02 [PTK=CCMP GTK=CCMP]
>>> wlan1: CTRL-EVENT-CONNECTED - Connection to 02:1a:11:f1:b9:02
>>> completed [id=0 id_str=]
>>> wlan1: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=US
>>> ^^^^ at this point I can dhcp IP config and all is good
>>>
>>> Here's the PCI info for the two cards:
>>>
>>> 08:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
>>> 88E8057 PCI-E Gigabit Ethernet Controller [11ab:4380]
>>> 09:00.0 Network controller [0280]: Qualcomm Atheros AR9580 Wireless
>>> Network Adapter [168c:0033] (rev 01)
>>>
>>> I don't know when ath9k last worked honestly. I usually use them under
>>> OpenWrt which has its own patches against periodic updates of linux
>>> backports. I noticed this first with Ubuntu 16.04 with the Ubuntu 4.4
>>> kernel, saw it still with the Ubuntu 4.8 kernel, then repeated the
>>> issue in wireless-next.
>>>
>>> Any ideas?
>>>
>> Interesting. Are you sure wlan0 is ath9k and wlan1 is ath10k?
>> ath9k is quite stable - I have AR9462 and works fine with 4.4 and current.
>> So, I would suspect some issues with ath10k :)
>>
>> What if you will modprobe -r ath10k_pci and next run the test?
>>
>
> It's ath9k for sure... several different ath9k radios fail the same
> way: WLE350NX, WLE200NX, WPEA-127NE, SR710E. I'm surprised as heck as
> well. I only put the ath10k radio in to ensure I don't have some
> configuration issue (and have since removed it and only test with 1
> card at a time). I've also ensured that a variety of radios/drivers
> work with the same Ubuntu xenial (16.04) userspace and kernels such as
> ath10k, carl9170, iwlwifi.
>
> Is there some userspace configuration issue I may have related to
> regdomain on ath9k that perhaps isn't applicable on other drivers?
>
> Note that depending on the kernel version I don't always get the same failure.
>
> Here is Ubuntu 4.8.0-30-generic which is where I originally saw the
> issue and started troubleshooting. In this case we auth/assoc and then
> immediately get disconnected from the AP:
> root@xenial-armhf:~# uname -a
> Linux xenial-armhf 4.8.0-30-generic #32~16.04.1-Ubuntu SMP Fri Dec 2
> 03:46:03 UTC 2016 armv7l armv7l armv7l GNU/Linux
> root@xenial-armhf:~# wpa_supplicant -i wlan0 -c
> /etc/wpa_supplicant/wpa_supplicant.conf -D nl80211
> Successfully initialized wpa_supplicant
> [  240.086690] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: SME: Trying to authenticat[  243.332657] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> e with 02:1a:11:f9:e9:04 (SSID='testssid' freq=2437 MHz)
> [  243.354923] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [  243.895326] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [  244.382493] wlan0: authenticated
> ^^^^ athenticated
> wlan0: Trying to associate with 02:1a:11:f9:e9:04 (SSID='testssid'
> freq=2437 MHz)
> [  244.423275] wlan0: associate with 02:1a:11:f9:e9:04 (try 1/3)
> [  245.879282] wlan0: associate with 02:1a:11:f9:e9:04 (try 2/3)
> [  246.462630] wlan0: RX AssocResp from 02:1a:11:f9:e9:04 (capab=0x411
> status=0 aid=1)
> [  246.470554] wlan0: associated
> ^^^^ associated
> [  246.473628] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: Associated with 02:1a:11:f9:e9:04
> wlan0: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=US
> wlan0: CTRL-EVENT-DISCONNECTED bssid=02:1a:11:f9:e9:04 reason=4
> locally_generated=1
> ^^^^ disconnected because of no activity? This was within around 1
> second of the association
> wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
> auth_failures=1 duration=10 reason=WRONG_KEY
> ^^^^ but we already authenticated???
> wlan0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
> wlan0: CTRL-EVENT-SSID-REENABLED [  259.744812] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> id=0 ssid="testssid"
> wlan0: SME: Trying to authenticate with 02:1a:11:f9:e9:04
> (SSID='testssid' freq=2437 MHz)
> [  259.766920] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [  260.798457] wlan0: authenticated
> wlan0: Trying to associate with 02:1a:11:f9:e9:04 (SSID='testssid'
> freq=2437 MHz)
> [  260.839297] wlan0: associate with 02:1a:11:f9:e9:04 (try 1/3)
> [  261.879297] wlan0: associate with 02:1a:11:f9:e9:04 (try 2/3)
> [  262.878638] wlan0: RX AssocResp from 02:1a:11:f9:e9:04 (capab=0x411
> status=0 aid=1)
> [  262.886553] wlan0: associated
> wlan0: Associated with 02:1a:11:f9:e9:04
> wlan0: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=US
> wlan0: CTRL-EVENT-DISCONNECTED bssid=02:1a:11:f9:e9:04 reason=4
> locally_generated=1
> wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
> auth_failures=2 duration=23 reason=WRONG_KEY
> wlan0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
> ^Cnl80211: deinit ifname=wlan0 disabled_11b_rates=0
> wlan0: CTRL-EVENT-TERMINATING
>
> And linux-wireless/master (we never get auuthenticated with ath9k):
> root@xenial-armhf:~# uname -a
> Linux xenial-armhf 4.11.0-rc2 #579 SMP Thu Mar 30 07:44:08 PDT 2017
> armv7l armv7l armv7l GNU/Linux
> root@xenial-armhf:~# wpa_supplicant -i wlan0 -c
> /etc/wpa_supplicant/wpa_supplicant.conf -D nl80211
> Successfully initialized wpa_supplicant
> [   27.312919] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: SME: Trying to authenticat[   30.924677] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> e with 02:1a:11:f9:e9:04 (SSID='testssid' freq=2437 MHz)
> [   30.954609] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [   32.090557] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [   33.129011] wlan0: send auth to 02:1a:11:f9:e9:04 (try 3/3)
> [   34.088942] wlan0: authentication with 02:1a:11:f9:e9:04 timed out
> wlan0: SME: Trying to authenticat[   37.670515] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> e with 02:1a:11:f9:e9:04 (SSID='testssid' freq=2437 MHz)
> [   37.693822] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [   39.128907] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [   40.089009] wlan0: send auth to 02:1a:11:f9:e9:04 (try 3/3)
> [   41.128974] wlan0: authentication with 02:1a:11:f9:e9:04 timed out
> wlan0: SME: Trying to authenticat[   45.092584] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> e with 02:1a:11:f9:e9:04 (SSID='testssid' freq=2437 MHz)
> [   45.115914] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [   46.008936] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [   46.968911] wlan0: send auth to 02:1a:11:f9:e9:04 (try 3/3)
> [   48.008849] wlan0: authentication with 02:1a:11:f9:e9:04 timed out
> wlan0: SME: Trying to authenticat[   52.472625] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> e with 02:1a:11:f9:e9:04 (SSID='testssid' freq=2437 MHz)
> [   52.495857] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [   53.058850] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [   54.008860] wlan0: send auth to 02:1a:11:f9:e9:04 (try 3/3)
> [   54.968960] wlan0: authentication with 02:1a:11:f9:e9:04 timed out
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
> auth_failures=1 duration=10 reason=CONN_FAILED
> wlan0: CTRL-EVENT-SSID-REENABLED [   71.862102] wlan0: authenticate
> with 02:1a:11:f9:e9:04
> id=0 ssid="testssid"
> wlan0: SME: Trying to authenticate with 02:1a:11:f9:e9:04
> (SSID='testssid' freq=2437 MHz)
> [   71.885021] wlan0: send auth to 02:1a:11:f9:e9:04 (try 1/3)
> [   73.128873] wlan0: send auth to 02:1a:11:f9:e9:04 (try 2/3)
> [   74.008857] wlan0: send auth to 02:1a:11:f9:e9:04 (try 3/3)
> [   74.969026] wlan0: authentication with 02:1a:11:f9:e9:04 timed out
> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="testssid"
> auth_failures=2 duration=23 reason=CONN_FAILED
>
> Regards,
>
> Tim

This turns out to be caused by interrupts not getting caught. The
target board used here is an IMX6 and its driver and/or PCIe host
controller apparently doesn't support both MSI and legacy interrupts
at the same time thus this breakage occured when the kernel started
enabling MSI by default for IMX6
(3ee803641e76bea76ec730c80dcc64739a9919ff).

Can ath9k can be enhanced to use MSI?

How many other cards/drivers out there don't support MSI?

Tim

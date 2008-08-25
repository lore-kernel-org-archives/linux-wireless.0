Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:39623 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYHYCLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 22:11:42 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1086134wri.5
        for <linux-wireless@vger.kernel.org>; Sun, 24 Aug 2008 19:11:41 -0700 (PDT)
Message-ID: <99175ee40808241911q60ac4c8fw83938bc152f47f3d@mail.gmail.com> (sfid-20080825_041149_806381_035A93A9)
Date: Mon, 25 Aug 2008 10:11:41 +0800
From: Chris <dchris@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: intel 4965agn 54Mbps on Linux but 130Mbps on Windows
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240808240726m539aa30am162b242f5d089d5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <99175ee40808240438o75c18f3ayd0c98db87a7c8561@mail.gmail.com>
	 <99175ee40808240450k7423691bu3ee81cbdba60acda@mail.gmail.com>
	 <1ba2fa240808240726m539aa30am162b242f5d089d5e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I decided to update to Ubuntu Intrepid since it uses a 2.6.26 kernel
with CONFIG_NETDEVICES_MULTIQUEUE enabled.

However, compat-wireless is no longer compiling with this kernel:

/home/chris/devel/mac80211/compat-wireless-2008-08-06/drivers/net/wireless/iwlwifi/iwl-led.c:
In function 'iwl_led_brightness_set':
/home/chris/devel/mac80211/compat-wireless-2008-08-06/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: 'led_type_str' undeclared (first use in this function)
/home/chris/devel/mac80211/compat-wireless-2008-08-06/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: (Each undeclared identifier is reported only once
/home/chris/devel/mac80211/compat-wireless-2008-08-06/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: for each function it appears in.)

And note that without using compat-wireless, my wifi LED is back on
but I'm still connecting in 802.11g mode.

Best regards,
Chris.

On Sun, Aug 24, 2008 at 10:26 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Sun, Aug 24, 2008 at 2:50 PM, Chris <dchris@gmail.com> wrote:
>>
>> Could it come from the fact that the kernel in Ubuntu Hardy does not
>> have CONFIG_NETDEVICES_MULTIQUEUE enabled ?
>>
>> I got this warning when I installed compat-wireless but I don't know
>> if it is required to get 802.11n working.
>>
> Definitely CONFIG_NETDEVICES_MULTIQUEUE must be enabled.
> HT rates are no reported in wireless-tools.
>
> Regards
> Tomas
>
>>
>> On 8/24/08, Chris <dchris@gmail.com> wrote:
>> > Hi,
>> >
>> > I'm using compat-wireless-2008-08-06.tar.bz2 on Ubuntu Hardy (kernel
>> > 2.6.24) for my intel 4965agn card in order to connect using 802.11n to
>> > my router (TL-WR841N from TP-LINK).
>> > Unfortunately, I'm only able to connect in 802.11g mode under Linux :
>> > $ iwconfig wlan1
>> > wlan1     IEEE 802.11abgn  ESSID:"chris"
>> >           Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1D:0F:33:7E:EC
>> >           Bit Rate=54 Mb/s   Tx-Power=15 dBm
>> >           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>> >           Power Management:off
>> >           Link Quality=100/100  Signal level:-30 dBm  Noise level=-95 dBm
>> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>> >
>> > $ sudo iwlist wlan1 scan
>> > wlan1     Scan completed :
>> >           Cell 01 - Address: 00:1D:0F:33:7E:EC
>> >                     ESSID:"chris"
>> >                     Mode:Master
>> >                     Channel:6
>> >                     Frequency:2.437 GHz (Channel 6)
>> >                     Quality=100/100  Signal level:-30 dBm  Noise level=-94
>> > dBm
>> >                     Encryption key:on
>> >                     IE: IEEE 802.11i/WPA2 Version 1
>> >                         Group Cipher : CCMP
>> >                         Pairwise Ciphers (1) : CCMP
>> >                         Authentication Suites (1) : PSK
>> >                     IE: Unknown:
>> > 2D1A4C1003FFFF000000000000000000000000000000000000000000
>> >                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
>> >                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
>> >                               48 Mb/s; 54 Mb/s
>> >                     Extra:tsf=000000003aefe580
>> >                     Extra: Last beacon: 12ms ago
>> >
>> > As you can see, no bit rate greater than 54Mbps is detected. I tried
>> > under Windows with latest intel driver and it connects at 130Mbps.
>> > Does the Linux driver support 802.11n? If so, do you have any
>> > suggestion to make this work here? I will be happy to provide any
>> > information you may require.
>> >
>> > In dmesg output, I simply get this:
>> > [   95.465080] wlan1: authenticate with AP 00:1d:0f:33:7e:ec
>> > [   95.467416] wlan1: authenticated
>> > [   95.467421] wlan1: associate with AP 00:1d:0f:33:7e:ec
>> > [   95.471491] wlan1: RX AssocResp from 00:1d:0f:33:7e:ec (capab=0x431
>> > status=0 aid=1)
>> > [   95.471496] wlan1: associated
>> > [   95.471533] wlan1 (WE) : Wireless Event too big (314)
>> >
>> > Best regards,
>> > Chris.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

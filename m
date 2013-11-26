Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52299 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3KZSgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 13:36:05 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so5647597wib.15
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 10:36:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385490243.7838.16.camel@dcbw.foobar.com>
References: <CAKnB8xgAVp+Ti597RN4_kgPLgXpW1JCr4SQaqfqCzy5A4=o3Ow@mail.gmail.com>
 <CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com>
 <5294E46C.40102@erley.org> <1385490243.7838.16.camel@dcbw.foobar.com>
From: matt emery <matt@x204.com>
Date: Tue, 26 Nov 2013 18:35:33 +0000
Message-ID: <CAKnB8xiLkDg2yQ9A2ujsUzGYD2OenGwqUnRMwA+=i=iWD85EHA@mail.gmail.com> (sfid-20131126_193611_347683_8D2DD191)
Subject: Re: Fwd: Intel 7260
To: Dan Williams <dcbw@redhat.com>
Cc: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw dev wlan0 info
Interface wlan0
    ifindex 3
    type managed
    wiphy 0


iw dev wlan0 link
Connected to 06:27:22:51:ed:be (on wlan0)
    SSID: capa
    freq: 2412
    RX: 10337197 bytes (45941 packets)
    TX: 8685983 bytes (25169 packets)
    signal: -49 dBm
    tx bitrate: 54.0 MBit/s

    bss flags:    short-preamble short-slot-time
    dtim period:    0
    beacon int:    100

Matthew Emery
07988 197 438



On 26 November 2013 18:24, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2013-11-26 at 12:11 -0600, Pat Erley wrote:
>> On 11/26/2013 06:28 AM, matt emery wrote:
>> > Hi,
>> >
>> > I hope you can help, I am having problems getting N with new Dual band
>> > wireless ac 7260 pci express half mini card, manufacturer code
>> > 7260.HMWWB
>> >
>> > lspci: 03:00.0 Network controller: Intel Corporation Device 08b1 (rev 73)
>> >
>> > Kernel: 3.12.0-031200-generic
>> >
>> > firmware: -rw-r--r-- 1 root root 682892 Nov 26 12:10 iwlwifi-7260-7.ucode
>> > from here; http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.0.7.0.tgz
>> >
>> > wlan0     IEEE 802.11abg  ESSID:"XXXX"
>> >            Mode:Managed  Frequency:2.412 GHz  Access Point: 06:XX:22:XX:ED:XX
>> >            Bit Rate=54 Mb/s   Tx-Power=16 dBm
>> >            Retry  long limit:7   RTS thr:off   Fragment thr:off
>>
>> >            Encryption key:off
>>
>> While I'm not certain about your AP or the 7260 driver, I believe
>> 802.11n technically requires WPA2 encryption.  Try turning that on and
>> testing again.
>
> This is true, but also Matt is using 'iwconfig', which does not support
> anything N-related because it uses the older WEXT kernel API.  It simply
> won't show 802.11n bitrates, nor will it show encryption details for
> WPA.
>
> Matt should be using 'iw' instead, with:
>
> iw dev wlan0 info
> iw dev wlan0 link
>
> Dan
>
>> >            Power Management:off
>> >            Link Quality=70/70  Signal level=-36 dBm
>> >            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>> >            Tx excessive retries:1  Invalid misc:27   Missed beacon:0
>> >
>> >
>> > Let me know if you need anything else.
>> >
>> > Thanks
>> >
>> > matt
>> >
>> > Matthew Emery
>> > 07988 197 438
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:51877 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbZCQTrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 15:47:42 -0400
Received: by ewy12 with SMTP id 12so179539ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 12:47:38 -0700 (PDT)
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Message-Id: <58D3A916-8548-4DEC-BEC6-09AFE4CEBCBD@icix.org> (sfid-20090317_204748_799657_5A8B649C)
From: Antonio Marques <froz@icix.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200903171031.41302.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Tue, 17 Mar 2009 19:38:32 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903161558.01070.IvDoorn@gmail.com> <A1AF7AF9-047F-41A1-829F-94F58821DB09@icix.org> <200903171031.41302.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 17, 2009, at 9:31 , Ivo van Doorn wrote:
> On Monday 16 March 2009, Antonio Marques wrote:
>> On Mar 16, 2009, at 14:58 , Ivo van Doorn wrote:
>>> On Monday 16 March 2009, Ant=F3nio Marques wrote:
>>>>
>>>> As requested, I have attached the output of the script run before =
=20
>>>> and
>>>> after
>>>> running 'iwlist mesh scan'. Unfortunately there seems to be no
>>>> change in
>>>> the output. I have also included the queue statistics as these do
>>>> change from
>>>> one state to the next. Any further pointers to help debug this? =20
>>>> I'll
>>>> gladly test
>>>> any patches that try to address this issue.
>>>
>>> The dumps aren't correct, I had forgotten to update the script on
>>> the website
>>> after some API for the rt2x00 debugfs interface changes recently.
>>> Attached is the correct patch.
>>>
>>> Ivo
>>> <rt2x00_regdump.sh>
>>
>> Fixed, new dumps are attached.
>
> Thanks for the dumps, the reason why the beaconing isn't working
> is (fortunately) very obvious from the registers point of view.
> The "generate beacons" bit is simply not enabled. However the reason
> why this bit has not been set escapes me. Could you apply the attache=
d
> patch? This will add extra debug messages to the driver to see when =20
> the
> beacon generation bit is set.
>
> Thanks,
>
> Ivo
> <rt73usb.beacon.diff>

Here are the relevant portions of the dmesg with the aforementioned
patch applied.

After interface creation and before 'iwlist mesh scan':

[108544.382327] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - =20
NIC: 0xffef
[108544.382332] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - =20
Led: 0xe000
[108544.382334] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - =20
RSSI OFFSET A: 0x0000
[108544.382561] phy3 -> rt2x00_set_chip: Info - Chipset detected - rt: =
=20
1300, rf: 0002, rev: 0002573a.
[108544.384587] phy3: Selected rate control algorithm 'minstrel'
[108544.385282] Registered led device: rt73usb-phy3::radio
[108544.385296] Registered led device: rt73usb-phy3::assoc
[108544.385309] Registered led device: rt73usb-phy3::quality
[108544.385995] usbcore: registered new interface driver rt73usb
[108565.147588] phy3 -> rt2x00lib_request_firmware: Info - Loading =20
firmware file 'rt73.bin'.
[108565.147595] rt73usb 2-5:1.0: firmware: requesting rt73.bin
[108565.152149] phy3 -> rt2x00lib_request_firmware: Info - Firmware =20
detected - version: 1.7.
[108565.174384] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE: =20
0x000d0000, READ: 0x000d0000
[108565.280398] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE: =20
0x000d0000, READ: 0x000d0000
[108565.385291] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE: =
=20
0x00040000, READ: 0x00040000
[108565.492687] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9 =20
WRITE: 0x001d0000, READ: 0x001d0000
[108565.603206] phy3 -> rt73usb_init_registers: Error - TXRX_CSR9 =20
WRITE: 0x00000000, READ: 0x00000000
[108565.742604] phy3 -> rt73usb_config_duration: Error - TXRX_CSR9 =20
WRITE: 0x00000640, READ: 0x00000640
[108565.863000] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue =20
0 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[108565.864999] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue =20
1 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[108565.866996] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue =20
2 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[108565.869001] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue =20
3 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.

After 'iwlist mesh scan':

[108700.626333] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE: =20
0x000d0640, READ: 0x000d0640
[108701.756022] cfg80211: Found new beacon on frequency: 2472 MHz (Ch =20
13) on phy3
[108701.756031] cfg80211: Enabling active scanning on frequency: 2472 =20
MHz (Ch 13) on phy3
[108701.756034] cfg80211: Enabling beaconing on frequency: 2472 MHz =20
(Ch 13) on phy3
[108701.756037] cfg80211: Enabling active scanning on frequency: 2472 =20
MHz (Ch 13) on phy0
[108701.756039] cfg80211: Enabling beaconing on frequency: 2472 MHz =20
(Ch 13) on phy0
[108702.178713] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE: =20
0x000d0640, READ: 0x000d0640
[108702.287605] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE: =
=20
0x00040640, READ: 0x00040640
[108702.395122] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9 =20
WRITE: 0x001d0640, READ: 0x001d0640

Hope this is useful.

Antonio Marques

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46154 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0FWRTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 13:19:53 -0400
Received: by fxm10 with SMTP id 10so3314062fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 10:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimcw-AVVFGbSJioJIcVw75tzUYCKt4plNMtQJr1@mail.gmail.com>
References: <AANLkTiljOFA7zY_wyP6p-4lCTHT_dhrEUuL2ktvvOsvc@mail.gmail.com>
	<AANLkTimcw-AVVFGbSJioJIcVw75tzUYCKt4plNMtQJr1@mail.gmail.com>
Date: Wed, 23 Jun 2010 20:19:51 +0300
Message-ID: <AANLkTinfByeC8ancmR7SuMDmPlJ_wc2yMC4-0QW964Y7@mail.gmail.com>
Subject: Re: 2.6.34 kernel + compat-wireless + Bluez-4.66 --- no Bluetooth
	devices
From: Andrei Moraru <andrei.moraru.n@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 23, 2010 at 7:30 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Jun 23, 2010 at 2:04 AM, Andrei Moraru
> <andrei.moraru.n@gmail.com> wrote:
>> Hello,
>>
>> I have a machine with Centos 5.4, kernel version 2.6.34, Bluez-4.66,
>> compat-wireless for 2.6.34 kernel version.
>>
>> The system knows about USB Bluetooth adapters
>>
>> [root@voip ~]# lsusb
>> Bus 002 Device 004: ID 1131:1001 Integrated System Solution Corp.
>> KY-BT100 Bluetooth Adapter
>> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 002 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd
>> Bluetooth Dongle (HCI mode)
>> Bus 002 Device 003: ID 0a12:0001 Cambridge Silicon Radio, Ltd
>> Bluetooth Dongle (HCI mode)
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>>
>> However, hciconfig shows no devices:
>>
>> [root@voip ~]# hciconfig -a
>> [root@voip ~]#
>>
>>
>> Also, hcitool dev
>>
>> [root@voip ~]# hcitool dev
>> Devices:
>>
>> the dmesg output about bluetooth shows
>>
>> Bluetooth: Core ver 2.15
>> NET: Registered protocol family 31
>> Bluetooth: HCI device and connection manager initialized
>> Bluetooth: HCI socket layer initialized
>> Bluetooth: L2CAP ver 2.14
>> Bluetooth: L2CAP socket layer initialized
>> Bluetooth: SCO (Voice Link) ver 0.6
>> Bluetooth: SCO socket layer initialized
>> Bluetooth: HIDP (Human Interface Emulation) ver 1.2
>> Bluetooth: RFCOMM TTY layer initialized
>> Bluetooth: RFCOMM socket layer initialized
>> Bluetooth: RFCOMM ver 1.11
>> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>> Bluetooth: BNEP filters: protocol multicast
>>
>>
>> Please suggest your opinions.
>
> dmesg looks good, repost to linux-bluetooth and show also the version
> of compat-wireless you used.
>
>  Luis
>

Thanks Luis.

I solved the issue with no BT devices on hciconfig -a
The problem was that 2.6.34 kernel was built without HCI USB support.
So, I have rebuilt it, rebooted, then the hciconfig -a  shows me BT
dongles.
The sugestion was made to me on #bluez-users on freenode

Ok, after detection of BT devices, i rebuilt the compat-wireless with
new kernel sources. When make btload was issued, then the dmesg output
was many lines similar to:

Jun 23 17:13:31 voip kernel: l2cap: Unknown symbol bt_sock_wait_state
Jun 23 17:13:31 voip kernel: l2cap: disagrees about version of symbol
bt_sock_register

The steps to get rid of that errors were:

1) be sure no bluetooth related file is in use:
   the command:
   lsof | grep blue*
   should return nothing
2) remove all Bluez-4.66 files (hciconfig, libbluetooth.so, etc)
3) rebuilt the Bluez-4.66
4) start the compat-wireless stack
   make btload

Now, the dmesg shows me clear output,

Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast

Thats all.

Andrei Moraru.

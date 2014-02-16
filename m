Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40370 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaBPRgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 12:36:54 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so1731128wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Feb 2014 09:36:53 -0800 (PST)
Message-ID: <5300F733.1040805@gmail.com> (sfid-20140216_183657_877648_9C651C8D)
Date: Sun, 16 Feb 2014 19:36:51 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: davidjon@xenontk.org
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tedd <tedd.an@intel.com>
Subject: Re: iwlwifi: Bluetooth and Wifi
References: <52FEFA0B.4000807@xenontk.org> <CANUX_P3yjxbOT6+-3GC7x_4GQiifa8OOFTUyK-EBwwmS76-GNw@mail.gmail.com> <5300E683.3090302@xenontk.org>
In-Reply-To: <5300E683.3090302@xenontk.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/16/2014 06:25 PM, David John wrote:
> On Sunday 16 February 2014 12:07 PM, Emmanuel Grumbach wrote:
>>> Your patch "iwlwifi: mvm: BT Coex - disable BT when TXing probe request
>>> in scan" fixed wifi dropping on my 7260 with scan time outs but now my
>>> Bluetooth mouse freezes and unfreezes as it gets re-detected every few
>>> minutes (3.14-rc2+):
>>
>> All this patches does is to send the probe request of the scan in High
>> Prio so that it will take precedence over BT traffic in case of
>> collision. Since there shouldn't be that many probe request, I am
>> surprised that it kills your BT connection.
>> Also - are you 100% positive that this patch changed the behavior?
>> Have you tried to revert it and see what happens?
>> Also - what was the behavior before? What do you mean when you say
>> that it fixed your "wifi dropping with scan times out".
>> Can I have a log of this?
>>
> 
> With BT on, I used to get Wifi drops with messages similar to the following:
> 
> iwlwifi 0000    3:00.0: Error sending SCAN_REQUEST_CMD: time out after
> 2000ms.
> iwlwifi 0000    3:00.0: Current CMD queue read_ptr 125 write_ptr 127
> iwlwifi 0000    3:00.0: Scan failed! status 0x1 ret -110

Huh... This should *never* happen. We had such an issue but it was very
rare and should be fixed in 3.14:

commit b9439491055a18ee075614139abadfd74c1b887f

    iwlwifi: pcie: keep the NIC awake when commands are in flight

> 
> The only way to recover was to reload the iwlmvm module. I booted up the
> older stock Fedora 3.12 kernel I was using but couldn't reproduce this
> issue (with debug) even after a day of use, both Bluetooth and Wifi were
> fine. I'll try this again later.
> 
> I've attached debug dmesg for the current BT kill problem from
> 3.14-rc2+. Now I'm not sure if the patch I've referenced is the culprit,
> I'll try and narrow it down to a commit later when I have the time.

Actually, I am pretty sure it isn't - since thanks to the log you enable
we can clearly see that BT begins to complain when we are *not*
scanning. I just picked up one example:

[ 3723.246575] iwlwifi 0000:01:00.0: U iwl_mvm_rx_scan_complete Scan
complete: status=0x1 scanned channels=25

<<== HERE SCAN IS FINISHED ==>>

[ 3768.683762] usb 2-6: USB disconnect, device number 7
[ 3769.179405] usb 2-6: new full-speed USB device number 9 using xhci_hcd
[ 3769.344503] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
[ 3769.344514] usb 2-6: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[ 3769.360980] Bluetooth: hci0: read Intel version: 370710018002030d33
[ 3769.360988] Bluetooth: hci0: Intel device is already patched. patch
num: 33
[ 3794.222419] hid-generic 0005:046D:B010.0004: unknown main item tag 0x0
[ 3794.257065] input: Bluetooth Mouse M557 as
/devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0004/input/input16
[ 3794.257485] hid-generic 0005:046D:B010.0004: input,hidraw1: BLUETOOTH
HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22

<<== HERE NEW SCAN STARTS ==>>

[ 3838.185707] iwlwifi 0000:01:00.0: U iwl_mvm_scan_request Handling
mac80211 scan request

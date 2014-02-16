Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51479 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaBPGhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 01:37:13 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so10540270lbj.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 22:37:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FEFA0B.4000807@xenontk.org>
References: <52FEFA0B.4000807@xenontk.org>
Date: Sun, 16 Feb 2014 08:37:09 +0200
Message-ID: <CANUX_P3yjxbOT6+-3GC7x_4GQiifa8OOFTUyK-EBwwmS76-GNw@mail.gmail.com> (sfid-20140216_073745_974000_30CB89C4)
Subject: Re: iwlwifi: Bluetooth and Wifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: davidjon@xenontk.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tedd <tedd.an@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Your patch "iwlwifi: mvm: BT Coex - disable BT when TXing probe request
> in scan" fixed wifi dropping on my 7260 with scan time outs but now my
> Bluetooth mouse freezes and unfreezes as it gets re-detected every few
> minutes (3.14-rc2+):

All this patches does is to send the probe request of the scan in High
Prio so that it will take precedence over BT traffic in case of
collision. Since there shouldn't be that many probe request, I am
surprised that it kills your BT connection.
Also - are you 100% positive that this patch changed the behavior?
Have you tried to revert it and see what happens?
Also - what was the behavior before? What do you mean when you say
that it fixed your "wifi dropping with scan times out".
Can I have a log of this?

>
> sb 2-6: USB disconnect, device number 9
> [ 2204.013399] usb 2-6: new full-speed USB device number 11 using xhci_hcd
> [ 2204.178555] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
> [ 2204.178565] usb 2-6: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [ 2204.194476] Bluetooth: hci0: read Intel version: 370710018002030d33
> [ 2204.194484] Bluetooth: hci0: Intel device is already patched. patch
> num: 33
> [ 2226.561140] hid-generic 0005:046D:B010.0006: unknown main item tag 0x0
> [ 2226.569469] input: Bluetooth Mouse M557 as
> /devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0006/input/input18
> [ 2226.569853] hid-generic 0005:046D:B010.0006: input,hidraw1: BLUETOOTH
> HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22
> [ 2755.209616] usb 2-6: USB disconnect, device number 11
> [ 2755.705285] usb 2-6: new full-speed USB device number 13 using xhci_hcd
> [ 2755.870458] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
> [ 2755.870468] usb 2-6: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [ 2755.886722] Bluetooth: hci0: read Intel version: 370710018002030d33
> [ 2755.886729] Bluetooth: hci0: Intel device is already patched. patch
> num: 33
> [ 2780.725691] hid-generic 0005:046D:B010.0007: unknown main item tag 0x0
> [ 2780.759131] input: Bluetooth Mouse M557 as
> /devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0007/input/input19
> [ 2780.759532] hid-generic 0005:046D:B010.0007: input,hidraw1: BLUETOOTH
> HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22
> [ 9151.434602] usb 2-6: USB disconnect, device number 13
> [ 9151.930271] usb 2-6: new full-speed USB device number 15 using xhci_hcd
> [ 9152.095371] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
> [ 9152.095381] usb 2-6: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [ 9152.111270] Bluetooth: hci0: read Intel version: 370710018002030d33
> [ 9152.111278] Bluetooth: hci0: Intel device is already patched. patch
> num: 33
> [ 9178.208386] hid-generic 0005:046D:B010.0008: unknown main item tag 0x0
> [ 9178.239390] input: Bluetooth Mouse M557 as
> /devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0008/input/input20
> [ 9178.239751] hid-generic 0005:046D:B010.0008: input,hidraw1: BLUETOOTH
> HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22
>
> Iwlwifi:
>
> [   19.627252] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
> [   19.627409] iwlwifi 0000:01:00.0: irq 62 for MSI/MSI-X
> [   19.629897] iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0
> op_mode iwlmvm
> [   19.843619] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band
> Wireless N 7260, REV=0x144
> [   19.843666] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [   19.843883] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [   21.332796] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [   21.333012] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [   28.734048] iwlwifi 0000:01:00.0 wlp1s0: disabling HT as WMM/QoS is
> not supported by the AP
> [   28.734055] iwlwifi 0000:01:00.0 wlp1s0: disabling VHT as WMM/QoS is
> not supported by the AP

Can you please run with iwlwifi module parameter debug=0x800. This
will give us information about the timing of the scan.
I'd like to see if the BT issues you face happen when we scan.

>
> Is there a better fix in the works? Any workaround? 802.11g performance
> also looks to be subjectively poorer with Bluetooth on than without.
>

Is this also a regression?

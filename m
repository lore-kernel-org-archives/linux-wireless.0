Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpauth.net4india.com ([118.67.248.47]:43777 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaBOF4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 00:56:45 -0500
Message-ID: <52FEFA0B.4000807@xenontk.org> (sfid-20140215_065712_172040_D95A4389)
Date: Sat, 15 Feb 2014 10:54:27 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
MIME-Version: 1.0
To: emmanuel.grumbach@intel.com
CC: linux-wireless@vger.kernel.org
Subject: iwlwifi: Bluetooth and Wifi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

Your patch "iwlwifi: mvm: BT Coex - disable BT when TXing probe request
in scan" fixed wifi dropping on my 7260 with scan time outs but now my
Bluetooth mouse freezes and unfreezes as it gets re-detected every few
minutes (3.14-rc2+):

sb 2-6: USB disconnect, device number 9
[ 2204.013399] usb 2-6: new full-speed USB device number 11 using xhci_hcd
[ 2204.178555] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
[ 2204.178565] usb 2-6: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[ 2204.194476] Bluetooth: hci0: read Intel version: 370710018002030d33
[ 2204.194484] Bluetooth: hci0: Intel device is already patched. patch
num: 33
[ 2226.561140] hid-generic 0005:046D:B010.0006: unknown main item tag 0x0
[ 2226.569469] input: Bluetooth Mouse M557 as
/devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0006/input/input18
[ 2226.569853] hid-generic 0005:046D:B010.0006: input,hidraw1: BLUETOOTH
HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22
[ 2755.209616] usb 2-6: USB disconnect, device number 11
[ 2755.705285] usb 2-6: new full-speed USB device number 13 using xhci_hcd
[ 2755.870458] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
[ 2755.870468] usb 2-6: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[ 2755.886722] Bluetooth: hci0: read Intel version: 370710018002030d33
[ 2755.886729] Bluetooth: hci0: Intel device is already patched. patch
num: 33
[ 2780.725691] hid-generic 0005:046D:B010.0007: unknown main item tag 0x0
[ 2780.759131] input: Bluetooth Mouse M557 as
/devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0007/input/input19
[ 2780.759532] hid-generic 0005:046D:B010.0007: input,hidraw1: BLUETOOTH
HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22
[ 9151.434602] usb 2-6: USB disconnect, device number 13
[ 9151.930271] usb 2-6: new full-speed USB device number 15 using xhci_hcd
[ 9152.095371] usb 2-6: New USB device found, idVendor=8087, idProduct=07dc
[ 9152.095381] usb 2-6: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[ 9152.111270] Bluetooth: hci0: read Intel version: 370710018002030d33
[ 9152.111278] Bluetooth: hci0: Intel device is already patched. patch
num: 33
[ 9178.208386] hid-generic 0005:046D:B010.0008: unknown main item tag 0x0
[ 9178.239390] input: Bluetooth Mouse M557 as
/devices/pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/bluetooth/hci0/hci0:256/0005:046D:B010.0008/input/input20
[ 9178.239751] hid-generic 0005:046D:B010.0008: input,hidraw1: BLUETOOTH
HID v10.00 Mouse [Bluetooth Mouse M557] on 5c:51:4f:44:52:22

Iwlwifi:

[   19.627252] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
[   19.627409] iwlwifi 0000:01:00.0: irq 62 for MSI/MSI-X
[   19.629897] iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0
op_mode iwlmvm
[   19.843619] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band
Wireless N 7260, REV=0x144
[   19.843666] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   19.843883] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   21.332796] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   21.333012] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   28.734048] iwlwifi 0000:01:00.0 wlp1s0: disabling HT as WMM/QoS is
not supported by the AP
[   28.734055] iwlwifi 0000:01:00.0 wlp1s0: disabling VHT as WMM/QoS is
not supported by the AP

Is there a better fix in the works? Any workaround? 802.11g performance
also looks to be subjectively poorer with Bluetooth on than without.

Regards,
David.

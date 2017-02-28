Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33840 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdB1UKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 15:10:11 -0500
Received: by mail-qk0-f172.google.com with SMTP id s186so36412862qkb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 12:10:11 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JTQvNC40YLRgNC40Lk=?= <nrndda@gmail.com>
Date: Tue, 28 Feb 2017 20:41:52 +0300
Message-ID: <CAKJ_e7kwp-yqdjtrPULbm9ppoNZcp_06eCzD=6KUKcC4FQ2F=w@mail.gmail.com> (sfid-20170228_211032_018410_A1DF92B1)
Subject: btqca Bluetooth: hci1: Frame reassembly failed
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have Dell Venue 11 Pro with "Dell Wireless 1538", which contains
Bluetooth chip AR3002.

In ACPI dsdt tables:
            Device (BTH0)
            {
                Name (_HID, "DLAC3002" /* Qualcomm Atheros Bluetooth
UART Transport */)  // _HID: Hardware ID
                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    Zero,
                    Zero
                })
                Name (_S4W, 0x02)  // _S4W: S4 Device Wake State
                Name (_S0W, 0x02)  // _S0W: S0 Device Wake State
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (UBUF, ResourceTemplate ()
                    {
                        UartSerialBus (0x0001C200, DataBitsEight, StopBitsOne,
                            0xFC, LittleEndian, ParityTypeNone,
FlowControlHardware,
                            0x0020, 0x0020, "\\_SB.URT1",
                            0x00, ResourceConsumer, ,
                            )
                        Interrupt (ResourceConsumer, Edge, ActiveHigh,
ExclusiveAndWake, ,, )
                        {
                            0x00000046,
                        }
                        GpioIo (Exclusive, PullDefault, 0x0000,
0x0000, IoRestrictionOutputOnly,
                            "\\_SB.GPO0", 0x00, ResourceConsumer, ,
                            )
                            {   // Pin list
                                0x0034
                            }
                        GpioIo (Exclusive, PullDefault, 0x0000,
0x0000, IoRestrictionOutputOnly,
                            "\\_SB.GPO0", 0x00, ResourceConsumer, ,
                            )
                            {   // Pin list
                                0x0035
                            }
                    })
                    Return (UBUF) /* \_SB_.URT1.BTH0._CRS.UBUF */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

In logs: kernel: 80860F0A:00: ttyS1 at MMIO 0x9094d000 (irq = 191,
base_baud = 2764800) is a 16550A

btattach -B /dev/ttyS1 -P qca:
kernel: Bluetooth: hci1: ROME setup
kernel: Bluetooth: hci1: Set UART speed to 3000000
kernel: Bluetooth: hci1: Frame reassembly failed (-84)
kernel: Bluetooth: hci1 command 0xfc00 tx timeout
kernel: Bluetooth: hci1: Failed to read version of ROME (-110)
kernel: Bluetooth: hci1: Failed to get version 0xffffff92

But windows drivers state that 115200 baudrate must be used. Also only
qca driver protocol gives feedback from chip, all others show no RX
packets in hciconfig.
hci1:   Type: Primary  Bus: UART
        BD Address: 00:00:00:00:00:00  ACL MTU: 0:0  SCO MTU: 0:0
        DOWN
        RX bytes:4 acl:0 sco:0 events:0 errors:0
        TX bytes:10 acl:0 sco:0 commands:2 errors:0

Is this speed choose bug or there is another unsupported part?

Tried switch GPIOs but with no luck, no difference.

Thanks for helping.

Sincerely,

Dmitry Derevyanko.

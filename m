Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from krieglstein.org ([176.28.13.145]:37436 "EHLO krieglstein.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbeAVRAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 12:00:42 -0500
From: Tim Sander <tim@krieglstein.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [linux-nfc] st95hf driver not working with neard 0.16
Date: Mon, 22 Jan 2018 17:51:51 +0100
Message-ID: <6803968.AFljYLBCnO@dabox> (sfid-20180122_180047_553287_E3EB6277)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I am currently on a arm-v7a platform (Intel/Altera DE0_NANO_SOC) and i have
connected a st95hf chip via spi to the board. When using nfctool with 4.15-rc9
or 4.14.12 kernel the kernel crashes. I have seen that there is a patchset which
at least works for tags but crashes if i put a x-nucleo-nfc04a1 nfc eeprom against
the reader: https://www.spinics.net/lists/linux-wireless/msg161940.html
I have verified with this patchset that my st95hf board seems to be properly 
connected to my board. I would also test a st25r3911b chip. Unfortunatly it 
seems there is no driver to this board.

The coresponding messages on startup
look like this:
spi_altera ff250000.spif0: registered master spi0
spi spi0.0: setup mode 0, 8 bits/w, 1000000 Hz max --> 0
spi_altera ff250000.spif0: registered child spi0.0
spi_altera ff250000.spif0: base 21935e98, irq 42
nfc: nfc_init: NFC Core ver 0.1
NET: Registered protocol family 39
st95hf spi0.0: NFC: ST95HF driver probe called.

I have neard 0.16 running on the device:
nfctool -d nfc0 -p initator
st95hf spi0.0: st95hf error from st95hf_spi_recv_response(), err = 0xe
nfc nfc0: type a demogain cmd, err = 0xfffffffb
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
Unhandled fault: page domain fault (0x01b) at 0x76d97a38
INFO: rcu_preempt detected stalls on CPUs/tasks:
        0-...!: (0 ticks this GP) idle=9c6/140000000000000/0 softirq=1488/1488 fqs=0 
        (detected by 1, t=2130 jiffies, g=-24, c=-25, q=24)
Sending NMI from CPU 1 to CPUs 0:
Unhandled fault: page domain fault (0x01b) at 0x0001437c
Unable to handle kernel paging request at virtual address 7f00c000
rcu_preempt kthread starved for 2130 jiffies! g4294967272 c4294967271 f0x0 RCU_GP_WAIT_FQS(3) ->state=0x402 ->cpu=0
rcu_preempt     I    0     8      2 0x00001000
[<8079add4>] (__schedule) from [<8079b2d0>] (schedule+0x58/0xb8)
[<8079b2d0>] (schedule) from [<8079f19c>] (schedule_timeout+0x1dc/0x458)
[<8079f19c>] (schedule_timeout) from [<8017f530>] (rcu_gp_kthread+0x6e0/0xaf8)
[<8017f530>] (rcu_gp_kthread) from [<801424ac>] (kthread+0x138/0x168)
[<801424ac>] (kthread) from [<801082b4>] (ret_from_fork+0x14/0x20)

The output of the 4.14.12-rt10 kernel looks like this:
nfctool -d nfc0 -p Initiate
------------[ cut here ]------------
WARNING: CPU: 0 PID: 129 at drivers/nfc/st95hf/core.c:809 st95hf_irq_thread_handler+0x108/0x3b8 [st95hf]
** 142 printk messages dropped ** Control: 10c5387d  Table: 1dd5404a  DAC: 00000051
** 979 printk messages dropped ** [<8010cde4>] (die) from [<801163a8>] (__do_kernel_fault.part.0+0x74/0x84)
[<801163a8>] (__do_kernel_fault.part.0) from [<80116188>] (do_page_fault+0x390/0x3a0)
[<80116188>] (do_page_fault) from [<80101288>] (do_DataAbort+0x48/0xc8)
[<80101288>] (do_DataAbort) from [<8010d7b8>] (__dabt_svc+0x58/0x80)
Exception stack(0xff7f1f80 to 0xff7f1fc8)
1f80: 80b7e58c 00000000 00000000 9e87ba00 00000000 00000000 00000000 00000000
1fa0: 00000000 80b73674 9f6e2205 00000000 9eae3cb8 ff7f1fd4 80797274 8010d76c
1fc0: 600f0193 ffffffff
[<8010d7b8>] (__dabt_svc) from [<8010d76c>] (__dabt_svc+0xc/0x80)
Code: e1a002a0 e0811100 f591f000 e1a03312 (e1912f9f) 
---[ end trace 000000000000000e ]---
Kernel panic - not syncing: Fatal exception in interrupt
Unable to handle kernel paging request at virtual address 136d5cc4
pgd = 80004000
[136d5cc4] *pgd=00000000
Internal error: Oops: 5 [#13] PREEMPT SMP ARM
Modules linked in: st95hf nfc_digital crc_itu_t crc_ccitt nfc spi_altera gpio_altera
CPU: -1619872384 PID: -1619855404 Comm: ��r� Tainted: G      D W       4.14.12-rt10 #1
Hardware name: Altera SOCFPGA
task: 9f72f500 task.stack: 0000002c
PC is at _clear_bit+0x20/0x38
LR is at smp_send_stop+0x38/0xc0
pc : [<807791b0>]    lr : [<8010fb8c>]    psr: 600f0193
sp : ff7f0610  ip : 00000000  fp : ff7f0634
r10: 9f72f500  r9 : 80b0b08c  r8 : 80b7e5dc
r7 : 600f0193  r6 : 00000005  r5 : 80b064a8  r4 : ff7f0614
r3 : 00000001  r2 : 00000001  r1 : 136d5cc4  r0 : 04fb95ac
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 1dd5404a  DAC: 00000051
Process ��r� (pid: -1619855404, stack limit = 0x00000244)
Stack: (0xff7f0610 to 0x0000202c)
[<807791b0>] (_clear_bit) from [<8010fb8c>] (smp_send_stop+0x38/0xc0)
[<8010fb8c>] (smp_send_stop) from [<80121088>] (panic+0xfc/0x278)
[<80121088>] (panic) from [<8010cde4>] (die+0x2fc/0x300)
[<8010cde4>] (die) from [<801163a8>] (__do_kernel_fault.part.0+0x74/0x84)
[<801163a8>] (__do_kernel_fault.part.0) from [<80116188>] (do_page_fault+0x390/0x3a0)
[<80116188>] (do_page_fault) from [<80116330>] (do_translation_fault+0xd0/0xd4)
[<80116330>] (do_translation_fault) from [<80101288>] (do_DataAbort+0x48/0xc8)
[<80101288>] (do_DataAbort) from [<8010d7b8>] (__dabt_svc+0x58/0x80)
Exception stack(0xff7f07e8 to 0xff7f0830)
07e0:                   04fb95ac 136d5eec 00000001 00000001 ff7f083c 80b064a8
0800: 00000005 600f0193 80b7e5dc 80b0b08c 9f72f500 ff7f085c 00000000 ff7f0838
0820: 8010fb8c 807791b0 600f0193 ffffffff
[<8010d7b8>] (__dabt_svc) from [<807791b0>] (_clear_bit+0x20/0x38)
[<807791b0>] (_clear_bit) from [<8010fb8c>] (smp_send_stop+0x38/0xc0)
[<8010fb8c>] (smp_send_stop) from [<80121088>] (panic+0xfc/0x278)
[<80121088>] (panic) from [<8010cde4>] (die+0x2fc/0x300)
[<8010cde4>] (die) from [<801163a8>] (__do_kernel_fault.part.0+0x74/0x84)
[<801163a8>] (__do_kernel_fault.part.0) from [<80116188>] (do_page_fault+0x390/0x3a0)
[<80116188>] (do_page_fault) from [<80116330>] (do_translation_fault+0xd0/0xd4)
[<80116330>] (do_translation_fault) from [<80101288>] (do_DataAbort+0x48/0xc8)
[<80101288>] (do_DataAbort) from [<8010d7b8>] (__dabt_svc+0x58/0x80)
Exception stack(0xff7f0a10 to 0xff7f0a58)

When using the st,stnfc driver linked at the beginning it works with tags:
nfctool -d nfc0 -p initiate
Start polling on nfc0 as initiator

Targets found for nfc0
  Tags: [ tag3 ]
  Devices: [ ]

But as soon as i put a X-NUCLEO-NFC04A1 board on the st95hf reader i get the following
output:
skbuff: skb_over_panic: text:7f05c48c len:514 put:514 head:9dd26e00 data:9dd26e01 tail:0x9dd27003 end:0x9dd26f40 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:106!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
Modules linked in: nfcst_spi nfcst nfc_digital crc_itu_t crc_ccitt nfc gpio_altera spi_altera
CPU: 1 PID: 120 Comm: irq/43-nfcst Not tainted 4.14.12-rt10-gc8ea1c21435e #1
Hardware name: Altera SOCFPGA
task: 9e8e4880 task.stack: 9dcfc000
PC is at skb_panic+0x70/0x74
LR is at preempt_count_sub+0xcc/0x13c
pc : [<805e889c>]    lr : [<8014c288>]    psr: 60000013
sp : 9dcfdd00  ip : 9dcfdba8  fp : 9dcfdd2c
r10: 9e803000  r9 : 00000202  r8 : 00000202
r7 : 8084a770  r6 : 9dd26e00  r5 : 9dd26e01  r4 : 9dd27003
r3 : 00001000  r2 : 00001000  r1 : 80170408  r0 : 0000007b
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 1eb6804a  DAC: 00000051
Process irq/43-nfcst (pid: 120, stack limit = 0x9dcfc218)
Stack: (0x9dcfdd00 to 0x9dcfe000)
dd00: 00000202 9dd26e00 9dd26e01 9dd27003 9dd26f40 80922488 9dcfdd34 9dd26f40
dd20: 9dcfdd4c 9dcfdd30 805e9d98 805e8838 9dcfdd5c 9dd26e03 9eba99c0 9dcfdd8c
dd40: 9dcfdeec 9dcfdd50 7f05c48c 805e9d44 79f1878c 00000002 021a1584 9dcfddc8
dd60: 9dcfddc8 9e803000 00000000 80507834 00000000 00000200 00000200 00000000
dd80: 9dcfdd80 9dcfdd80 00000000 9dcfdd8c 9dcfdd8c 00000000 9dd26e03 00000200
dda0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
ddc0: 00000810 000f4240 9dcfdd5c 9dcfdd5c 00000000 9dd26e02 00000001 00000000
dde0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000811
de00: 000f4240 9dcfdd5c 9dcfdd5c 00000000 00000000 00000000 00000000 00000000
de20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
de40: 00000000 00000000 9dcfdd5b 00000000 00000001 00000000 00000000 00000000
de60: 00000000 00000000 00000000 00000000 00000000 00000802 000f4240 9dcfdeb8
de80: 9dcfdd5c 00000000 9dd26e01 00000001 00000000 00000000 00000000 00000000
dea0: 00000000 00000000 00000000 00000000 00000811 000f4240 9dcfdd5c 9dcfde7c
dec0: 00000001 9ea2ec10 9ea2ec2c 9eba99c0 00000001 9e8fb800 9eb5ebc0 80174abc
dee0: 9dcfdf0c 9dcfdef0 7f05c5c0 7f05c294 9eb5ebc0 9e8fb800 00000000 00000001
df00: 9dcfdf2c 9dcfdf10 80174ae8 7f05c570 9eb5ebe4 9dcfc000 00000000 00000001
df20: 9dcfdf7c 9dcfdf30 80174e10 80174ac8 80b7323f 9eb5ebc0 9eb5ebc0 00000000
df40: 9dcfc000 9eb5ebe4 00000000 80174bd0 9dcfc000 9eb5ec40 00000000 9eb5eb80
df60: 9eb5ebc0 80174cb4 9ea77b58 9eb5ec5c 9dcfdfac 9dcfdf80 801437cc 80174cc0
df80: 9dcfc000 9eb5eb80 80143690 00000000 00000000 00000000 00000000 00000000
dfa0: 00000000 9dcfdfb0 80107f1c 8014369c 00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 10090002 1000400c
[<805e889c>] (skb_panic) from [<805e9d98>] (skb_put+0x60/0x64)
[<805e9d98>] (skb_put) from [<7f05c48c>] (nfcst_spi_recv_resp+0x204/0x2dc [nfcst_spi])
[<7f05c48c>] (nfcst_spi_recv_resp [nfcst_spi]) from [<7f05c5c0>] (nfcst_spi_irq_thread_handler+0x5c/0xb0 [nfcst_spi])
[<7f05c5c0>] (nfcst_spi_irq_thread_handler [nfcst_spi]) from [<80174ae8>] (irq_thread_fn+0x2c/0x64)
[<80174ae8>] (irq_thread_fn) from [<80174e10>] (irq_thread+0x15c/0x240)
[<80174e10>] (irq_thread) from [<801437cc>] (kthread+0x13c/0x16c)
[<801437cc>] (kthread) from [<80107f1c>] (ret_from_fork+0x14/0x38)
Code: e58d5008 e58d400c e58de010 ebee254f (e7f001f2) 
---[ end trace 0000000000000002 ]---

Please CC as i am not subscribed. This is my first encounter with the nfc framework!

Best regards
Tim

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34489 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbbHFR1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 13:27:36 -0400
Received: by iodb91 with SMTP id b91so28218481iod.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 10:27:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150806161958.GA20514@localhost>
References: <CANR9swOiEVT6PvKv0V1Ytwm0GsN0_2HXqFpdmGAPzFoQG5T2Cg@mail.gmail.com>
	<20150806161958.GA20514@localhost>
Date: Thu, 6 Aug 2015 11:27:35 -0600
Message-ID: <CANR9swMSvdSOcC+HyYp2JbHBh8m2puZb04NpVafHuKmHkxWSqA@mail.gmail.com> (sfid-20150806_192739_888208_061FDF74)
Subject: Re: lenovo t400 atheros ar242x ath5k bug
From: Brady Lyles <lyles.brady@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sudo lspci -vnn

00:00.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit
Network Connection [8086:10f5] (rev 03)
    Subsystem: Lenovo Device [17aa:20ee]
    Flags: bus master, fast devsel, latency 0, IRQ 38
    Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
    Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
    I/O ports at 1840 [size=32]
    Capabilities: [c8] Power Management version 2
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
    Capabilities: [e0] PCI Advanced Features
    Kernel driver in use: e1000e
    Kernel modules: e1000e

00:01.0 Ethernet controller [0200]: Qualcomm Atheros AR242x / AR542x
Wireless Network Adapter (PCI-Express) [168c:001c] (rev 01)
    Subsystem: Qualcomm Atheros Device [168c:0035]
    Flags: bus master, fast devsel, latency 0, IRQ 39
    Memory at f4300000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 2
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
    Capabilities: [60] Express Legacy Endpoint, MSI 00
    Capabilities: [90] MSI-X: Enable- Count=1 Masked-
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel
    Kernel driver in use: ath5k
    Kernel modules: ath5k

On Thu, Aug 6, 2015 at 10:19 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Aug 06, 2015 at 10:06:07AM -0600, Brady Lyles wrote:
>> Hello all,
>> I was recommended by the qubes-users list to ask here about an ath5k bug.
>> It looks like my fedora 20 networking virtual machine (netvm) is
>> trying to load the ath5k driver for the qualcomm atheros ar242x wifi
>> module in my lenovo t400, but is choking.
>> Here's an excerpt from netvm dmesg:
>>
>> [    5.399092] ath5k 0000:00:01.0: Xen PCI mapped GSI17 to IRQ39
>> [    5.399311] ath5k 0000:00:01.0: registered as 'phy0'
>> [    5.401297] PGD 12536067 PUD 12537067 PMD 126f5067 PTE 8010000000000464
>> [    5.401309] Oops: 0003 [#1] SMP
>> [    5.401315] Modules linked in: ath5k(+) ath mac80211 cfg80211
>> rfkill e1000e ptp pps_core pcspkr coretemp hwmon dummy_hcd nfsd
>> udc_core usbcore auth_rpcgss oid_registry usb_common exportfs nfs_acl
>> lockd sunrpc u2mfn(O) xen_blkback binfmt_misc ext4 crc16 jbd2
>> dm_snapshot xen_blkfront autofs4
>> [    5.401356] CPU: 1 PID: 353 Comm: systemd-udevd Tainted: G
>>  O 3.12.40-1.pvops.qubes.x86_64 #1
>
> My wild guess (not being too familiar with qubes) is that passthrough is not
> working properly -- this:
>
>> [    5.401276] BUG: unable to handle kernel paging request at ffffc90000900014
>> [    5.401287] IP: [<ffffffff81268928>] iowrite32+0x38/0x40
>
> ...looks like a pci write to an unusual address.
>
> What does output of lspci -vnn look like, run as root in the guest?
>
> --
> Bob Copeland %% http://bobcopeland.com/

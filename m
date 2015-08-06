Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37004 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbbHFQUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 12:20:23 -0400
Received: by igbpg9 with SMTP id pg9so14923138igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 09:20:22 -0700 (PDT)
Date: Thu, 6 Aug 2015 12:19:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Brady Lyles <lyles.brady@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: lenovo t400 atheros ar242x ath5k bug
Message-ID: <20150806161958.GA20514@localhost> (sfid-20150806_182026_314288_9868EB6A)
References: <CANR9swOiEVT6PvKv0V1Ytwm0GsN0_2HXqFpdmGAPzFoQG5T2Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANR9swOiEVT6PvKv0V1Ytwm0GsN0_2HXqFpdmGAPzFoQG5T2Cg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 06, 2015 at 10:06:07AM -0600, Brady Lyles wrote:
> Hello all,
> I was recommended by the qubes-users list to ask here about an ath5k bug.
> It looks like my fedora 20 networking virtual machine (netvm) is
> trying to load the ath5k driver for the qualcomm atheros ar242x wifi
> module in my lenovo t400, but is choking.
> Here's an excerpt from netvm dmesg:
> 
> [    5.399092] ath5k 0000:00:01.0: Xen PCI mapped GSI17 to IRQ39
> [    5.399311] ath5k 0000:00:01.0: registered as 'phy0'
> [    5.401297] PGD 12536067 PUD 12537067 PMD 126f5067 PTE 8010000000000464
> [    5.401309] Oops: 0003 [#1] SMP
> [    5.401315] Modules linked in: ath5k(+) ath mac80211 cfg80211
> rfkill e1000e ptp pps_core pcspkr coretemp hwmon dummy_hcd nfsd
> udc_core usbcore auth_rpcgss oid_registry usb_common exportfs nfs_acl
> lockd sunrpc u2mfn(O) xen_blkback binfmt_misc ext4 crc16 jbd2
> dm_snapshot xen_blkfront autofs4
> [    5.401356] CPU: 1 PID: 353 Comm: systemd-udevd Tainted: G
>  O 3.12.40-1.pvops.qubes.x86_64 #1

My wild guess (not being too familiar with qubes) is that passthrough is not
working properly -- this:

> [    5.401276] BUG: unable to handle kernel paging request at ffffc90000900014
> [    5.401287] IP: [<ffffffff81268928>] iowrite32+0x38/0x40

...looks like a pci write to an unusual address.

What does output of lspci -vnn look like, run as root in the guest?

-- 
Bob Copeland %% http://bobcopeland.com/

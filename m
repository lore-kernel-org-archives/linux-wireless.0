Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51508 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0LDHCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 02:02:31 -0500
Received: by qwb7 with SMTP id 7so10452233qwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 23:02:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101202195502.GE2358@tuxdriver.com>
References: <1193716.1141291281829918.JavaMail.wlan@CHBU500181>
	<25197466.1341291282005411.JavaMail.wlan@CHBU500181>
	<20101202195502.GE2358@tuxdriver.com>
Date: Sat, 4 Dec 2010 08:02:30 +0100
Message-ID: <AANLkTi=VzVHeoHEHUdL68WC2H84KHtnWG3k1F1sZnWXx@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] ath5k: Add AHB support
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wojciech Dubowik <dubowoj@neratec.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@venema.h4ckr.net, mickflemm@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 8:55 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Dec 02, 2010 at 10:26:46AM +0100, Wojciech Dubowik wrote:
>>
>> This series of patches implements AHB bus support for ath5k driver.
>
> For the record, your patches arrived in my inbox out of order and would
> not apply in the order in which they arrived.  This nearly caused me to
> write you a nastygram, but instead I discovered the problem and spent
> time manually reordering the files in my mbox for application in git.
>
> This is why anyone who tells you not to chain patches as replies to
> their preceding patches are clueless whiners who should be ignored.
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.

This patchset is causing troubles here on a AR5212.

# lspci -nnvv | grep -i ath
02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)
        Kernel driver in use: ath5k

With linux-next (next 20101203) I have to revert the 9 patches and
apply the 6 patches from Nick to regain a stable system (see P.S.
below).

First I thought this
Mega-Hyper-Super-Duper-Sexy-Hagawanga-We-have-waited-so-long-for patch
is the culprit...

$ grep sched setup_linux-next_next20101203.dileks.4.log
  (+) OK   linux-2.6-tip-sched-core/0001-sched-Add-autogroup-scheduling-feature-automated-per.patch

But this is not the fact for the audio dropouts I enjoyed again.
Then I had a closer look into linux-next GIT... My ath5k seems not to
be a good choice these days :-(.

- Sedat -

P.S.:

$ cd $HOME/linux-2.6
$ grep ath5 setup_linux-next_next20101203.dileks.4.log
  (+) OK   revert-ath5k-patches/0001-Revert-ath5k-Fix-reset-and-interrupts-for-AHB-type-o.patch
  (+) OK   revert-ath5k-patches/0002-Revert-ath5k-Add-AHB-bus-support.patch
  (+) OK   revert-ath5k-patches/0003-Revert-ath5k-Add-initial-registers-values-for-radio-.patch
  (+) OK   revert-ath5k-patches/0004-Revert-ath5k-Add-a-function-to-read-chipset-s-MAC-re.patch
  (+) OK   revert-ath5k-patches/0005-Revert-ath5k-Check-if-pci-pdev-struct-is-initialized.patch
  (+) OK   revert-ath5k-patches/0006-Revert-ath5k-Use-generic-eeprom-read-from-common-ath.patch
  (+) OK   revert-ath5k-patches/0007-Revert-ath5k-Move-PCI-bus-functions-to-separate-file.patch
  (+) OK   revert-ath5k-patches/0008-Revert-ath5k-Introduce-ath5k_init_softc-function-as-.patch
  (+) OK   revert-ath5k-patches/0009-Revert-ath5k-Use-Generic-DMA-for-later-support-of-AH.patch

$ cd linux-2.6.37-rc4/debian/build/source_i386_none/
$ cat .pc/applied-patches
ath5k-fix/1-6-ath5k-Always-write-tx-powertable-on-hw.patch
ath5k-fix/2-6-ath5k-Always-free-tx-buffers-before-reset.patch
ath5k-fix/3-6-ath5k-Disable-ANI-during-reset.patch
ath5k-fix/4-6-ath5k-Fix-reporting-of-RX-dma-stop-failure.patch
ath5k-fix/5-6-ath5k-Update-version-string.patch
ath5k-fix/6-6-ath5k-Include-tx-ack-reporting-on-hw-flags.patch

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36985 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbcAJLE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2016 06:04:27 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so229578319wmf.0
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2016 03:04:26 -0800 (PST)
From: poma <pomidorabelisima@gmail.com>
Subject: Re: Wi-Fi - ath10k QCA9377 chipset support - kernel 4.2.x backport
References: <CADtwgbzdjw3Ef-64Fu1OahnARnb9u8Q-jcZR8GeWoMXBco=7DA@mail.gmail.com>
 <CAJm42398V=NVFsRVZp9EmL6=9gfCfiYehMYOBeB-3rhonn2hwg@mail.gmail.com>
 <CADtwgbzUVSnhQdojbRmNud_v1NsgipjkwvKL_k884js3_WKsYA@mail.gmail.com>
 <5691AE01.8070203@gmail.com>
 <CADtwgbxw1BmXn_nFLxD9xJgAw8xsdM-3ri-Kd5CTU9+2QEOmEQ@mail.gmail.com>
 <CAJm4238HOP0fWK-86-ujSGieiUGRL=5O2VQY_13d5k0hf2d1qw@mail.gmail.com>
Cc: Community support for Fedora users
	<users@lists.fedoraproject.org>, Brandon.Vincent@asu.edu,
	linux-wireless <linux-wireless@vger.kernel.org>
To: outperformer@gmail.com
Message-ID: <56923AB7.8020905@gmail.com> (sfid-20160110_120458_621699_1BD27870)
Date: Sun, 10 Jan 2016 12:04:23 +0100
MIME-Version: 1.0
In-Reply-To: <CAJm4238HOP0fWK-86-ujSGieiUGRL=5O2VQY_13d5k0hf2d1qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10.01.2016 02:36, Brandon Vincent wrote:
> On Sat, Jan 9, 2016 at 6:12 PM, M. Gelle <outperformer@gmail.com> wrote:
>> Sorry, I thought you new there was only one public download that wasn't
>> working. I'll try this although I thought the file should have been a Linux
>> archive. I'll see if Brandon comes up with another link. Sorry again, for my
>> frustration.
> 
> Let's try using the latest backport drivers from upstream.
> 
> dnf group install "Development Tools"
> dnf install kernel-devel
> wget https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v4.3/backports-4.3-1.tar.gz
> tar -zxvf backports-4.3.1.tar.gz
> cd backports-4.3.1
> make defconfig-ath10k
> make
> sudo make install
> 
> Reboot the system and see if you wireless card starts to work.
> 
> Brandon Vincent
> 


Kernel:
4.2.8-200.fc22.x86_64


Modules:
ath10k backports releases
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/backports

This one includes ath10k QCA9377 chipset support:
$ wget https://www.kernel.org/pub/linux/kernel/projects/backports/2015/11/20/sha256sums.asc
$ wget https://www.kernel.org/pub/linux/kernel/projects/backports/2015/11/20/backports-20151120.tar.sign
$ wget https://www.kernel.org/pub/linux/kernel/projects/backports/2015/11/20/backports-20151120.tar.xz

$ gpg --verify sha256sums.asc
$ gpg --verify backports-20151120.tar.sign backports-20151120.tar.xz
$ sha256sum -c sha256sums.asc

$ tar xf backports-20151120.tar.xz
$ cd backports-20151120/
$ make defconfig-ath10k
$ make
$ su
# make install


Firmware:
[PATCH v2] ath10k: add QCA9377 chipset support
http://www.spinics.net/lists/linux-wireless/msg143148.html

<quote>
... pushed the firmware image here:

https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0

All reports, good or bad, are very welcome.
...
</quote>


# mkdirhier /usr/lib/firmware/ath10k/QCA9377/hw1.0
# cd /usr/lib/firmware/ath10k/QCA9377/hw1.0
# wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA9377/hw1.0/board.bin
# wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA9377/hw1.0/firmware-5.bin_WLAN.TF.1.0-00267-1 -O firmware-5.bin
# wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA9377/hw1.0/notice.txt_WLAN.TF.1.0-00267-1 -O notice-WLAN.TF.1.0-00267-1.txt



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34677 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbbG1L0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 07:26:48 -0400
Received: by wibud3 with SMTP id ud3so176363975wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 04:26:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
	<CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
Date: Tue, 28 Jul 2015 13:26:47 +0200
Message-ID: <CA+BoTQkA0k1RBwzKFchcWebuWUmdoaqvaAq4BRz2o3C-GGUCog@mail.gmail.com> (sfid-20150728_132652_282279_C59BFE0A)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Michal Kazior <michal.kazior@tieto.com>
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 July 2015 at 13:00, Enrico Tagliavini <enrico.tagliavini@gmail.com> wrote:
> Hi Michal,
>
> this is the dmesg output from a boot with kernel 4.1.2 with patch to
> make the firmware load [1]
>
> Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0: enabling device (0000 -> 0002)
> Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
> Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0: Direct firmware load for ath10k/cal-pci-0000:03:00.0.bin
> failed with error -2
> Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0: qca6174 hw2.1 (0x05010000, 0x003405ff) fw
> killer-n1525-fw api 4 htt 3.0 wmi 4 cal otp max_sta 32
> Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0: debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
> Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
> 0000:03:00.0 wlp3s0: renamed from wlan0
>
> I saw the report you mentioned (I'm subscribed to ath10k and try to
> keep it up with it). Not being expert at all I was not sure it was the
> same or not. Also there seems to be a difference that with irq_mode=1
> for me it just works like before.

I'm quite puzzled with the above printout. So either there's some
weird regression either in driver or the pci subsystem. It's good you
posted ;-)

Just to be clear: were you using 4.2-rc3 as in from Linus' tree or Kalle's tree?

Asking for a `git bisect` is probably a bit excessive - but it would
help a lot. I guess you'd have to manually cherry-pick qca6174 hw2 fix
[1] while bisecting.

If bisect is too much I guess you could try reverting (in order):
 https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath10k?id=0bcbbe679b66fee1b56def5cb30bfb4f616b1127
 https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath10k?id=76d870ed09ab34154454b1adb823ae75f173c2d2
 https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath10k?id=77258d409ce45890104e3da11d0261402c49aee1

I'm shooting blind here though.

> [1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/wireless/ath/ath10k/pci.c?id=11a002efbaa7fbd9f6e616695ab42aa9f1caf060


Michał

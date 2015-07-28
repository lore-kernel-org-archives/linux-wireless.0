Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34461 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbG1LA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 07:00:29 -0400
Received: by wibud3 with SMTP id ud3so175464883wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 04:00:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
Date: Tue, 28 Jul 2015 13:00:27 +0200
Message-ID: <CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com> (sfid-20150728_130042_033762_84A093AE)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

this is the dmesg output from a boot with kernel 4.1.2 with patch to
make the firmware load [1]

Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0: enabling device (0000 -> 0002)
Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
Jul 26 10:07:42 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0: Direct firmware load for ath10k/cal-pci-0000:03:00.0.bin
failed with error -2
Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0: qca6174 hw2.1 (0x05010000, 0x003405ff) fw
killer-n1525-fw api 4 htt 3.0 wmi 4 cal otp max_sta 32
Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0: debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
Jul 26 10:07:44 alientux.saurisiamonoi.org kernel: ath10k_pci
0000:03:00.0 wlp3s0: renamed from wlan0

I saw the report you mentioned (I'm subscribed to ath10k and try to
keep it up with it). Not being expert at all I was not sure it was the
same or not. Also there seems to be a difference that with irq_mode=1
for me it just works like before.

[1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/wireless/ath/ath10k/pci.c?id=11a002efbaa7fbd9f6e616695ab42aa9f1caf060

On 28 July 2015 at 06:31, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 27 July 2015 at 22:08, Enrico Tagliavini <enrico.tagliavini@gmail.com> wrote:
>> Hello there,
>>
>> I gave 4.2 rc3 a shot and I discovered the wireless was not working
>> anymore with it. I tried adding irq_mode=1 alongside skip_otp=y in
>> ath10k_core (I assume you need fw api 5 to remove this, is that
>> correct?, I still have fw 4 only).
>>
>> Loading with irq_mode=0
>>
>> [   21.130224] ath10k_pci 0000:03:00.0: enabling device (0000 -> 0002)
>> [   21.130734] ath10k_pci 0000:03:00.0: pci irq msi-x interrupts 8
>> irq_mode 0 reset_mode 0
>
> There was already a similar report[1]. Just for the record: what
> number of interrupts did you have before 4.2-rc3? I assume it was "pci
> irq msi interrupts 1 irq_mode 0 reset_mode 0".
>
> My suspicion is that either the firmware is buggy and doesn't play
> well with multiple MSI interrupts or the MSI interrupt behaviour
> changed significantly (compared to qca988x) and this remained hidden
> because not an awful lot of machines seemed to have provided more than
> 1 msi interrupt for ath10k.
>
> [1]: http://lists.infradead.org/pipermail/ath10k/2015-July/005695.html
>
>
> Michał

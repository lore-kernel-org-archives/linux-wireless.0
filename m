Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36048 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbHYNJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 09:09:47 -0400
Received: by labia3 with SMTP id ia3so33326582lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 06:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1889302.bvZ6s0xNZC@wuerfel>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
	<1889302.bvZ6s0xNZC@wuerfel>
Date: Tue, 25 Aug 2015 15:09:45 +0200
Message-ID: <CA+BoTQ=STQ2jpMCjP7V=soPk=e4BMuq+3bO_F0UXK_EuJFqxfQ@mail.gmail.com> (sfid-20150825_150951_146842_9FACB425)
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
From: Michal Kazior <michal.kazior@tieto.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Anish Tondwalkar <twilightrook@gmail.com>,
	Victor van Poppelen <vvanpo@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Oscar Rydberg <oscarrydberg@gmail.com>,
	Joseph Salisbury <joseph.salisbury@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 August 2015 at 14:56, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 August 2015 14:32:25 Michal Kazior wrote:
>> Hi everyone,
>>
>> Looks like ath10k is very close to finally support
>> qca6164. Recent discussion[1] led to a working
>> prototype[2][3].
>>
>> I'm CCing everyone I've found in my mailbox that
>> complained about QCA6164 not working. Hopefully I
>> did not miss anyone.
>>
>> I would really like to know if this patchset (in
>> its current shape and form) of mine works for any
>> of you who owns QCA6164. If it doesn't please try
>> Patch [1/2] only.
>>
>> Today Kalle posted QCA6174 (which is actually
>> QCA61X4) firmware binary for ath10k[4]. Please use
>> it to test QCA6164 (i.e. don't use sumdog's
>> firmware nor your own assembled one).
>>
>> However QCA6164 requires a different board.bin
>> file[3]. This requires some additional changes in
>> ath10k to support sanely but *for now* you can use
>> board file vvanpo extracted from window driver[5]
>> and place it as:
>>
>>   /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:0041:17aa:3545.bin
>>
>> This should work. If it doesn't, try replacing the
>> existing board.bin - if you'll need to do please
>> let me/us know and post the boot string which
>> looks like this:
>>
>>   ath10k_pci 0000:03:00.0: qca6174 hw2.1 (0x05010000, 0x003405ff, 168c:0041:17aa:3545 fallback) fw killer-n1525-fw api 5 htt-ver 0.0 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1 features
>>
>> My guess is some devices may have different
>> subsystem product/vendor ids. It'll be good to
>> know at least a subset of those for reference.
>>
>
> Hi Michael,
>
> I have now put the qca6164 card back into my Lenovo Yoga 3 11 (1170)
> and tried your first patch from your email on top of 4d43636271
> ("Merge remote-tracking branch 'wireless-testing/master'") from Kalle.
>
> It looks like I'm still getting firmware crashes with the firmware
> files you pointed to:
>
> $ md5sum /lib/firmware/ath10k/QCA6174/hw2.1/*
> e6adc90ecaf55edc656990c6c50193ac  /lib/firmware/ath10k/QCA6174/hw2.1/board.bin
> e6adc90ecaf55edc656990c6c50193ac  /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:0041:17aa:3545.bin
> 8f5303e4b1afc818798425a700139133  /lib/firmware/ath10k/QCA6174/hw2.1/firmware-5.bin
>
> $ sudo modprobe ath10k-core  debug_mask=0xffffbfff skip_otp=1
> $ sudo modprobe ath10k-pci
> $ dmesg
>
> [ 2213.448180] ath10k_pci 0000:02:00.0: pci remove
> [ 2217.606063] ath10k_pci 0000:02:00.0: pci probe
> [ 2217.606231] ath10k_pci 0000:02:00.0: boot pci_mem 0xffffc90001800000
> [ 2217.606623] ath10k_pci 0000:02:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
[...]
> [ 2218.993214] ath10k_pci 0000:02:00.0: boot hif start
> [ 2218.993232] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
> [ 2218.993750] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
> [ 2219.992233] ath10k_pci 0000:02:00.0: failed to receive control response completion, polling..
> [ 2219.992242] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992271] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992280] ath10k_pci 0000:02:00.0: pci rx ce pipe 1 len 20
> [ 2219.992286] ath10k_pci 0000:02:00.0: pci rx: 00000000: 00 00 0c 00 00 00 00 00 01 00 02 00 00 07 16 00  ................
> [ 2219.992291] ath10k_pci 0000:02:00.0: pci rx: 00000010: 01 00 00 00                                      ....
> [ 2219.992301] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992307] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992313] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992319] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992323] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992327] ath10k_pci 0000:02:00.0: pci hif send complete check
> [ 2219.992335] ath10k_pci 0000:02:00.0: Target ready! transmit resources: 2 size:1792
> [ 2219.992339] ath10k_pci 0000:02:00.0: pci hif map service
> [ 2219.992344] ath10k_pci 0000:02:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
> [ 2219.992348] ath10k_pci 0000:02:00.0: boot htc ep 0 ul polled 0 dl polled 0
> [ 2219.992352] ath10k_pci 0000:02:00.0: boot htc service 'Control' eid 0 TX flow control disabled
> [ 2219.992357] ath10k_pci 0000:02:00.0: boot htc service HTT Data does not allocate target credits
> [ 2219.992363] ath10k_pci 0000:02:00.0: ath10k_htc_build_tx_ctrl_skb: skb ffff88009738d900
> [ 2219.992369] ath10k_pci 0000:02:00.0: pci tx item 0 paddr 0x9ae95800 len 16 n_items 1
> [ 2219.992374] ath10k_pci 0000:02:00.0: pci tx data: 00000000: 00 01 08 00 74 00 0c 00 02 00 00 03 08 00 00 00  ....t...........
> [ 2219.992401] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
> [ 2219.992431] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt

This is some weird regression with MSI ranges and we still haven't
figured this out.

For the time being add "irq_mode=1" parameter when loading ath10k_pci
module, please.


Michał

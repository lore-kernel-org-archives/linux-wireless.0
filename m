Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37954 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbG1Eb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 00:31:28 -0400
Received: by wibxm9 with SMTP id xm9so142703578wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 21:31:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
Date: Tue, 28 Jul 2015 06:31:27 +0200
Message-ID: <CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com> (sfid-20150728_063131_909096_A2DCA488)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Michal Kazior <michal.kazior@tieto.com>
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 July 2015 at 22:08, Enrico Tagliavini <enrico.tagliavini@gmail.com> wrote:
> Hello there,
>
> I gave 4.2 rc3 a shot and I discovered the wireless was not working
> anymore with it. I tried adding irq_mode=1 alongside skip_otp=y in
> ath10k_core (I assume you need fw api 5 to remove this, is that
> correct?, I still have fw 4 only).
>
> Loading with irq_mode=0
>
> [   21.130224] ath10k_pci 0000:03:00.0: enabling device (0000 -> 0002)
> [   21.130734] ath10k_pci 0000:03:00.0: pci irq msi-x interrupts 8
> irq_mode 0 reset_mode 0

There was already a similar report[1]. Just for the record: what
number of interrupts did you have before 4.2-rc3? I assume it was "pci
irq msi interrupts 1 irq_mode 0 reset_mode 0".

My suspicion is that either the firmware is buggy and doesn't play
well with multiple MSI interrupts or the MSI interrupt behaviour
changed significantly (compared to qca988x) and this remained hidden
because not an awful lot of machines seemed to have provided more than
1 msi interrupt for ath10k.

[1]: http://lists.infradead.org/pipermail/ath10k/2015-July/005695.html


Michał

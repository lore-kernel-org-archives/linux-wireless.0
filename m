Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25911 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaGBIK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 04:10:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?Q?Andr=C3=A9?= Valentin <avalentin@marcant.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: ath10k OTP loading issues
References: <53AD2EEE.4040704@marcant.net>
Date: Wed, 2 Jul 2014 11:10:47 +0300
In-Reply-To: <53AD2EEE.4040704@marcant.net> (=?utf-8?Q?=22Andr=C3=A9?=
 Valentin"'s message of
	"Fri, 27 Jun 2014 10:44:30 +0200")
Message-ID: <87tx70p4e0.fsf@kamboji.qca.qualcomm.com> (sfid-20140702_101122_777089_BD2ACAC2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

please always CC ath10k list, that way you get attention of all ath10k
developers.

André Valentin <avalentin@marcant.net> writes:

> I got problems initializing my ath10k PCI card in my Zyxel NBG 6716.
> It worked until some weeks, now, the driver does not load. I debugged
> a bit and this is what I got:
>
> Fri Jun 27 08:03:42 2014 kern.info kernel: [62908.290000] ath10k_pci 0000:01:00.0: BAR 0: assigned [mem 0x12000000-0x121fffff 64bit]
> Fri Jun 27 08:03:43 2014 kern.info kernel: [62908.610000] ath10k: pci irq legacy irq_mode 0 reset_mode 0
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.620000] ath10k: boot upload otp to 0x1234 len 6917
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.780000] ath10k: otp calibration failed: 2
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.790000] ath10k: failed to run otp: -22
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.790000] ath10k: could not init core (-22)
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62909.060000] ath10k: could not probe fw (-22)
> Fri Jun 27 08:03:43 2014 kern.err kernel: [62909.060000] ath10k: failed to register driver core: -22
> Fri Jun 27 08:03:43 2014 kern.warn kernel: [62909.060000] ath10k_pci: probe of 0000:01:00.0 failed with error -22
>
> If I remove OTP loading the card initializes fine, but I think I will
> not have a good performance. So bad idea.

All that was changed recently was that we now check the error code
coming from otp.bin. So you have had this issue all along, it was just
hidden before.

-- 
Kalle Valo

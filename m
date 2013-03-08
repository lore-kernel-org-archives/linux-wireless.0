Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54330 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3CHH1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 02:27:07 -0500
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?Q?Ale=C5=A1?= Voda <AVoda@descartes.com>
Subject: Re: AR6103G Linux kernel 3.4.5 problems
References: <62813611608FC749AC8F3F91AEAF5F89417512DD@CPEXM03.corp.dsg.local>
Date: Fri, 8 Mar 2013 09:27:00 +0200
In-Reply-To: <62813611608FC749AC8F3F91AEAF5F89417512DD@CPEXM03.corp.dsg.local>
	(=?utf-8?Q?=22Ale=C5=A1?= Voda"'s message of "Fri, 28 Dec 2012 11:35:34
 +0000")
Message-ID: <87ppzas663.fsf@kamboji.qca.qualcomm.com> (sfid-20130308_082711_997426_CDF74EF9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Aleš Voda <AVoda@descartes.com> writes:

> We have some custom board equipped with AR6103G using SDIO as hif and
> are having problems with AR6103 not starting after downloading the
> firmware. Linux kernel being used is 3.4.5. As it is apparent from the
> console output attached, the fw related files are downloaded and a
> timeout occurs after uploading data patch file to the chip. After
> removing ath6kl_sdio driver and renaming fw-2 and fw-3

Why do you need to rename the firmware files? What version of ath6kl are
you using? Where did you get it? 

> are so they can not be found and loaded, timeout during fw uploads
> doesn't occur anymore after insertion of the ath6kl_sdio module, but
> there is a HW startup failure while awaiting CTRL message from the
> chip (err = -EIO). The firmware for the chip has been downloaded from
> the kernel firmware git repository.
>
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=tree;f=
> ath6k/AR6003/hw2.1.1;hb=HEAD

You should be using fw-3.bin. Better to remove athwlan.bin and fw-2.bin
altogether from your platform.

> What could be the problem? If you need any additional info please do
> not hesitate to contact me.

I think I don't have AR6103 myself. I'm not sure if it has some
differences compared to AR6003, that's one possibility as well.

-- 
Kalle Valo

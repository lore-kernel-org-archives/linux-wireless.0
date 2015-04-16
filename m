Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34918 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbDPJCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:02:51 -0400
Received: by qgej70 with SMTP id j70so2510807qge.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2015 02:02:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
	<1428916704-9635-2-git-send-email-afenkart@gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
Date: Thu, 16 Apr 2015 11:02:50 +0200
Message-ID: <CALtMJECuDTKCRK9YXfTq0vAWmTm4rbNreE5i37T-H7=c5q=T7A@mail.gmail.com> (sfid-20150416_110258_739401_BF855FE6)
Subject: Re: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

2015-04-13 12:27 GMT+02:00 Amitkumar Karwar <akarwar@marvell.com>:
>
> We had recently submitted a patch to address this issue. So these two patches won't be needed now.
> http://www.spinics.net/lists/linux-wireless/msg135146.html
>
> Could you please check and let us know if you have any suggestions for improvement?

They work for my use case: 1 adapter / non-removable

Problems not solved:
- the use of global static variable is racy in case there two
adapters, and both need reset
  simultaneously
- since work struct is independent of the interface (sdio_func), it
will also not be notified
  if the card is removed physically

for illustrating the latter:
- cmd is hung
- card timeout triggers, and issues card reset, card reset stores adapter
  pointer in global variable
- user removes card
- mmc layer triggers removal of card, global pointer becomes invalid
- card reset work struct de-references invalid pointer

regards,
Andreas

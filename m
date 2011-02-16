Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26273 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1BPP3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 10:29:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 07:28:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19803.60724.709319.464968@gargle.gargle.HOWL>
Date: Wed, 16 Feb 2011 20:58:52 +0530
To: "atheros.eng.projects.ath9k-devel@mailman.users.atheros.com"
	<atheros.eng.projects.ath9k-devel@mailman.users.atheros.com>
CC: Takashi Kawamoto <tkawamoto@silex.jp>,
	Ryou Matsuura <matsuura@silex.jp>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bato <bato@silex.jp>, Yuji Sasaki <sasaki@silex.jp>,
	Yoshitaka Imura <imura@silex.jp>,
	"Yasuo@bonnie.users.atheros.com" <Yasuo@bonnie.users.atheros.com>
Subject: Re: [internal-ath9k-devel] BUG: AR9271 cause a Kernel Panic on
	ARM11 SMP environment
In-Reply-To: <20110216145201.GB10287@tuxdriver.com>
References: <20110216141657.9270.9AD4E5EB@silex.jp>
	<20110216145201.GB10287@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> My guess would be that somehow you are leaking hif_dev->tx.tx_lock,
> and then hanging when trying to retake it in hif_usb_send_tx.
> Unfortunately, it is not obvious to me how that might happen...

This seems to happen only on the specified ARM platform.
We haven't had a report of such a bug on x86 till now.

Not sure how this lockup could happen, though.

Sujith

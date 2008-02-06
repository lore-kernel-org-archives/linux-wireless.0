Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:26488 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYBFPqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 10:46:42 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2704112wra.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 07:46:41 -0800 (PST)
Message-ID: <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com> (sfid-20080206_154647_539657_517E00E4)
Date: Wed, 6 Feb 2008 10:46:39 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jiri Slaby" <jirislaby@gmail.com>,
	"Tino Keitel" <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
In-Reply-To: <20080206150043.GA6921@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080206014131.9d489a34.akpm@linux-foundation.org>
	 <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
	 <20080206150043.GA6921@nineveh.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > We failed to resume after a hardware reset here for a whole second. Is there any
> > version of ath5k which worked for you (is this a regression)?
>
> I cannot speak for Tino, but my ath5k never worked in MacBook -- it
> failed the same way, and I believe the hardware was the same.  My
> understanding was that it was a known bug with PCIE devices, but I got
> that out of reading list archives.

Nick Kossifidis and I are in the process of debugging this -- we
determined that AR5K_RESET_CTL_PCI hangs the card in hw_nic_wakeup.
It doesn't look like there is any general support for 5424 cards yet.
Thread is at:

    http://marc.info/?l=linux-wireless&m=120179743111458

-Bob

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43800 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZFPPcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 11:32:02 -0400
Received: by gxk10 with SMTP id 10so7855247gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 08:32:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090616151258.GA22849@jm.kir.nu>
References: <20090616085922.GA10176@jm.kir.nu>
	 <b6c5339f0906160733l2ec28563h60145254855c3472@mail.gmail.com>
	 <20090616151258.GA22849@jm.kir.nu>
Date: Tue, 16 Jun 2009 11:32:03 -0400
Message-ID: <b6c5339f0906160832x5d2d43d0k9446079b96784dd3@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix PCI FATAL interrupts by restoring
	RETRY_TIMEOUT disabling
From: Bob Copeland <me@bobcopeland.com>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:12 AM, Jouni Malinen<j@w1.fi> wrote:
>> Jouni, can you confirm that e23a9014... also needs reverting?
>
> At this point, I can really only say that I can now easily reproduce
> this with ath9k and AR5416 and zeroing the 0x41 value does make the
> problem disappear. Since that code has been in use for five years, I do
> not expect problems with it and we can just eventually fix the comment
> if somebody actually find out what that register is supposed to control
> ;-).

Heh, fair enough.  That's good enough for me, we know it's been
in madwifi for ages and doesn't hurt anything, so let's go ahead
and revert e23a9014... as well.

-- 
Bob Copeland %% www.bobcopeland.com

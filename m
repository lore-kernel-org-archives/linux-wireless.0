Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50172 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0L3ChM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 21:37:12 -0500
Message-ID: <4D1BF056.3060909@lwfinger.net>
Date: Wed, 29 Dec 2010 20:37:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
References: <4D1A8200.4010609@lwfinger.net> <20101229195440.GD5838@darkside.kls.lan> <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan>
In-Reply-To: <20101230012003.GA2665@darkside.kls.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2010 07:20 PM, Mario 'BitKoenig' Holbe wrote:
> 
> It will surely not matter: if CONFIG_B43_HWRNG would not have been
> defined, hwrng_register() would not have been reached in the dump from
> my first mail.
> 
> If you really like me to try that patch, I'll do so when I'm awake again
> and will then answer you that nothing has changed :)

No, don't bother. I do have a different request. The byte counts for my 32-bit
system do not match yours. Could you please use the following command to find
the instructions that are failing?

objdump -l -d drivers/char/hw_random/core.o | less

Use the search to find the start of hwrng_register, then add 0x4c to the
starting address. Once I see hte instruction that is failing, I should be able
to find where the failure occurs.

The order in which things are registered should not cause an error, but who knows?

Larry

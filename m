Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47327 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3DZXfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 19:35:14 -0400
Message-ID: <1367018364.32385.3.camel@zurbaran> (sfid-20130427_013519_420381_08E847D2)
Subject: Re: [PATCH] NFC: Add missing RFKILL dependency for Kconfig
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1366999114-26903-1-git-send-email-marcel@holtmann.org>
References: <1366999114-26903-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Apr 2013 01:19:24 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Fri, 2013-04-26 at 10:58 -0700, Marcel Holtmann wrote:
> Since the NFC subsystem gained RFKILL support, it needs to be able
> to build properly with whatever option for RFKILL has been selected.
> 
> on i386:
> 
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a36d): undefined reference to `rfkill_unregister'
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a378): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a493): undefined reference to `rfkill_alloc'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4a4): undefined reference to `rfkill_register'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4b3): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_dev_up':
> (.text+0x6a8e8): undefined reference to `rfkill_blocked'
> 
> when CONFIG_RFKILL=m but NFC is builtin.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  net/nfc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
Applied to nfc-next, thanks.

Cheers,
Samuel.




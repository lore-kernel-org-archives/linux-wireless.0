Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53612 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbcBFL7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:59:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] hostap: avoid uninitialized variable use in hfa384x_get_rid
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <18181682.hKPVvnQWXk@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jouni Malinen <j@w1.fi>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-Id: <20160206115945.43B2460495@smtp.codeaurora.org> (sfid-20160206_130010_194399_107BED1A)
Date: Sat,  6 Feb 2016 11:59:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The driver reads a value from hfa384x_from_bap(), which may fail,
> and then assigns the value to a local variable. gcc detects that
> in in the failure case, the 'rlen' variable now contains
> uninitialized data:
> 
> In file included from ../drivers/net/wireless/intersil/hostap/hostap_pci.c:220:0:
> drivers/net/wireless/intersil/hostap/hostap_hw.c: In function 'hfa384x_get_rid':
> drivers/net/wireless/intersil/hostap/hostap_hw.c:842:5: warning: 'rec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   if (le16_to_cpu(rec.len) == 0) {
> 
> This restructures the function as suggested by Russell King, to
> make it more readable and get more reliable error handling, by
> handling each failure mode using a goto.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

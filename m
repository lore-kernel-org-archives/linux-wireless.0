Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41648 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYAWOPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 09:15:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: b43legacy: fix MAC control and microcode init
Date: Wed, 23 Jan 2008 15:14:20 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080123144850.19a0545b@morte>
In-Reply-To: <20080123144850.19a0545b@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801231514.21045.mb@bu3sch.de> (sfid-20080123_141557_125127_793EA0F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008 14:48:50 Stefano Brivio wrote:
> This zeros out all microcode related memory before loading
> the microcode.
> 
> This also fixes initialization of the MAC control register.
> The _only_ place where we overwrite the contents of the MAC control
> register is at the beginning of b43_chip_init().
> All other places must do read() -> mask/set -> write() to not
> overwrite existing bits.
> 
> This also adds a longer delay for waiting for the microcode
> to initialize itself. It seems that the current timeout is sufficient
> on all available devices, but there's no real reason why we shouldn't
> wait for up to one second. Slow embedded devices might exist.
> Better safe than sorry.
> 
> While at it, fix naming of MACCTL values.
> 
> This patch by Michael Buesch has been ported to b43legacy.
> 
> Cc: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---

Acked-by: Michael Buesch <mb@bu3sch.de>

> John, this bugfix should go into 2.6.24, if possible.

We agreed in private that this is actually pretty intrusive and
the patches should _not_ go into 2.6.24, as they don't actually
fix known bugs.

-- 
Greetings Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5875 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbYELLns (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 07:43:48 -0400
Subject: Re: [PATCH] hostap: procfs fix for hostap_fw.c
From: Pavel Roskin <proski@gnu.org>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: j@w1.fi, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080506152354.GA3680@mobydick>
References: <20080506152354.GA3680@mobydick>
Content-Type: text/plain
Date: Mon, 12 May 2008 07:43:46 -0400
Message-Id: <1210592626.3372.6.camel@dv> (sfid-20080512_134354_459442_E02CFE29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-06 at 17:23 +0200, Mathieu Chouquet-Stringer wrote:

> Problem is local->proc has now been overwritten by hostap_init_proc
> meaning "registers" isn't removed.  When you reload the module you get
> an error telling you "registers" already exists (and you then get
> duplicate "registers" files in /proc).

I've seen it many times.  Thanks for tracking it down!  I've tested the
patch with PCI and PCMCIA devices, and everything appears to be
correct.  /proc/registers is not created, "registers" is created
under /proc/net/hostap/wlan0/, no more warnings.

> Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>

Acked-off-by: Pavel Roskin <proski@gnu.org>

If a more concise description needs to be written, I can do it.

-- 
Regards,
Pavel Roskin

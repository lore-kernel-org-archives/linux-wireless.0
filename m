Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab1CaOJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 10:09:36 -0400
Message-ID: <4D948B1C.7080806@suse.cz>
Date: Thu, 31 Mar 2011 16:09:32 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
	Arend van Spriel <arend@broadcom.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	devel@linuxdriverproject.org, gregkh@suse.de,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de> <4D948624.3040605@suse.cz> <20110331135126.GC19540@flint.arm.linux.org.uk>
In-Reply-To: <20110331135126.GC19540@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2011 03:51 PM, Russell King wrote:
> On Thu, Mar 31, 2011 at 03:48:20PM +0200, Jiri Slaby wrote:
>> How it can? Packed only tells the compiler to have one byte alignment
>> steps. And it should not matter here as all the members are 32-bit long.
> 
> It also tells the compiler that it may be misaligned, so to avoid
> alignment faults it will use byte loads/stores.

No, it should not (if offsetof % sizeof == 0). Otherwise it's a bug in
the compiler.

Am I missing something?

thanks,
-- 
js
suse labs

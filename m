Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2365 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1CWKvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 06:51:38 -0400
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: "george@znau.edu.ua" <george@znau.edu.ua>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
 <1300738586-7157-2-git-send-email-arend@broadcom.com>
 <20110321132848.e4e846a5.rdunlap@xenotime.net>
Date: Wed, 23 Mar 2011 11:51:16 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsslrqf23ri7v4@arend-laptop>
In-Reply-To: <20110321132848.e4e846a5.rdunlap@xenotime.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Mar 2011 21:28:48 +0100, Randy Dunlap <rdunlap@xenotime.net>  
wrote:

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code  
> ***
>

Hi Randy,

One of the things I am facing in the code is the use of the volatile  
keyword so I browsed another file in the Documentation folder:  
volatile-considered-harmful.txt. As your name popped up I would like to  
ask some questions. The register access macros in the brcmaxi module make  
use of the accessor functions readb/w/l and writeb/w/l and the pointer  
parameter is cast with volatile keyword, which I assume to be unneccessary  
(reading the doc). Another instance uses it to avoid optimization. Here is  
how the function is coded currently:

void foobar(void *r, u32 val)
{
	volatile u32 dummy;

	WR_REG(r, val);
	dummy = RD_REG(r);
}

The register read is necessary to assure the register write is properly  
flushed out in hardware. Could removing the volatile for the dummy  
variable cause removal of the register read due to code optimization.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"


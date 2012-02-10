Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1232 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2BJJME (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 04:12:04 -0500
Message-ID: <4F34DF57.5020706@broadcom.com> (sfid-20120210_101220_528757_C6B93024)
Date: Fri, 10 Feb 2012 10:11:51 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/15] brcm80211: fmac: move module entry points to
 dhd_linux.c
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
 <1328818149-4826-10-git-send-email-arend@broadcom.com>
 <CAGRGNgXPE3T_jTFDvxAQ_Of4kNQSOGwwAy_-Na3iR24xvnLEZA@mail.gmail.com>
In-Reply-To: <CAGRGNgXPE3T_jTFDvxAQ_Of4kNQSOGwwAy_-Na3iR24xvnLEZA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2012 12:50 AM, Julian Calaby wrote:
> Hi,
> 
> Quick query:
> 
> On Fri, Feb 10, 2012 at 07:09, Arend van Spriel <arend@broadcom.com> wrote:
>> The module_init/exit functions are moved to dhd_linux.c to prepare
>> for supporting multiple host interface types.
>>
> 
> I assume that the USB driver init will be added here as a separate #ifdef block.

Correct.

> If this is the case, doesn't this mean that on a system with both the
> USB and SDIO drivers enabled in .config, you won't be able to load the
> USB driver without the SDIO driver or vice-versa?

True.

> The model that most other drivers I've seen use is to have
> bus-specific modules and a common code module.
> 
> Thanks,
> 

I've seen both flavors. We discussed it internally and both flavors have
a price regarding system resources. Being curious by nature and open to
discussion I invite kernel developers to spew their arguments for 1)
separate modules and 2) kconfig option.

Gr. AvS


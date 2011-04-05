Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53757 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1DEUuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 16:50:15 -0400
Received: by yxs7 with SMTP id 7so321979yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 13:50:14 -0700 (PDT)
Message-ID: <4D9B8082.10201@lwfinger.net>
Date: Tue, 05 Apr 2011 15:50:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	George Kashperko <george@znau.edu.ua>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>	<1302032137.3969.10.camel@Joe-Laptop> <BANLkTimTmqop-xzFsWr1=2RXv5z6iTre4Q@mail.gmail.com>
In-Reply-To: <BANLkTimTmqop-xzFsWr1=2RXv5z6iTre4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2011 03:15 PM, Rafał Miłecki wrote:
>
> I was reading about __packed long time ago and it was a little tricky
> for me. However I don't see anything in mod_devicetable.h using that
> __packed. Why should we?

Packed should only be used for those structs that are read/written by some 
entity other than the main CPU. For example, RX and TX descriptors must be 
packed. Otherwise, you should let the compiler align them any way that it thinks 
might be more efficient. If that requires holes to aligh a 16-bit quantity, let 
it. Of course, it would not make any difference for x86 on this one, but for 
some architectures (ARM, I think is one), the system must do byte accesses for 
all entries in a packed struct, just in case they are unaligned.

Larry




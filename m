Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:48762 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbZA0TCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 14:02:39 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1214601nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 11:02:36 -0800 (PST)
Message-ID: <497F5A49.50507@gmail.com> (sfid-20090127_200303_115035_58F038C1)
Date: Tue, 27 Jan 2009 19:02:33 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Pavel Roskin <proski@gnu.org>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH] orinoco: checkpatch cleanup take 2
References: <200901252254.32137.arvidjaar@mail.ru>	<200901252308.45889.arvidjaar@mail.ru> <1232941562.1604.4.camel@dv> <200901260754.58084.arvidjaar@mail.ru>
In-Reply-To: <200901260754.58084.arvidjaar@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On 26 ?????? 2009 06:46:02 Pavel Roskin wrote:
>> Please run the patch itself through checkpatch.  It finds two errors:
>>
>> ERROR: trailing statements should be on next line
>> #163: FILE: drivers/net/wireless/orinoco/hermes.c:65:
>> +                       printk(stuff); } while (0)
>> +                       printk(stuff); } while (0)
>> ERROR: do not use assignment in if condition
>> #698: FILE: drivers/net/wireless/orinoco/orinoco_cs.c:167:
>> +       if ((last_ret = (ret)) != 0) \
>>
>> total: 2 errors, 0 warnings, 786 lines checked
> 
> Thank you. Modified patch attached, now without errors.

Reviewed-by: David Kilroy <kilroyd@googlemail.com>

As far as I can tell, all the changes address a checkpatch warning, and
shouldn't modify behaviour of the code.

I specifically took a close look at the HERMES_BYTES_TO_RECLEN,
HERMES_RECLEN_TO_BYTES, CS_CHECK macros since they have potential to
hose the drivers. Looked OK to me.


Thanks,

Dave.

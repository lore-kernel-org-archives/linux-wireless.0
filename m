Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:38662 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbYJJRD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 13:03:58 -0400
Received: by nf-out-0910.google.com with SMTP id d3so307800nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 10:03:56 -0700 (PDT)
Message-ID: <48EF8AF4.1040900@gmail.com> (sfid-20081010_190403_656398_850F75BC)
Date: Fri, 10 Oct 2008 18:03:48 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Dave <kilroyd@googlemail.com>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810092321.55033.arvidjaar@newmail.ru> <48EE89ED.3050309@gmail.com> <200810101141.38929.arvidjaar@newmail.ru>
In-Reply-To: <200810101141.38929.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
>> Thanks for identifying the problem. The Agere case looks good - a few suggestions for the Symbol case though:
> 
> Updated patch attached
> 
>>  
>> But you absolutely have to kfree(pda) here.
> 
> Yes, I forgot; sorry.
> 
>> Dan Williams wrote:
>>> maybe you should not use priv->pda_size but
>>> #define SYMBOL_PDA_SIZE 256 and use that for the hermes_read_pda()
>>> length just to ensure the patched code is functionally the same as
>>> before the patch.
>> Using fw->pda_size should be fine. The value comes from a const static, set to 0x100 for Symbol.
>>
> 
> Actually it allocated 512 byte before. Should it probably be set to 0x200?

You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.

I've scanned the rest of the patch and it looks good.


Dave.

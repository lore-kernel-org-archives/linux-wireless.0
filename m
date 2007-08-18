Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:41410 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXHRRM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 13:12:58 -0400
Received: by fk-out-0910.google.com with SMTP id z23so775011fkz
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2007 10:12:57 -0700 (PDT)
Message-ID: <46C728CB.6060102@gmail.com>
Date: Sat, 18 Aug 2007 19:13:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, source@mvista.com,
	dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
	dtor@mail.ru, linux-input@atrey.karlin.mff.cuni.cz,
	netdev@vger.kernel.org, James.Bottomley@SteelEye.com,
	linux-scsi@vger.kernel.org, gtolstolytkin@ru.mvista.com,
	vitalywool@gmail.com, dsaxena@plexity.net, ralf@linux-mips.org,
	linux-mips@linux-mips.org, mchehab@infradead.org,
	video4linux-list@redhat.com, jbenc@suse.cz,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] define global BIT macro
References: <737828602404912540@wsc.cz>	<428714662539710215@wsc.cz> <20070818094602.0ea69c27.randy.dunlap@oracle.com>
In-Reply-To: <20070818094602.0ea69c27.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap napsal(a):
> On Sat, 18 Aug 2007 11:44:12 +0200 (CEST) Jiri Slaby wrote:
> 
>> define global BIT macro
>>
>> move all local BIT defines to the new globally define macro.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>
>> ---
>>
>>  include/linux/bitops.h                      |    1 +
>>  include/video/sstfb.h                       |    1 -
>>  include/video/tdfx.h                        |    2 --
>>  net/mac80211/ieee80211_i.h                  |    2 --
>>  18 files changed, 1 insertions(+), 37 deletions(-)
>>
>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>> index 3255b06..a57b81f 100644
>> --- a/include/linux/bitops.h
>> +++ b/include/linux/bitops.h
>> @@ -3,6 +3,7 @@
>>  #include <asm/types.h>
>>  
>>  #ifdef	__KERNEL__
>> +#define BIT(nr)			(1UL << (nr))
>>  #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
>>  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
>>  #define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
> 
> 
> So users of the BIT() macro in include/linux/input.h can be
> changed to use the global BIT_MASK() macro...
> and the former can be removed.

I'm afraid I don't understand you. Maybe, you are writing about changes done in
patch no. 7 [1], which didn't go through to the lkml?

[1]
http://www.fi.muni.cz/~xslaby/sklad/07-get-rid-of-input-bit-duplicate-defines.patch

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University

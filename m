Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:56430 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbXHRQmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 12:42:42 -0400
Date: Sat, 18 Aug 2007 09:46:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, <source@mvista.com>,
	<dougthompson@xmission.com>,
	<bluesmoke-devel@lists.sourceforge.net>, <dtor@mail.ru>,
	<linux-input@atrey.karlin.mff.cuni.cz>, <netdev@vger.kernel.org>,
	<James.Bottomley@SteelEye.com>, <linux-scsi@vger.kernel.org>,
	<gtolstolytkin@ru.mvista.com>, <vitalywool@gmail.com>,
	<dsaxena@plexity.net>, <ralf@linux-mips.org>,
	<linux-mips@linux-mips.org>, <mchehab@infradead.org>,
	<video4linux-list@redhat.com>, <jbenc@suse.cz>,
	<flamingice@sourmilk.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/9] define global BIT macro
Message-Id: <20070818094602.0ea69c27.randy.dunlap@oracle.com>
In-Reply-To: <428714662539710215@wsc.cz>
References: <737828602404912540@wsc.cz>
	<428714662539710215@wsc.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 18 Aug 2007 11:44:12 +0200 (CEST) Jiri Slaby wrote:

> define global BIT macro
> 
> move all local BIT defines to the new globally define macro.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> 
>  include/linux/bitops.h                      |    1 +
>  include/video/sstfb.h                       |    1 -
>  include/video/tdfx.h                        |    2 --
>  net/mac80211/ieee80211_i.h                  |    2 --
>  18 files changed, 1 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index 3255b06..a57b81f 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -3,6 +3,7 @@
>  #include <asm/types.h>
>  
>  #ifdef	__KERNEL__
> +#define BIT(nr)			(1UL << (nr))
>  #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
>  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
>  #define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))


So users of the BIT() macro in include/linux/input.h can be
changed to use the global BIT_MASK() macro...
and the former can be removed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

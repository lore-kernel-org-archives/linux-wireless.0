Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:58164
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbZA2AS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 19:18:57 -0500
Message-ID: <4980F5EC.8020506@erley.org> (sfid-20090129_011903_011830_81E31EEE)
Date: Wed, 28 Jan 2009 19:18:52 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iw: rename nl_handle to nl_sock for libnl-2.0
References: <4980E60D.9060505@erley.org>	 (sfid-20090129_001116_800094_6F18B713) <1233187487.16048.93.camel@johannes.local> <4980F51C.1000700@erley.org>
In-Reply-To: <4980F51C.1000700@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pat-lkml wrote:
> Johannes Berg wrote:
>> On Wed, 2009-01-28 at 18:11 -0500, pat-lkml wrote:
>>> Upstream has renamed nl_handle to nl_sock.  Update iw to the new names
>>> and add #define for libnl-1.1.
>> I fixed this already, no?
>>
>> And renaming nl_handle to nl_sock means that it won't work with older,
>> released libs, afaict.
>>
>> johannes
> Unless my build chain is major league broken, it doesn't build for my
> system without doing this.
> 
> Lots of these warnings:
> 
> 
> In file included from info.c:11:
> iw.h:70: warning: 'struct nl_handle' declared inside parameter list
> iw.h:70: warning: its scope is only this definition or declaration,
> which is probably not what you want
> 
> and this error/warning combo that finally fails:
> 
> CC   genl.o
> In file included from genl.c:12:
> iw.h:70: warning: 'struct nl_handle' declared inside parameter list
> iw.h:70: warning: its scope is only this definition or declaration,
> which is probably not what you want
> genl.c:67: warning: 'struct nl_handle' declared inside parameter list
> genl.c:68: error: conflicting types for 'nl_get_multicast_id'
> iw.h:70: error: previous declaration of 'nl_get_multicast_id' was here
> genl.c: In function 'nl_get_multicast_id':
> genl.c:87: warning: passing argument 1 of 'genl_ctrl_resolve' from
> incompatible pointer type
> genl.c:95: warning: passing argument 1 of 'nl_send_auto_complete' from
> incompatible pointer type
> genl.c:106: warning: passing argument 1 of 'nl_recvmsgs' from
> incompatible pointer type
> make: *** [genl.o] Error 1
> 
> After this patch, it compiles cleanly.  I'll revert to libnl-1.1
> quickly, but I believe that it will work fine with this patch as well.
> 
Yep, builds cleanly and works for me with libnl-1.1 as well.

Pat

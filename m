Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:56346 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXFKPM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 11:12:59 -0400
Message-ID: <466D662C.7040809@oracle.com>
Date: Mon, 11 Jun 2007 08:11:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: andy@warmcat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH Try#8 3/4] cfg80211: Radiotap parser
References: <20070611095400.206844675@warmcat.com>	 <20070611095846.511945296@warmcat.com> <1181560668.29767.8.camel@johannes.berg>
In-Reply-To: <1181560668.29767.8.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi Andy,
> 
> Thanks for the repost.
> 
>> +/* Radiotap header iteration
>> + *   implemented in net/wireless/radiotap.c
>> + *
>> + * call __ieee80211_radiotap_iterator_init() to init a semi-opaque iterator
>> + * struct ieee80211_radiotap_iterator (no need to init the struct beforehand)
>> + * then loop calling __ieee80211_radiotap_iterator_next()... it returns -1
>> + * if there are no more args in the header, or the next argument type index
>> + * that is present.  The iterator's this_arg member points to the start of the
>> + * argument associated with the current argument index that is present,
>> + * which can be found in the iterator's this_arg_index member.  This arg
>> + * index corresponds to the IEEE80211_RADIOTAP_... defines.
>> + */
> 
> I don't think this will show up in the kdoc output, but it sure would be
> nice. Maybe it could be part of the description of
> ieee80211_radiotap_iterator as a 'how to use this iterator' section (see
> kernel-doc-nano-HOWTO.txt, it talks about sections)? Or maybe as
> kernel-doc for the functions themselves.
> 
>> +/**
>> + * ieee80211_radiotap_iterator_init - radiotap parser iterator initialization
> 
> Oh, you have kerneldoc comments in the source file. Does anyone know
> which is preferable? I usually put everything into the header file that
> is not implementation-detail.

We mostly put kernel-doc into source files (i.e., not header files).
We use kernel-doc in header files for inline functions, macros,
structs, unions, etc., but function kernel-doc blocks are meant to
immediately precede their functions.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37323 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZGCIpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 04:45:09 -0400
Message-ID: <4A4DC4EC.6010708@nokia.com>
Date: Fri, 03 Jul 2009 11:44:28 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.org" <linville@tuxdriver.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>,
	"Govindan Vidhya (Nokia-D/Tampere)" <vidhya.govindan@nokia.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Subject: Re: [PATCH v2] mac80211: minstrel: avoid accessing negative indices
 in rix_to_ndx()
References: <1246598708-5594-1-git-send-email-luciano.coelho@nokia.com> <1246609742.16770.54.camel@johannes.local>
In-Reply-To: <1246609742.16770.54.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-07-03 at 08:25 +0300, Luciano Coelho wrote:
>   
>> If rix is not found in mi->r[], i will become -1 after the loop.  This value
>> is eventually used to access arrays, so we were accessing arrays with a
>> negative index, which is obviously not what we want to do.  This patch fixes
>> this potential problem.
>>     
>
> This seems odd -- are you or are you not saying that this can happen in
> normal operation?
>   

This should *not* happen in normal operation, but it was happening due 
to a bug elsewhere (which has already been fixed).

>> @@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>>  	for (i = rix; i >= 0; i--)
>>  		if (mi->r[i].rix == rix)
>>  			break;
>> -	WARN_ON(mi->r[i].rix != rix);
>> +	WARN_ON(i < 0);
>>  	return i;
>>     
>
> If it can, this warning seems wrong.
>   

We were reaching this WARN_ON on our device some time ago, before we 
backported some other minstrel fixes from upstream.  So this patch 
doesn't fix an *active* bug, but it makes things more robust in case 
there is a bug elsewhere.  It is not good at all to access mi->r[-1], 
especially the code later which writes to this array and could 
potentially overwrite somebody else's memory.

-- 
Cheers,
Luca.


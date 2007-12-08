Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:27810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbXLHK4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 05:56:48 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1140757ugc
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2007 02:56:47 -0800 (PST)
Message-ID: <475A786E.60200@gmail.com> (sfid-20071208_105653_255562_5E39A0F7)
Date: Sat, 08 Dec 2007 11:56:46 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dcbw@redhat.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, jt@hpl.hp.com
Subject: Re: [PATCH] introduce WEXT scan capabilities
References: <1197073366.4563.15.camel@localhost.localdomain> <20071207.181221.09900510.davem@davemloft.net>
In-Reply-To: <20071207.181221.09900510.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Fri, 07 Dec 2007 19:22:46 -0500
>
>   
>> @@ -1040,6 +1049,16 @@ struct	iw_range
>>  	 * because each entry contain its channel index */
>>  
>>  	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
>> +
>> +	/* Do *NOT* use those fields, they are just used as padding to get
>> +	 * proper alignement with user space */
>> +	__s32		reserved1;
>> +	__s32		reserved2;
>> +	__u16		reserved3;
>> +	__s32		reserved4;
>> +	__u32		reserved5;
>> +
>> +	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
>>  };
>>  
>>  /*
>>     
>
> Major NACK.  These datastructure usages are complete wrong, and
> we have to stop spreading this problem instead of continuing on
> with it as if it's OK.
>   
But it seems like we have to deal with this api until nl80211/cfg80211 
is ready. But the situation is _worse_ without this patch (hidden ssid 
support is a huge mess).

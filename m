Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2976 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463Ab2BJJxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 04:53:25 -0500
Message-ID: <4F34E860.1020805@broadcom.com> (sfid-20120210_105334_744516_1B10F11B)
Date: Fri, 10 Feb 2012 10:50:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "David Laight" <David.Laight@ACULAB.COM>
cc: "Joe Perches" <joe@perches.com>,
	"David Miller" <davem@davemloft.net>,
	"jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers/net: Remove boolean comparisons to
 true/false
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E65@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E65@saturn3.aculab.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2012 10:32 AM, David Laight wrote:
>  
>> -	u32 func_encode = func |
>> -			((is_Pf == true ? 1 : 0) <<
> IGU_FID_ENCODE_IS_PF_SHIFT);
>> +	u32 func_encode = func | (is_Pf ? 1 : 0) <<
> IGU_FID_ENCODE_IS_PF_SHIFT;
> 
> This sort of thing is why I personally don't like 'bool' at all.
> If 'is_Pf' were an integer type that is known to only contain 0 or 1
> then the code can just be:

Properly chosing the bool type is not what is being handled by the
patch. Easiest way to convert would be using double inversion:

u32 func_encode = func | (!!is_Pf << IGU_FID_ENCODE_IS_PF_SHIFT);

The parenthesis are not needed due to operator precedence, but is more
clear this way (to me at least).

Gr. AvS


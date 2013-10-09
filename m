Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab3JIJRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 05:17:46 -0400
Message-ID: <1381310259.14186.6.camel@jlt4.sipsolutions.net> (sfid-20131009_111750_061320_4C488CFB)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <c_duttus@qti.qualcomm.com>
Cc: "j@w1.fi.com" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 09 Oct 2013 11:17:39 +0200
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F7251E7@aphydexd01a>
References: <1381150309-27293-1-git-send-email-c_duttus@qti.qualcomm.com>
	 <1381222569.13359.3.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F725129@aphydexd01a>
	 <1381307517.14186.5.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F7251E7@aphydexd01a>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-09 at 09:13 +0000, Undekari, Sunil Dutt wrote:
> > It's just a question of where to address this - in the kernel or the supplicant. In a way, I'd rather have the kernel reject it and do the policy of ignoring invalid stuff in the supplicant.
> The above statement from you made me to rethink for the following check in the patch sent.  
> 
> +               if (params->supported_oper_classes_len < 2 ||
> +                   params->supported_oper_classes_len > 253)
> +                       return -EINVAL;
> 
> Are you fine to return a failure for the invalid length for the supported_oper_classes_len? If yes, then shouldn't we also do the similar check for invalid supported_channels_len ( < 2 ).

Certainly works for me - but there should also be something like % 2 I
guess

johannes


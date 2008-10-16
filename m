Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49565 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYJPXni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:43:38 -0400
Message-ID: <48F7D1A8.4090608@lwfinger.net> (sfid-20081017_014341_486942_035D9D21)
Date: Thu, 16 Oct 2008 16:43:36 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostap: Fix sparse warnings
References: <48F761C1.9000109@lwfinger.net>	 (sfid-20081016_174625_529721_9312B9FF) <1224172212.735.79.camel@johannes.berg>
In-Reply-To: <1224172212.735.79.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2008-10-16 at 08:46 -0700, Larry Finger wrote:
> 
>> -	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, &local->pending_info);
>> +	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, (ulong *)&local->pending_info);
> 
> Shouldn't you just do this instead?
> 
> 
> --- hostapd_wlan.h
> +++ hostapd_wlan.h
> @@ ... @@
> -	long pending_info;
> +	unsigned long pending_info;

Yes. V2 of the patch coming.

Thanks,

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbbGVR4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 13:56:44 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Steve Pennington <sgpenn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Greg Donald <gdonald@gmail.com>, Joe Perches <joe@perches.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix incorrect type in assignment warning
References: <1437587411-31841-1-git-send-email-sgpenn@gmail.com>
Date: Wed, 22 Jul 2015 13:56:42 -0400
In-Reply-To: <1437587411-31841-1-git-send-email-sgpenn@gmail.com> (Steve
	Pennington's message of "Wed, 22 Jul 2015 12:50:11 -0500")
Message-ID: <wrfjsi8gaxet.fsf@redhat.com> (sfid-20150722_195659_727973_4E92E4D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve Pennington <sgpenn@gmail.com> writes:
> Repaced calls to htons and memcpy with a single call to put_unaligned_be16

You may want an 'l' in replaced, but not a biggie to me.

> to fix the following sparse warning:
> drivers/staging/rtl8723au/core/rtw_recv.c:1557:21: warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/core/rtw_recv.c:1557:21:    expected unsigned short [unsigned] [assigned] [usertype] len
> drivers/staging/rtl8723au/core/rtw_recv.c:1557:21:    got restricted __be16 [usertype] <noident>
>
> Signed-off-by: Steve Pennington <sgpenn@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_recv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
> index 274a4b6..ad0549c 100644
> --- a/drivers/staging/rtl8723au/core/rtw_recv.c
> +++ b/drivers/staging/rtl8723au/core/rtw_recv.c
> @@ -1554,8 +1554,7 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
>  	ether_addr_copy(ptr + ETH_ALEN, pattrib->src);
>  
>  	if (!bsnaphdr) {
> -		len = htons(len);
> -		memcpy(ptr + 12, &len, 2);
> +		put_unaligned_be16(len, ptr + 12);
>  	}

This one looks good to me.

Jes

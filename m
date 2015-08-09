Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33978 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbbHIQVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 12:21:42 -0400
Subject: Re: [PATCH] Add space after ,
To: Swee Hua Law <sweehua81@gmail.com>, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
References: <1439136530-4415-1-git-send-email-sweehua81@gmail.com>
Cc: aybuke.147@gmail.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55C77E13.8060300@lwfinger.net> (sfid-20150809_182202_217474_0CD4680B)
Date: Sun, 9 Aug 2015 11:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <1439136530-4415-1-git-send-email-sweehua81@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2015 11:08 AM, Swee Hua Law wrote:
> add space after , to fix coding style issue
>
> Signed-off-by: Swee Hua Law <sweehua81@gmail.com>
> ---
>   drivers/staging/rtl8723au/core/rtw_sreset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_sreset.c b/drivers/staging/rtl8723au/core/rtw_sreset.c
> index 29a29d9..48b7723 100644
> --- a/drivers/staging/rtl8723au/core/rtw_sreset.c
> +++ b/drivers/staging/rtl8723au/core/rtw_sreset.c
> @@ -71,7 +71,7 @@ static void sreset_restore_security_station(struct rtw_adapter *padapter)
>   			/* pairwise key */
>   			rtw_setstakey_cmd23a(padapter, (unsigned char *)psta, true);
>   			/* group key */
> -			rtw_set_key23a(padapter,&padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
> +			rtw_set_key23a(padapter, &padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
>   		}
>   	}
>   }
>

There are at least three problems with this patch. The first is that your 
subject is really awful. You need to say that you are fixing a checkpatch 
warning, and then say exactly what is happening. The second probalm also 
concerns the subject, which needs to specify what component is being changed. 
For drivers in staging, the usual way to do this is to start the subject line 
with "staging: rtl8723au: ...". The third problem is that you should fix *ALL* 
the problems with a given line whenever you touch it. That line is clearly over 
the 80-character limit.

NACK

Larry


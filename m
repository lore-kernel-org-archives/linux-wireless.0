Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbcGTLgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 07:36:07 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Colin King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Bhumika Goyal <bhumirks@gmail.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>,
	Daniil Leshchev <meleodr@gmail.com>,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: hal: check BT_Active and BT_State with correct bit pattern
References: <1468491688-17225-1-git-send-email-colin.king@canonical.com>
Date: Wed, 20 Jul 2016 07:36:05 -0400
In-Reply-To: <1468491688-17225-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Thu, 14 Jul 2016 11:21:28 +0100")
Message-ID: <wrfj8twwsfru.fsf@redhat.com> (sfid-20160720_133614_601853_6DE05D3A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> writes:
> From: Colin Ian King <colin.king@canonical.com>
>
> BT_Active and BT_State are being masked with 0x00ffffff so it the subsequent
> comparisons with 0xffffffff are therefore a buggy check.  Instead, check them
> against 0x00ffffff.
>
> Unfortunately I couldn't find a datasheet or hardware to see if 0xffffffff
> is an expected invalid bit pattern that should be checked before BT_Active and
> BT_State are masked with 0x00ffffff, so for now, this fix seems like the least
> risky approach.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I don't really know about the BT parts here, since I never did anything
with that part of the chip. Larry probably knows more.

The only question is whether fixing this bug changes behavior that has
unexpected side effects?

Cheers,
Jes

>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> index bfcbd7a..6989580 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> @@ -9824,7 +9824,7 @@ void BTDM_CheckBTIdleChange1Ant(struct rtw_adapter *padapter)
>  	BT_Polling = rtl8723au_read32(padapter, regBTPolling);
>  	RTPRINT(FBT, BT_TRACE, ("[DM][BT], BT_Polling(0x%x) =%x\n", regBTPolling, BT_Polling));
>  
> -	if (BT_Active == 0xffffffff && BT_State == 0xffffffff && BT_Polling == 0xffffffff)
> +	if (BT_Active == 0x00ffffff && BT_State == 0x00ffffff && BT_Polling == 0xffffffff)
>  		return;
>  	if (BT_Polling == 0)
>  		return;

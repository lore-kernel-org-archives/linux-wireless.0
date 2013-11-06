Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:37863 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3KFIMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 03:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131106074128.GA13475@elgon.mountain>
References: <20131106074128.GA13475@elgon.mountain>
Date: Wed, 6 Nov 2013 08:12:52 +0000
Message-ID: <CAFSJ42azGCbOPOEwGSsVDXti23NQuPxeqnW_VAj2x-qVguFd2Q@mail.gmail.com> (sfid-20131106_091259_589140_E4F96775)
Subject: Re: [patch] wcn36xx: harmless memory corruption bug in debugfs
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me, thanx!

On Wed, Nov 6, 2013 at 7:41 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On 64 bit systems we write past the end of the arg[] array.
>
> Fixes: 8e84c2582169 ('wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
> index 5b84f7a..ef44a2da 100644
> --- a/drivers/net/wireless/ath/wcn36xx/debug.c
> +++ b/drivers/net/wireless/ath/wcn36xx/debug.c
> @@ -126,7 +126,7 @@ static ssize_t write_file_dump(struct file *file,
>                 if (begin == NULL)
>                         break;
>
> -               if (kstrtoul(begin, 0, (unsigned long *)(arg + i)) != 0)
> +               if (kstrtou32(begin, 0, &arg[i]) != 0)
>                         break;
>         }
>



-- 
Best regards,
Eugene

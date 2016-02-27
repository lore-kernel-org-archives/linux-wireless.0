Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:43994 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756618AbcB0StC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2016 13:49:02 -0500
Message-ID: <1456598936.4436.6.camel@perches.com> (sfid-20160227_194906_525899_56964894)
Subject: Re: [PATCH] staging: rtl8723au: Fix line longer than 80 columns.
From: Joe Perches <joe@perches.com>
To: Edward Lipinsky <ellipinsky@gmail.com>, Larry.Finger@lwfinger.net,
	Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Sat, 27 Feb 2016 10:48:56 -0800
In-Reply-To: <20160227182841.GA3387@gmail.com>
References: <20160227182841.GA3387@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-02-27 at 10:28 -0800, Edward Lipinsky wrote:
> This patch fixes the checkpatch.pl warning:
> WARNING: line over 80 characters
[]
> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
[]
> @@ -1834,7 +1834,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
>  	}
>  	spin_unlock_bh(&pacl_node_q->lock);
>  
> -	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__, pacl_list->num);
> +	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__,
> +		  pacl_list->num);

It's generally nicer to break the line at the end
of the format sting like:

	DBG_8723A("%s, free acl_node_queue, num =%d\n",
		  __func__, pacl_list->num);

though it'd be even better to convert all of these
DBG_8723A uses to pr_debug

$ git ls-files drivers/staging/rtl8723au/ |	\
  xargs sed -r -i				\
	-e 's/\bDBG_8723A\b/pr_debug/g'		\
 	-e 's/\bMSG|8723A\b/pr_debug/g'


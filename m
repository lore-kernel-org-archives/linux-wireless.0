Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33787 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcCAQys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 11:54:48 -0500
Date: Tue, 1 Mar 2016 08:54:38 -0800
From: Edward Lipinsky <ellipinsky@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix line longer than 80 columns.
Message-ID: <20160301165438.GA19890@gmail.com> (sfid-20160301_175505_995109_6C8DF27B)
References: <20160227182841.GA3387@gmail.com>
 <1456598936.4436.6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1456598936.4436.6.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2016 at 10:48:56AM -0800, Joe Perches wrote:
> On Sat, 2016-02-27 at 10:28 -0800, Edward Lipinsky wrote:
> > This patch fixes the checkpatch.pl warning:
> > WARNING: line over 80 characters
> []
> > diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
> []
> > @@ -1834,7 +1834,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
> >  	}
> >  	spin_unlock_bh(&pacl_node_q->lock);
> >  
> > -	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__, pacl_list->num);
> > +	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__,
> > +		  pacl_list->num);
> 
> It's generally nicer to break the line at the end
> of the format sting like:
> 
> 	DBG_8723A("%s, free acl_node_queue, num =%d\n",
> 		  __func__, pacl_list->num);
> 
> though it'd be even better to convert all of these
> DBG_8723A uses to pr_debug
> 
> $ git ls-files drivers/staging/rtl8723au/ |	\
>   xargs sed -r -i				\
> 	-e 's/\bDBG_8723A\b/pr_debug/g'		\
>  	-e 's/\bMSG|8723A\b/pr_debug/g'
> 

Thanks for the feedback.  I will submit an updated patch.

Ed


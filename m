Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46528 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1KRTZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:25:22 -0500
Message-ID: <4EC6B10A.5020907@hauke-m.de> (sfid-20111118_202525_616919_74FFD96C)
Date: Fri, 18 Nov 2011 20:24:58 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] compat: avoid warning in compat_system_workqueue_create
References: <1321490374-24529-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1321490374-24529-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 01:39 AM, John W. Linville wrote:
> The check in the WARN_ON is inverted.
> 
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  compat/compat-2.6.36.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
> index aab25df..fe24da8 100644
> --- a/compat/compat-2.6.36.c
> +++ b/compat/compat-2.6.36.c
> @@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(system_nrt_wq);
>  void compat_system_workqueue_create()
>  {
>  	system_nrt_wq = create_singlethread_workqueue("events_nrt");
> -	WARN_ON(system_nrt_wq);
> +	WARN_ON(!system_nrt_wq);
>  }
>  
>  void compat_system_workqueue_destroy()

That was my fault, please apply this patch.

Hauke

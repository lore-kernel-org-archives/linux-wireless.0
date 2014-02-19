Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57259 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaBSQev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:34:51 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so581998pde.34
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 08:34:50 -0800 (PST)
Date: Wed, 19 Feb 2014 08:34:45 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 4/5] cfg80211: Add an option to hint indoor operation
Message-ID: <20140219163442.GL14296@garbanzo.do-not-panic.com> (sfid-20140219_173504_008506_6D913112)
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-5-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392824377-18254-5-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 05:39:36PM +0200, Ilan Peer wrote:
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8f5b460..b3768c2 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -65,11 +65,24 @@
>  #define REG_DBG_PRINT(args...)
>  #endif
>  
> +/**
> + * enum reg_request_treatment - regulatory request treatment
> + *
> + * @REG_REQ_OK: continue processing the regulatory request
> + * @REG_REQ_IGNORE: ignore the regulatory request
> + * @REG_REQ_INTERSECT: the regulatory domain resulting from this request should
> + *	be intersected with the current one.
> + * @REG_REQ_ALREADY_SET: the regulatory request will not change the current
> + *	regulatory settings, and no further processing is required.
> + * @REG_REQ_USER_HINT_HANDLED: a non alpha2  user hint was handled and no
> + *	further processing is required.

May be worth expanding on this to clarify why you mention non alpha2,
that is: regulatory hints that are not providing an alpha2 hint
can use this to let the regulatory core know it won't need to consider the
updating the last_request.

Come to think of it, it gets me wondering if we can eventually just then
move beacon hints to use this later.

  Luis

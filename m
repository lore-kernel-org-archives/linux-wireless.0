Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:23463 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbXJORvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 13:51:09 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1329814nfb
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 10:51:05 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] jiffies_round -> jiffies_round_relative conversion - rt2x00
Date: Mon, 15 Oct 2007 20:08:32 +0200
Cc: Anton Blanchard <anton@samba.org>, linux-wireless@vger.kernel.org,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org
References: <20071015053428.GA3257@kryten> <20071015053801.GB3257@kryten> <20071015054034.GC3257@kryten>
In-Reply-To: <20071015054034.GC3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710152008.32503.IvDoorn@gmail.com> (sfid-20071015_185119_354185_50CF6AC8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 October 2007, Anton Blanchard wrote:
> 
> When rounding a relative timeout we need to use round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 298faa9..06d9bc0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -30,7 +30,7 @@
>   * Interval defines
>   * Both the link tuner as the rfkill will be called once per second.
>   */
> -#define LINK_TUNE_INTERVAL	( round_jiffies(HZ) )
> +#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
>  #define RFKILL_POLL_INTERVAL	( 1000 )
>  
>  /*
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
> 



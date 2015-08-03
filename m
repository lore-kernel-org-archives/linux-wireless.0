Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33886 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbHCS16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:27:58 -0400
Received: by oigu133 with SMTP id u133so32016283oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:27:58 -0700 (PDT)
Date: Mon, 3 Aug 2015 13:27:30 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/5] wireless-regdb: Update U-NII-2c (5470 ~ 5725 MHz)
 rules for Taiwan (TW)
Message-ID: <20150803182730.GC21180@ubuntu-hedt> (sfid-20150803_202802_685852_9ADA1673)
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437622380-4154-2-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2015 at 11:32:56AM +0800, Chen-Yu Tsai wrote:
> Taiwan's Ministry of Transportation and Communications revised its
> frequency allocation rules [1] on 2014/11/17, allowing usage of 5600 ~
> 5650 MHz, previously allocated to weather radars, to U-NII applications
> with DFS support.
> 
> Also, the technical regulations [2] show that for 5470 ~ 5725 MHz U-NII
> applications, the peak transmit power shall not exceed the lesser of
> 250 mW (slightly less than 24 dBm) or 11 dBm + 10log B, where B is the
> 26dB emission bandwidth in MHz. This is slightly more than 23 dBm for
> 20 MHz channels.
> 
> This patch updates both. Also add links to the two documents into the
> database.
> 
> [1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
> [2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Sorry for the slow response to these patches.

> ---
>  db.txt | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 982db34..5114557 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1118,11 +1118,17 @@ country TT: DFS-FCC
>  	(5490 - 5730 @ 160), (24), DFS
>  	(5735 - 5835 @ 80), (30)
>  
> +# Source:
> +# Table of Frequency Allocations of Republic of China (Taiwan) / Nov 2014:
> +#   http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc& \
> +#      filedisplay=Table+of+radio+frequency+allocation.doc
> +# LP0002 Low-power Radio-frequency Devices Technical Regulations / 28 Jun 2011:
> +#   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
> +#   (section 3.10.1, 4.7)
>  country TW: DFS-JP
>  	(2402 - 2472 @ 40), (30)
>  	(5270 - 5330 @ 40), (17), DFS
> -	(5490 - 5590 @ 80), (30), DFS
> -	(5650 - 5710 @ 40), (30), DFS
> +	(5470 - 5725 @ 160), (23), DFS

Based on [2], it looks like this range requires TPC, in which case the
power limit should be dropped by 3 dB on account of our not supporting
TPC.

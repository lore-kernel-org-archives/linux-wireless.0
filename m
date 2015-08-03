Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36820 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbbHCSko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:40:44 -0400
Received: by obnw1 with SMTP id w1so105442255obn.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:40:43 -0700 (PDT)
Date: Mon, 3 Aug 2015 13:40:15 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/5] wireless-regdb: Add U-NII-1 (5150 ~ 5250 MHz)
 band for Taiwan (TW)
Message-ID: <20150803184015.GE21180@ubuntu-hedt> (sfid-20150803_204047_544548_4DD65954)
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437622380-4154-4-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2015 at 11:32:58AM +0800, Chen-Yu Tsai wrote:
> Taiwan's Ministry of Transportation and Communications revised its
> frequency allocation rules [1] on 2014/11/17, opening up 5150 ~ 5250
> MHz to U-NII applications.
> 
> Taiwan's regulatory body, NCC, officially stated [3][4] that until
> the technical regulatory standard [2] are updated to cover this part
> of the spectrum, FCC rules (part 15E, 15.407, effective 2014/06/02)
> shall serve in its place.
> 
> Also add AUTO-BW to this and the next (5250 ~ 5350 MHz) rule, so the
> system can actually use VHT160 channels spanning these two rules.
> 
> [1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
> [2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
> [3] http://www.rheintech.com/our-blog/item/585-taiwan-ncc-opens-5150-5250-mhz-for-wireless-devices
> [4] Proposal #10312260 (p.6, Chinese),
>     http://www.etc.org.tw/_library/K00/%E9%9B%BB%E4%BF%A1%E7%B5%82%E7%AB%AF%E8%A8%AD%E5%82%99%E5%AF%A9%E9%A9%97/1031223_nccqa56.pdf
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  db.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db.txt b/db.txt
> index 8a05c57..cadd52c 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1127,7 +1127,8 @@ country TT: DFS-FCC
>  #   (section 3.10.1, 4.7)
>  country TW: DFS-JP
>  	(2400 - 2483.5 @ 40), (30)
> -	(5250 - 5350 @ 80), (17), DFS
> +	(5150 - 5250 @ 80), (30), AUTO-BW
> +	(5250 - 5350 @ 80), (17), DFS, AUTO-BW

It would really make more sense for an update to the US power limit in
5150-5250 to precede this one if you're using the US rules as the
justification for the power limit here. Going through these patches in
order, I was initially confused here why it didn't match the US rule
until I looked at the next patch.

But, as I mentioned in the reply to that patch, I think the change to
the US power limit is incorrect, thus this one would be incorrect as
well.

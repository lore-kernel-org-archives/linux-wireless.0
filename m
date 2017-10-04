Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53759 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdJDJJZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 05:09:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: make const array reg_hole_list static,
 reduces object code size
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170919204019.30804-1-colin.king@canonical.com>
References: <20170919204019.30804-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <0458c03b374e494892d03dd4b6a889c9@euamsexm01e.eu.qualcomm.com> (sfid-20171004_110943_436832_5A331DB6)
Date: Wed, 4 Oct 2017 11:09:11 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> Don't populate the read-only array reg_hole_list on the stack, instead make
> it static.  Makes the object code smaller by over 200 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   57518	  15248	      0	  72766	  11c3e	debug.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   57218	  15344	      0	  72562	  11b72	debug.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

eba0f28473b2 ath9k: make const array reg_hole_list static, reduces object code size

-- 
https://patchwork.kernel.org/patch/9960183/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

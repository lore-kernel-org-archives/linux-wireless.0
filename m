Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33231 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1CQSld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:41:33 -0400
Received: by vxi39 with SMTP id 39so2892245vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:41:33 -0700 (PDT)
Message-ID: <4D8255D9.7010009@lwfinger.net>
Date: Thu, 17 Mar 2011 13:41:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix memset argument order
References: <1300385337-27760-1-git-send-email-imirkin@alum.mit.edu>
In-Reply-To: <1300385337-27760-1-git-send-email-imirkin@alum.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2011 01:08 PM, Ilia Mirkin wrote:
> These were found using the following semantic match:
> //<smpl>
> @@expression E1; type T;@@
> * memset(E1, ... * sizeof(T) * ..., ...);
> //</smpl>
>
> Also take this opportunity to remove the unnecessary void* casts.
>
> Signed-off-by: Ilia Mirkin<imirkin@alum.mit.edu>
> ---
>
> I do not have the hardware for this, but reading the code, it makes
> sense that the length of the memsets is currently the second argument
> instead of the third.
>
>   drivers/net/wireless/rtlwifi/efuse.c |   31 +++++++++++++++----------------
>   1 files changed, 15 insertions(+), 16 deletions(-)

ACK and Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks for finding these.

Larry

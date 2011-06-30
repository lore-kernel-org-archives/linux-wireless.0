Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42281 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1F3WDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 18:03:24 -0400
Received: by iwn6 with SMTP id 6so2294917iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 15:03:24 -0700 (PDT)
Message-ID: <4E0CF2A4.7070207@lwfinger.net> (sfid-20110701_000327_730061_1E156DFD)
Date: Thu, 30 Jun 2011 17:03:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192de/phy.c: fix udelay() usage
References: <4e0cea92.d87Od1Tkbar3iIK/%Larry.Finger@lwfinger.net> <20110630143358.cf4d4e2f.akpm@linux-foundation.org>
In-Reply-To: <20110630143358.cf4d4e2f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 04:33 PM, Andrew Morton wrote:
> Also, there are eleventy billion instances of
>
> 	for (j = 0; j<  N; j++)
> 		udelay(MAX_STALL_TIME);
>
> which seem rather unnecessary.
>
> static inline void rtl8192c_udelay(unsigned n)
> {
> 	if (n<  1000)
> 		udelay(n);
> 	else
> 		mdelay(n / 1000);
> }
>
> or something.

As MAX_STALL_TIME is 50, I have done the math for (N * 50) / 1000 and changed 
the loop to the equivalent mdelay call.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38589 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFWBdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 21:33:37 -0400
Received: by mail-it0-f49.google.com with SMTP id h190so53873349ith.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 18:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466184857-21605-1-git-send-email-weiyj_lk@163.com>
References: <1466184857-21605-1-git-send-email-weiyj_lk@163.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Jun 2016 11:33:17 +1000
Message-ID: <CAGRGNgVFOY5kM8Z4VeyXZA_-rTn1Pk7-PW3XVhkOMhS6Gm3kWQ@mail.gmail.com> (sfid-20160623_033350_478822_1F9C2111)
Subject: Re: [PATCH] staging: wilc1000: fix return value check in wlan_initialize_threads()
To: weiyj_lk@163.com
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Sat, Jun 18, 2016 at 3:34 AM,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function kthread_run() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The return value of wlan_initialize_threads() is only checked to be
non-zero, so this looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

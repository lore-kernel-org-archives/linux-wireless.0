Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46031 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbbKZNc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:32:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless: airo: re-use mac_pton()
References: <1447856201-70408-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 26 Nov 2015 15:32:50 +0200
In-Reply-To: <1447856201-70408-1-git-send-email-andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Wed, 18 Nov 2015 16:16:41 +0200")
Message-ID: <87poywnawt.fsf@kamboji.qca.qualcomm.com> (sfid-20151126_143306_107150_4EB0590C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> mac_pton() converts 6-byte MAC / BSSID to binary format. Change an open coded
> variant by the generic one.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This breaks compilation:

  CC [M]  drivers/net/wireless/cisco/airo.o
drivers/net/wireless/cisco/airo.c: In function ‘proc_APList_on_close’:
drivers/net/wireless/cisco/airo.c:5141:49: error: request for member ‘ap’ in something not a structure or union

-- 
Kalle Valo

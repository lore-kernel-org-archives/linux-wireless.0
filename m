Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbK0JzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 04:55:06 -0500
Message-ID: <1448617987.15393.102.camel@linux.intel.com> (sfid-20151127_105510_476989_AC32B4EE)
Subject: Re: [PATCH 1/1] wireless: airo: re-use mac_pton()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Nov 2015 11:53:07 +0200
In-Reply-To: <87poywnawt.fsf@kamboji.qca.qualcomm.com>
References: <1447856201-70408-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <87poywnawt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 15:32 +0200, Kalle Valo wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> 
> > mac_pton() converts 6-byte MAC / BSSID to binary format. Change an
> > open coded
> > variant by the generic one.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> This breaks compilation:
> 
>   CC [M]  drivers/net/wireless/cisco/airo.o
> drivers/net/wireless/cisco/airo.c: In function
> ‘proc_APList_on_close’:
> drivers/net/wireless/cisco/airo.c:5141:49: error: request for member
> ‘ap’ in something not a structure or union

Sorry for that, seems rebase issue since it was an old fix in my local
tree.

Seems it should be
  mac_pton(data->wbuffer + i * 6 * 3, APList_rid->ap[i]);

I will send updated version later.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy


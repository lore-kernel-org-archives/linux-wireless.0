Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27851 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1KQTHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:07:02 -0500
Message-ID: <4EC55B4A.7050001@qca.qualcomm.com> (sfid-20111117_200731_167867_C7339A1E)
Date: Thu, 17 Nov 2011 21:06:50 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <mcgrof@frijolero.org>, <linux-kernel@vger.kernel.org>,
	<linux-mips@linux-mips.org>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <ralf@linux-mips.org>,
	<juhosg@openwrt.org>, <rodrigue@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <rmanohar@qca.qualcomm.com>,
	<patches@linaro.org>
Subject: Re: [PATCH] ath9k: rename ath9k_platform.h to ath_platform.h
References: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>	<4EC29534.7010502@adurom.com> <CADPsn1YDOu9Xyu1yDfs5Z0LjGzBL-Rx6Fk35AT8n-8oOPhPzHA@mail.gmail.com>
In-Reply-To: <CADPsn1YDOu9Xyu1yDfs5Z0LjGzBL-Rx6Fk35AT8n-8oOPhPzHA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sangwook,

On 11/16/2011 01:34 PM, Sangwook Lee wrote:

> 
> On 15 November 2011 16:37, Kalle Valo <kvalo@adurom.com
> <mailto:kvalo@adurom.com>> wrote:
> 
>     Hi Sangwook,
> 
>     On 11/15/2011 01:23 PM, Sangwook Lee wrote:
>     > The patch series proposes to rename ath9k_platform.h to
>     "ath_platform.h
>     > This header file handles platform data used only for ath9k,
>     > but it can used by ath6k as well. We can take "wl12xx.h" as
>     > as a example. Please let us change this file name so that
>     > other Atheors WLANs use this file for their own platform data
> 
>     ath9k and ath6kl are very different devices, I'm not sure if sharing a
>     platfrom struct between the two is really a good idea. Most likely there
>     is very little the two drivers can share. What are your plans here?
>      
> 
> 
> As you know, if ath6kl is not SDIO powered (in most of cases, including
> mine)
> we need to use platform struct in order to control reset/power line,
> because ath6k is designed for mobile and embedded devices.

We have been actually planning to do the same, but it's still on our
todo list. If you can do this it would be awesome.

Also we need to provide some clock configuration from the board file and
I'm sure there will be more in the future. But let's start with the
power control.

> so I found out that there is already header file for ath9k's platform
> struct. How about using the one header file instead of
> "include/linux/ath9k_platform.h"
> , and "include/linux/ath6k_platform.h" ?
>  
> 
>     I myself was thinking that we would have include/linux/ath6kl.h
>     dedicated just for ath6kl. That would makes things simpler.
> 
> But since I don't know much about ath9k, if you want to make the
> separate header file for ath6kl's own struct, It would be fine as well.

Yeah, I really would like to use separate file for ath6kl.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53307 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2GRPUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 11:20:53 -0400
Received: by qcro28 with SMTP id o28so1031961qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 08:20:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342622762.5363.41.camel@cumari.coelho.fi>
References: <1342615289-3088-1-git-send-email-mohammed@qca.qualcomm.com>
	<1342622762.5363.41.camel@cumari.coelho.fi>
Date: Wed, 18 Jul 2012 20:50:53 +0530
Message-ID: <CAD2nsn0s9V4L6W_AzTqrjgZQT1a3SJdLeCXAV9YDbGE+qX4QHw@mail.gmail.com> (sfid-20120718_172057_456614_9428667B)
Subject: Re: [PATCH] cfg80211: Fix mutex locking in reg_last_request_cell_base
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

On Wed, Jul 18, 2012 at 8:16 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-07-18 at 18:11 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> should fix the following issue
>>
>>       [ 3229.815012] [ BUG: lock held when returning to user space! ]
>>       [ 3229.815016] 3.5.0-rc7-wl #28 Tainted: G        W  O
>>       [ 3229.815017]
>>       ------------------------------------------------
>>       [ 3229.815019] wpa_supplicant/5783 is leaving the kernel with locks still held!
>>       [ 3229.815022] 1 lock held by wpa_supplicant/5783:
>>       [ 3229.815023]  #0: (reg_mutex){+.+.+.}, at: [<fa65834d>]
>>       reg_last_request_cell_base+0x1d/0x60 [cfg80211]
>>
>> Cc: Luis Rodriguez <mcgrof@gmail.com>
>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>> ---
>
> Tested-by: Luciano Coelho <coelho@ti.com>
>
> This actually also fixes a similar circular lock dependency bug when
> starting AP mode with hostapd (which is the case I tested this patch
> on): http://pastebin.com/AVczE1Ej

thanks !

>
> --
> Luca.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35175 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLEWeL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 17:34:11 -0500
Received: by mail-oi0-f66.google.com with SMTP id v84so38589930oie.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 14:34:11 -0800 (PST)
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net> (sfid-20161205_233415_194504_4F08806E)
Date: Mon, 5 Dec 2016 16:34:08 -0600
MIME-Version: 1.0
In-Reply-To: <20161205213447.GJ8176@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2016 03:34 PM, Dan Carpenter wrote:
> On Thu, Dec 01, 2016 at 07:48:29PM -0600, Larry Finger wrote:
>> --- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
>> +++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
>> @@ -27,6 +27,29 @@
>>
>>  #include	"../wifi.h"
>>
>> +#ifdef CONFIG_RTLWIFI_DEBUG
>> +
>> +#define BTC_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
>> +#define BTC_TRACE(fmt)						\
>> +do {								\
>> +	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
>> +	if (!rtlpriv)					\
>> +		break;						\
>> +	RT_TRACE_STRING(rtlpriv, COMP_COEX, DBG_LOUD, fmt);	\
>> +} while (0)
>> +
>
> This sort of macro is exactly when the rtl drivers spent so long in
> staging...  Subsystems should not invent their own tracing but in
> particular these macros are so very very ugly.
>
> It's just super frustrating to even look at this...
>
> There are a lot of staging drivers I feel good about when they leave.
> The HyperV drivers.  The IIO stuff.  A lot of the media stuff and
> generally the media tree is getting better and better.  I like comedi
> and unisys, those are in staging, but they are great and could move out
> any time as far as I'm concerned.
>
> But this patch just makes me super discouraged.  What are we doing???

Dan,

It would not matter to me if these drivers got moved to staging, but there are a 
lot of users whose distros do not build staging drivers that would be very unhappy.

Can you point me to a driver with a better way to conditionally dump a debugging 
string to the logs?

Larry

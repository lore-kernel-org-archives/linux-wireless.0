Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab1EMHmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 03:42:05 -0400
Received: by bwz15 with SMTP id 15so1915230bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 00:42:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305231034.12586.1038.camel@cumari>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	<1305104068-32240-7-git-send-email-eliad@wizery.com>
	<1305231034.12586.1038.camel@cumari>
Date: Fri, 13 May 2011 10:42:04 +0300
Message-ID: <BANLkTi=r62YDMmeumYzsEiLCjZ8hh9+kFA@mail.gmail.com> (sfid-20110513_094210_181124_9CDA6F17)
Subject: Re: [PATCH 6/7] wl12xx: add ps completion event
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 11:10 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
>> Signal when psm was entered successfully, if the completion
>> variable is being set.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/event.c  |    7 +++++++
>>  drivers/net/wireless/wl12xx/wl12xx.h |    1 +
>>  2 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
>> index ae69330..21e52ed 100644
>> --- a/drivers/net/wireless/wl12xx/event.c
>> +++ b/drivers/net/wireless/wl12xx/event.c
>> @@ -135,6 +135,13 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
>>
>>               /* enable beacon early termination */
>>               ret = wl1271_acx_bet_enable(wl, true);
>> +             if (ret < 0)
>> +                     break;
>> +
>> +             if (wl->ps_compl) {
>> +                     complete(wl->ps_compl);
>> +                     wl->ps_compl = NULL;
>> +             }
>>               break;
>>       default:
>>               break;
>> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
>> index daf941d..cf08a9d 100644
>> --- a/drivers/net/wireless/wl12xx/wl12xx.h
>> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
>> @@ -512,6 +512,7 @@ struct wl1271 {
>>       unsigned int rx_filter;
>>
>>       struct completion *elp_compl;
>> +     struct completion *ps_compl;
>>       struct delayed_work elp_work;
>>       struct delayed_work pspoll_work;
>>
>
> This patch doesn't make sense by itself, without the next one.  Can you
> squash them?
>
sure.

Eliad.

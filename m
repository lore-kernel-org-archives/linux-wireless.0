Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56698 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1K0Pn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 10:43:58 -0500
Received: by wwp14 with SMTP id 14so7257561wwp.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 07:43:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322386685.4044.8.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322386685.4044.8.camel@jlt3.sipsolutions.net>
Date: Sun, 27 Nov 2011 10:43:57 -0500
Message-ID: <CALGY4fvbUxPcf=Ay4kW2UoHekPgaieCKye7T=pqo9YKXsNva=w@mail.gmail.com> (sfid-20111127_164404_934565_6AFC2F7C)
Subject: Re: [PATCH] mac80211: fix race condition caused by late addBA resp
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>
>
>> +     del_timer_sync(&tid_tx->addba_resp_timer);
>> +
>> +     /*
>> +      * Test that we are not stopping agg session now.
>> +      * Since addba_resp_timer may have just finished we need to
>> +      * check HT_AGG_STATE_STOPPING too.
>> +      */
>> +     if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state)
>> +         || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
>> +#ifdef CONFIG_MAC80211_HT_DEBUG
>> +             printk(KERN_DEBUG "got addBA resp for tid %d but we are not "
>> +                             "(or no longer) expecting expecting it\n",
>> +                     tid);
>> +#endif
>> +             goto out;
>> +     }
>> +
>>       if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
>>  #ifdef CONFIG_MAC80211_HT_DEBUG
>>               printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
>
> You can't do this -- if this happens and the dialog token is bad the
> session will linger forever since the timer is now dead.

   I'm not sure I understand what you mean by this and how my patch
affects dialog_token. I'd appreciate if you could explain this in some
detail.

>
> Also please move the bool operators to the end of the line rather than
> the start:
>        if (test_bit(...) ||
>            test_bit(...)) {
>
> Other than that the patch looks fine.

  I saw you have posted couple of newer versions of this. Shall I
still make this change and repost?

  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com

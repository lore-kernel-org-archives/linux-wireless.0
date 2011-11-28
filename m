Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50933 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1K1GfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 01:35:17 -0500
Received: by wwp14 with SMTP id 14so8422654wwp.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 22:35:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322412918.4044.37.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322394638.4044.32.camel@jlt3.sipsolutions.net>
	<1322394800.4044.33.camel@jlt3.sipsolutions.net>
	<CALGY4fufCM2SvYLFaab1TzSr36b55bguFoZRtYZhLuXGMZLG1w@mail.gmail.com>
	<1322412918.4044.37.camel@jlt3.sipsolutions.net>
Date: Mon, 28 Nov 2011 08:35:16 +0200
Message-ID: <CANUX_P0E=bhBrGnYOJ7yt8mOgixNNPP5UKC_Cv5jL9uNiNFH9A@mail.gmail.com> (sfid-20111128_073521_846900_1754CDD8)
Subject: Re: [PATCH v3] mac80211: fix race condition caused by late addBA response
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nikolay Martynov <mar.kolya@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 27, 2011 at 18:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-11-27 at 11:12 -0500, Nikolay Martynov wrote:
>
>> > -       del_timer(&tid_tx->addba_resp_timer);
>> > +       del_timer_sync(&tid_tx->addba_resp_timer);
>> >
>> >  #ifdef CONFIG_MAC80211_HT_DEBUG
>> >        printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
>> >  #endif
>> > +
>> > +       /*
>> > +        * addba_resp_timer may have fired before we got here, and
>> > +        * caused WANT_STOP to be set. STOPPING should not be set
>> > +        * as we're under the mutex, but check it anyway.
>> > +        */
>> > +       if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
>> > +           test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
>>
>>   Just a small comment about comment :).
>>   If I understand correctly process of stopping tx agg looks as following:
>>   1) Call to ___ieee80211_stop_tx_ba_session. This removes
>> HT_AGG_STATE_WANT_STOP (in ht.c) and adds HT_AGG_STATE_STOPPING. It
>> holds mutex during duration of the call.
>>   2) Call to ieee80211_stop_tx_ba_cb. This destroys the actual tx_tid.
>> It holds mutex during duration of the call.
>
>>   But between these two calls we have HT_AGG_STATE_STOPPING and no
>> mutex. I think at this time we can receive addBA resp and that's why I
>> was checking for HT_AGG_STATE_STOPPING in my original patch.
>
> Indeed, I missed that. It's due to the driver callback again.
>
> How about this?
>
> /*
>  * addba_resp_timer may have fired before we got here, and
>  * caused WANT_STOP to be set. If the stop then was already
>  * processed further, STOPPING might be set.
>  */
>
>
> Did you notice that I moved this code to after the dialog token check?
>

Don't you think we should also send a delBA ? The AP thinks we will Tx
in Agg and basically we are now out of sync.

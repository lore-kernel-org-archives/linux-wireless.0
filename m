Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54679 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2FDGaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 02:30:15 -0400
Received: by bkcji2 with SMTP id ji2so3267780bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 23:30:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338790597.4512.3.camel@jlt3.sipsolutions.net>
References: <1338755422-13220-1-git-send-email-arik@wizery.com> <1338790597.4512.3.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 4 Jun 2012 09:29:59 +0300
Message-ID: <CA+XVXfeRvmT3Yp-sNVj6YU7AQ3cofY+TLiyUqp1GLP+5Zr4SZw@mail.gmail.com> (sfid-20120604_083020_249902_97A994DF)
Subject: Re: [PATCH] mac80211: stop Rx during HW reconfig
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 4, 2012 at 9:16 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2012-06-03 at 23:30 +0300, Arik Nemtsov wrote:
>
>> +++ b/net/mac80211/rx.c
>> @@ -3023,6 +3023,9 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>       if (WARN_ON(!sband))
>>               goto drop;
>>
>> +     /* make sure we get the latest values for the next variable checks */
>> +     smp_rmb();
>> +
>
> That doesn't make a lot of sense I think? This entire thing is
> inherently racy, you could be processing RX already even while just
> setting the variable in the other code. I'm not really sure what the
> effect of this here is, but it's certainly a hot-path.

Yea I wondered about that myself, but I saw spinlocks are being used
later inside ieee80211_rx_handlers(), so there's a memory barrier
anyway IIUC.

You're right that we still can get very old RX from before the
reconfig, but this is not the one I was worried about (and it doesn't
happen in practice).
This one worries me (we actually had something similar)

1. reconfig starts
2. AP starts beaconing
3. remote sta sends ADDBA
4. remote sta is added by mac80211

Since in_reconfig is set before the start of the AP, in this sense we
won't get state changes during the reconfig.

>
>> +       /*
>> +        * Stop all Rx during the reconfig. We don't want state changes
>> +        * or driver callbacks while this is in progress.
>> +        */
>> +       local->in_reconfig = true;
>> +       smp_wmb();
>
>
> If anything, you should probably put this right into
> ieee80211_restart_hw() rather than the reconfig function? It's not
> needed for suspend/resume anyway since we check that separately.

Sure, even earlier is better I guess.

Arik

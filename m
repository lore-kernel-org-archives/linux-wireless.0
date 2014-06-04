Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58046 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFDFN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 01:13:27 -0400
Received: by mail-qg0-f41.google.com with SMTP id j5so15028447qga.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2014 22:13:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401825537.4157.43.camel@jlt4.sipsolutions.net>
References: <1401443081-10277-1-git-send-email-janusz.dziedzic@tieto.com>
	<1401825537.4157.43.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Jun 2014 07:13:26 +0200
Message-ID: <CALhHN=qXjGa09JNox5qOvjR6RDv_=N-465cV-LmgU-NCCyA53w@mail.gmail.com> (sfid-20140604_071330_667205_81786927)
Subject: Re: [PATCH] mac80211: allow tx via monitor iface when DFS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 June 2014 21:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-30 at 11:44 +0200, Janusz Dziedzic wrote:
>
>> +     struct cfg80211_chan_def chandef;
>>       u16 len_rthdr;
>>       int hdrlen;
>>
>> @@ -1721,9 +1721,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>>       }
>>
>>       if (chanctx_conf)
>> -             chan = chanctx_conf->def.chan;
>> +             chandef = chanctx_conf->def;
>>       else if (!local->use_chanctx)
>> -             chan = local->_oper_chandef.chan;
>> +             chandef = local->_oper_chandef;
>
> Why are you making a copy of the chandef - wouldn't a pointer work just
> as well?
>
No special reason (chandef is quite small), should I change this to
pointer and send v2?

BR
Janusz

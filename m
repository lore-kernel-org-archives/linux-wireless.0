Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33372 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbaDHJYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 05:24:18 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so648910wgg.14
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 02:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396946168.5936.0.camel@jlt4.sipsolutions.net>
References: <1396609363-24539-1-git-send-email-michal.kazior@tieto.com>
	<1396946168.5936.0.camel@jlt4.sipsolutions.net>
Date: Tue, 8 Apr 2014 11:24:16 +0200
Message-ID: <CA+BoTQ=H-zYoK5q4j8rKFU-XVXx=ydwjYiWh8ZoFGOCr9LyrVQ@mail.gmail.com> (sfid-20140408_112422_399693_44076B6E)
Subject: Re: [PATCH] mac80211: fix radar_enabled propagation
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 10:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-04-04 at 13:02 +0200, Michal Kazior wrote:
>> If chandef had non-HT width it was possible for
>> radar_enabled update to not be propagated properly
>> through drv_config(). This happened because
>> ieee80211_hw_conf_chan() would never see different
>> local->hw.conf.chandef and local->_oper_chandef.
>>
>> This wasn't a problem with HT chandefs because
>> _oper_chandef width is reset to non-HT in
>> ieee80211_free_chanctx() making
>> ieee80211_hw_conf_chan() to kick in.
>>
>> This problem led (at least) ath10k to not start
>> CAC if prior CAC was cancelled and both CACs were
>> requested for identical non-HT chandefs.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  net/mac80211/chan.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
>> index 122033d..b472daa 100644
>> --- a/net/mac80211/chan.c
>> +++ b/net/mac80211/chan.c
>> @@ -269,7 +269,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
>>
>>       if (!local->use_chanctx) {
>>               local->_oper_chandef = *chandef;
>> -             ieee80211_hw_config(local, 0);
>> +             ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>
> I'm not convinced that this is the right way to do this - couldn't
> ieee80211_hw_conf_chan() detect the radar detection requirement change?

I agree but on the other hand propagating local->mtx locking
requirement for using local->radar_detect_enabled in
ieee80211_hw_conf_chan() (and thus ieee80211_hw_config()) is probably
going to be a cascade of pain.


Michał

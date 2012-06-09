Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53520 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2FIVWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:22:30 -0400
Received: by obbtb18 with SMTP id tb18so4397182obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 14:22:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339231988.4539.35.camel@jlt3.sipsolutions.net>
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
 <1339187469-12778-2-git-send-email-jason@cozybit.com> <1339231988.4539.35.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 9 Jun 2012 14:22:09 -0700
Message-ID: <CAPjQAd9VY3+K9qTnqjpAJPUspUsSyPM0imM=o05JOWG1cQQWHg@mail.gmail.com> (sfid-20120609_232305_946133_DF223E26)
Subject: Re: [PATCH 1/2] mac80211: Keep tx rate averages for mesh peers for
 better metric calculation.
To: devel@lists.open80211s.org
Cc: Jason Abele <jason@cozybit.com>, nbd <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Sat, Jun 9, 2012 at 1:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 13:31 -0700, Jason Abele wrote:
>> From: Javier Cardona <javier@cozybit.com>
>>
>> The mesh metric is computed every time it was requested by the path
>> selection framework.  At that time only the last_tx_rate was taken into
>> account when computing the metric.  This last frame may not reflect the
>> average data rate that was possible ver that peer link (it could be a
>> management frame, a rate control probe, or other outlier).
>>
>> This patch maintains an average tx rate for each peer link which is used
>> in metric calculation.
>
> I don't think this makes a lot of sense, the TX rate is supposed to be
> the "best rate" that the rate control algorithm decided on

Yes, but last_tx_rate is not that.  This is a snippet from
ieee80211_tx_h_rate_ctrl():

txrc.skb = tx->skb;
txrc.reported_rate.idx = -1;
(...)
rate_control_get_rate(tx->sdata, tx->sta, &txrc);
(...)
if (txrc.reported_rate.idx < 0) {
        txrc.reported_rate = info->control.rates[0];
            if (tx->sta && ieee80211_is_data(hdr->frame_control))
                 tx->sta->last_tx_rate = txrc.reported_rate;
} else if (tx->sta)
            tx->sta->last_tx_rate = txrc.reported_rate;

last_tx_rate is just the last rate used to send a data frame, not the
average data rate.  For instance, if the last data frame is a
broadcast frame transmitted at the lowest rate, last_tx_rate will
report that low rate and not the much higher rate used for unicast
data frames.  Using that low rate to compute the airtime link metric
is an aberration.

Cheers,

Javier

>
>> +++ b/net/mac80211/sta_info.h
>> @@ -330,6 +330,7 @@ struct sta_info {
>>       unsigned long tx_retry_failed, tx_retry_count;
>>       /* moving percentage of failed MSDUs */
>>       unsigned int fail_avg;
>> +     struct ewma avg_rate;
>
> and in any case this is missing kernel-doc
>
> johannes
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

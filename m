Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6E1C67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15743208E7
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KQzwJpee"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15743208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbeJGBXN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 21:23:13 -0400
Received: from nbd.name ([46.4.11.11]:37476 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbeJGBXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 21:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2Jo9oIKSx8W3rw76PUGvJvl4AD2oyyBMuDR1GBkfAe0=; b=KQzwJpeeS2zg6AkA4bb162JRDF
        hQ71dn4JaNfR0gr5MTAemBtkPqNCmTqbaJMPAbRzRYqJZpw9Zf7yiPfMSuuFjmY6EwEra9ihZJnnS
        wrZV4mQdpI6AzbPbsJuDinnZhP1h0BO+3DBNG8ZQ9D7XUuAaOevdh5g8sVrQpLKkK6QU=;
Subject: Re: [PATCH 9/9] mac80211: rc80211_minstrel: remove variance / stddev
 calculation
To:     Dave Taht <dave.taht@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew McGregor <andrewmcgr@google.com>
References: <20181006173507.7316-1-nbd@nbd.name>
 <20181006173507.7316-9-nbd@nbd.name>
 <CAA93jw48KRNTcGy_RecY8u-1wqL9uWzeP4JK4-pgf9LV9ihzDQ@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <43da677d-60b8-b940-4d89-d27578f9c20b@nbd.name>
Date:   Sat, 6 Oct 2018 20:18:52 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAA93jw48KRNTcGy_RecY8u-1wqL9uWzeP4JK4-pgf9LV9ihzDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-06 19:59, Dave Taht wrote:
> On Sat, Oct 6, 2018 at 10:37 AM Felix Fietkau <nbd@nbd.name> wrote:
>>
>> When there are few packets (e.g. for sampling attempts), the exponentially
>> weighted variance is usually vastly overestimated, making the resulting data
>> essentially useless. As far as I know, there has not been any practical use
>> for this, so let's not waste any cycles on it.
>>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  net/mac80211/rc80211_minstrel.c            |  6 -----
>>  net/mac80211/rc80211_minstrel.h            | 26 +---------------------
>>  net/mac80211/rc80211_minstrel_debugfs.c    | 14 ++++--------
>>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 14 ++++--------
>>  4 files changed, 9 insertions(+), 51 deletions(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
>> index dead57ba9eac..a34e9c2ca626 100644
>> --- a/net/mac80211/rc80211_minstrel.c
>> +++ b/net/mac80211/rc80211_minstrel.c
>> @@ -167,12 +167,6 @@ minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
>>                 if (unlikely(!mrs->att_hist)) {
>>                         mrs->prob_ewma = cur_prob;
>>                 } else {
>> -                       /* update exponential weighted moving variance */
>> -                       mrs->prob_ewmv = minstrel_ewmv(mrs->prob_ewmv,
>> -                                                       cur_prob,
>> -                                                       mrs->prob_ewma,
>> -                                                       EWMA_LEVEL);
>> -
>>                         /*update exponential weighted moving avarage */
>>                         mrs->prob_ewma = minstrel_ewma(mrs->prob_ewma,
>>                                                        cur_prob,
>> diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
>> index 54b2b2c3e10a..23ec953e3a24 100644
>> --- a/net/mac80211/rc80211_minstrel.h
>> +++ b/net/mac80211/rc80211_minstrel.h
>> @@ -35,19 +35,6 @@ minstrel_ewma(int old, int new, int weight)
>>         return old + incr;
>>  }
>>
>> -/*
>> - * Perform EWMV (Exponentially Weighted Moving Variance) calculation
>> - */
> 
> I worry about this one. where are you getting your proof from?
I've done quite a few measurements myself to see if this can be usable
for further rate control improvements or for the upcoming TPC work.
The data this generates simply fluctuates wildly and incoherently based
on the sampling behavior, making it completely useless.
Together with Thomas (who introduced this code), I tried a few times to
fix this, but couldn't find any way to make it coherent and usable.

Thomas and I both agreed that it's better to just remove it until
somebody has a better idea what to do.

Also, this was only used for debugfs statistics, not for any actual rate
control behavior.

- Felix

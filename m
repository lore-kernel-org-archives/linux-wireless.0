Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63422C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 13:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCEA62089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 13:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UrixBA5w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCEA62089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbeJCUkF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 16:40:05 -0400
Received: from nbd.name ([46.4.11.11]:46036 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbeJCUkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 16:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bnCCmXvfMiXgqDWdIL6ceSnBo6MhiXe6rUEEuQjANQw=; b=UrixBA5wMb7hB3KnWOSfv1hbZk
        jYnJ95eUmYXEEyg3CsJJ5IVZkUgYoGa+P+0NR25tU/Q6IBtOuxKPmUU35jKd77i8h63+cvsbiOC1J
        A6DkW/h/GkLghRyW1rQzY2UnceWFE0tMn/kTXn6UfCNwEOmlEXDNwv6C9kuwZ4wqxNgU=;
Subject: Re: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20181001221908.16005-7-lorenzo.bianconi@redhat.com>
 <20181003104334.GB2250@redhat.com>
 <CAJ0CqmWTZJ+Q_O++8DijdExwbsJEqEqxinHCe8OYocBTRTDZLw@mail.gmail.com>
 <20181003111217.GC2250@redhat.com>
 <5D5747FB-2C2E-481F-B361-2FA054E4D6E8@nbd.name>
 <20181003133205.GA16914@redhat.com>
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
Message-ID: <4ecf9e32-cc25-714c-721b-c1b74164d781@nbd.name>
Date:   Wed, 3 Oct 2018 15:51:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181003133205.GA16914@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-03 15:32, Stanislaw Gruszka wrote:
> On Wed, Oct 03, 2018 at 01:49:23PM +0200, Felix Fietkau wrote:
>> 
>> 
>> > On 3. Oct 2018, at 13:12, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > 
>> > On Wed, Oct 03, 2018 at 01:01:40PM +0200, Lorenzo Bianconi wrote:
>> >>> 
>> >>> On Tue, Oct 02, 2018 at 12:19:04AM +0200, Lorenzo Bianconi wrote:
>> >>>> Move mt76x2_dev in mt76x02_util.h and rename it in mt76x02_dev
>> >>>> in order to be shared between mt76x2 and mt76x0 driver
>> >>> <snip>
>> >>>> +struct mt76x02_dev {
>> >>>> +     struct mt76_dev mt76; /* must be first */
>> >>>> +
>> >>>> +     struct mac_address macaddr_list[8];
>> >>>> +
>> >>>> +     struct mutex mutex;
>> >>>> +
>> >>>> +     u8 txdone_seq;
>> >>>> +     DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
>> >>>> +
>> >>>> +     struct sk_buff *rx_head;
>> >>>> +
>> >>>> +     struct tasklet_struct tx_tasklet;
>> >>>> +     struct tasklet_struct pre_tbtt_tasklet;
>> >>>> +     struct delayed_work cal_work;
>> >>>> +     struct delayed_work mac_work;
>> >>>> +
>> >>>> +     u32 aggr_stats[32];
>> >>>> +
>> >>>> +     struct sk_buff *beacons[8];
>> >>>> +     u8 beacon_mask;
>> >>>> +     u8 beacon_data_mask;
>> >>>> +
>> >>>> +     u8 tbtt_count;
>> >>>> +     u16 beacon_int;
>> >>>> +
>> >>>> +     struct mt76x02_calibration cal;
>> >>>> +
>> >>>> +     s8 target_power;
>> >>>> +     s8 target_power_delta[2];
>> >>>> +     bool enable_tpc;
>> >>>> +
>> >>>> +     u8 coverage_class;
>> >>>> +     u8 slottime;
>> >>>> +
>> >>>> +     struct mt76x02_dfs_pattern_detector dfs_pd;
>> >>>> +};
>> >>>> +
>> >>> <snip>
>> >>>> static bool
>> >>>> -mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
>> >>>> +mt76x2_has_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)
>> >>> 
>> >>> I don't think this is right approach. I would rather prefer to have
>> >>> common data structures embeded in mt76x2_dev and mt76x0_dev
>> >>> structures to have chip sepcific fields/data separated.
>> >>> 
>> >> 
>> >> The reason of this patch is that mt76x0_dev fields are already in mt76x2_dev
>> >> so I guess there is no need to have different structures. Moreover in
>> >> this way we can
>> >> remove a lot of duplicated code between mt76x0 and mt76x2 drivers.
>> > 
>> > But you can still create additional structures i.e.
>> > 
>> > mt76x02_power {
>> >    s8 target_power;
>> >    s8 target_power_delta[2];
>> >    bool enable_tpc;
>> > }
>> > 
>> > mt76x02_conf {
>> >    u8 coverage_class;
>> >         u8 slottime;
>> > }
>> > 
>> > put them into mt76xN_dev and still remove dupicated code ?
>> Quite often, mt76_dev would be needed as well for register access, which means extra parameters for a lot of functions.
>> I think Lorenzo’s approach makes the code a lot more concise, and makes it easier to share more code between mt76x0 and mt76x2.
> 
> I think this could be solved very easly by container_of() macro if
> there will be one mt76x02_dev struct just after mt76_dev.
That's possible, yes. But given how much code can still be unified
between mt76x0 and mt76x2, I don't think there will be much need for a
x0 or x2 specific device struct. And in that case, the code will be more
readable if we avoid putting a lot of unnecessary &dev->mt76x02 or
container_of in the code.

- Felix

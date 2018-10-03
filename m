Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00CCC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A71572089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Rf0KliiR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A71572089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbeJCSh3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 14:37:29 -0400
Received: from nbd.name ([46.4.11.11]:41398 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbeJCSh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 14:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:
        In-Reply-To:From:Subject:Mime-Version:Content-Type:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=YEBCIK2aGAsmuFKUdjK3SSM+HfOW8CQFT+qshY5yhJc=; b=Rf0KliiRQ8FTr1bi+W+zApIyJL
        Za7T/pi6yiXmymdsvjhi5pNvQtjadKQP461v9zzEU7YdgUTRyjqjw/MtVBhrNumBKRmE+gbDxw5II
        ucEJCgdu3ooaBJK2O6umusi9wQ0IvJQ3drWb0eRnTvNuKygahPbvUQmjbzULMwPKM/Rs=;
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
From:   Felix Fietkau <nbd@nbd.name>
X-Mailer: iPhone Mail (15C114)
In-Reply-To: <20181003111217.GC2250@redhat.com>
Date:   Wed, 3 Oct 2018 13:49:23 +0200
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D5747FB-2C2E-481F-B361-2FA054E4D6E8@nbd.name>
References: <20181001221908.16005-7-lorenzo.bianconi@redhat.com> <20181003104334.GB2250@redhat.com> <CAJ0CqmWTZJ+Q_O++8DijdExwbsJEqEqxinHCe8OYocBTRTDZLw@mail.gmail.com> <20181003111217.GC2250@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> On 3. Oct 2018, at 13:12, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>=20
> On Wed, Oct 03, 2018 at 01:01:40PM +0200, Lorenzo Bianconi wrote:
>>>=20
>>> On Tue, Oct 02, 2018 at 12:19:04AM +0200, Lorenzo Bianconi wrote:
>>>> Move mt76x2_dev in mt76x02_util.h and rename it in mt76x02_dev
>>>> in order to be shared between mt76x2 and mt76x0 driver
>>> <snip>
>>>> +struct mt76x02_dev {
>>>> +     struct mt76_dev mt76; /* must be first */
>>>> +
>>>> +     struct mac_address macaddr_list[8];
>>>> +
>>>> +     struct mutex mutex;
>>>> +
>>>> +     u8 txdone_seq;
>>>> +     DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
>>>> +
>>>> +     struct sk_buff *rx_head;
>>>> +
>>>> +     struct tasklet_struct tx_tasklet;
>>>> +     struct tasklet_struct pre_tbtt_tasklet;
>>>> +     struct delayed_work cal_work;
>>>> +     struct delayed_work mac_work;
>>>> +
>>>> +     u32 aggr_stats[32];
>>>> +
>>>> +     struct sk_buff *beacons[8];
>>>> +     u8 beacon_mask;
>>>> +     u8 beacon_data_mask;
>>>> +
>>>> +     u8 tbtt_count;
>>>> +     u16 beacon_int;
>>>> +
>>>> +     struct mt76x02_calibration cal;
>>>> +
>>>> +     s8 target_power;
>>>> +     s8 target_power_delta[2];
>>>> +     bool enable_tpc;
>>>> +
>>>> +     u8 coverage_class;
>>>> +     u8 slottime;
>>>> +
>>>> +     struct mt76x02_dfs_pattern_detector dfs_pd;
>>>> +};
>>>> +
>>> <snip>
>>>> static bool
>>>> -mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
>>>> +mt76x2_has_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)
>>>=20
>>> I don't think this is right approach. I would rather prefer to have
>>> common data structures embeded in mt76x2_dev and mt76x0_dev
>>> structures to have chip sepcific fields/data separated.
>>>=20
>>=20
>> The reason of this patch is that mt76x0_dev fields are already in mt76x2_=
dev
>> so I guess there is no need to have different structures. Moreover in
>> this way we can
>> remove a lot of duplicated code between mt76x0 and mt76x2 drivers.
>=20
> But you can still create additional structures i.e.
>=20
> mt76x02_power {
>    s8 target_power;
>    s8 target_power_delta[2];
>    bool enable_tpc;
> }
>=20
> mt76x02_conf {
>    u8 coverage_class;
>         u8 slottime;
> }
>=20
> put them into mt76xN_dev and still remove dupicated code ?
Quite often, mt76_dev would be needed as well for register access, which mea=
ns extra parameters for a lot of functions.
I think Lorenzo=E2=80=99s approach makes the code a lot more concise, and ma=
kes it easier to share more code between mt76x0 and mt76x2.

- Felix=


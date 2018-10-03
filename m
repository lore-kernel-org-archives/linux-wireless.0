Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337EAC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBA4521476
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBA4521476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbeJCRtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:49:45 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51393 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbeJCRtp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:49:45 -0400
Received: by mail-it1-f193.google.com with SMTP id 74-v6so7715980itw.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 04:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSVmx4N7f/ebsfvQ0m0AhxB3TC0JbqEUtzmpPhaWkCI=;
        b=cT4kBdZA/ntg1Himbay/JIx1lBR7oNMii+XTZ/3YKstLNPy/R5iFtEErVq2WgXX9Fo
         9X+Y9Skcrps5EEIE4GlFeL8DsegjB6f2Da3VdYfivQh+9l8OT8lsbL0+BFcST0d3V+XV
         1mmOi+Q9DTqv+LmgYo/EmvLwV2ZvcgSe6mMH+ErKbfs8J6e2F9JhCARi8Qvvj05CBW6N
         tn5KW8oAoZrAgmZONCvGdXQ+xPE5kOZPtBFtus+Tlj6QROAPBSLiZ1hgqsoUlgUxINBN
         Sl9ifSzJafp6Hl/kwNk8NTev9Vmjw1qXn0B9Kdn9DR62tdR9LR0SkY2FemNv0eE4ksJC
         J2Zg==
X-Gm-Message-State: ABuFfoh2Mt+i4+c0hHRgYnmH/sljWnv5KBc0R6Wjb2x1eIkKnqajJt9Q
        KJMS4alGgJQopsOyRgWKJmUoaYKbFapkMjqnBYw1S2XSWTA=
X-Google-Smtp-Source: ACcGV61ArV8GkR3oHWTakQSGsGWfJLkSnRxyzfA55qj2JogoCE0jhOXs4DBMloAqy44Zo5a9WGomyHhBBXGFFmUfE10=
X-Received: by 2002:a02:4142:: with SMTP id x63-v6mr619532jaa.55.1538564511914;
 Wed, 03 Oct 2018 04:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20181001221908.16005-7-lorenzo.bianconi@redhat.com> <20181003104334.GB2250@redhat.com>
In-Reply-To: <20181003104334.GB2250@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Wed, 3 Oct 2018 13:01:40 +0200
Message-ID: <CAJ0CqmWTZJ+Q_O++8DijdExwbsJEqEqxinHCe8OYocBTRTDZLw@mail.gmail.com>
Subject: Re: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Tue, Oct 02, 2018 at 12:19:04AM +0200, Lorenzo Bianconi wrote:
> > Move mt76x2_dev in mt76x02_util.h and rename it in mt76x02_dev
> > in order to be shared between mt76x2 and mt76x0 driver
> <snip>
> > +struct mt76x02_dev {
> > +     struct mt76_dev mt76; /* must be first */
> > +
> > +     struct mac_address macaddr_list[8];
> > +
> > +     struct mutex mutex;
> > +
> > +     u8 txdone_seq;
> > +     DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
> > +
> > +     struct sk_buff *rx_head;
> > +
> > +     struct tasklet_struct tx_tasklet;
> > +     struct tasklet_struct pre_tbtt_tasklet;
> > +     struct delayed_work cal_work;
> > +     struct delayed_work mac_work;
> > +
> > +     u32 aggr_stats[32];
> > +
> > +     struct sk_buff *beacons[8];
> > +     u8 beacon_mask;
> > +     u8 beacon_data_mask;
> > +
> > +     u8 tbtt_count;
> > +     u16 beacon_int;
> > +
> > +     struct mt76x02_calibration cal;
> > +
> > +     s8 target_power;
> > +     s8 target_power_delta[2];
> > +     bool enable_tpc;
> > +
> > +     u8 coverage_class;
> > +     u8 slottime;
> > +
> > +     struct mt76x02_dfs_pattern_detector dfs_pd;
> > +};
> > +
> <snip>
> >  static bool
> > -mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
> > +mt76x2_has_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)
>
> I don't think this is right approach. I would rather prefer to have
> common data structures embeded in mt76x2_dev and mt76x0_dev
> structures to have chip sepcific fields/data separated.
>

The reason of this patch is that mt76x0_dev fields are already in mt76x2_dev
so I guess there is no need to have different structures. Moreover in
this way we can
remove a lot of duplicated code between mt76x0 and mt76x2 drivers.

Regards,
Lorenzo

> Regards
> Stanislaw
>

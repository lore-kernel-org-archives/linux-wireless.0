Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AA3C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3AC2098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B3AC2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbeJCRb1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbeJCRb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:31:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 073434E91C;
        Wed,  3 Oct 2018 10:43:39 +0000 (UTC)
Received: from localhost (unknown [10.40.205.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F36517F35;
        Wed,  3 Oct 2018 10:43:36 +0000 (UTC)
Date:   Wed, 3 Oct 2018 12:43:35 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
Message-ID: <20181003104334.GB2250@redhat.com>
References: <20181001221908.16005-7-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001221908.16005-7-lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 03 Oct 2018 10:43:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 02, 2018 at 12:19:04AM +0200, Lorenzo Bianconi wrote:
> Move mt76x2_dev in mt76x02_util.h and rename it in mt76x02_dev
> in order to be shared between mt76x2 and mt76x0 driver
<snip>
> +struct mt76x02_dev {
> +	struct mt76_dev mt76; /* must be first */
> +
> +	struct mac_address macaddr_list[8];
> +
> +	struct mutex mutex;
> +
> +	u8 txdone_seq;
> +	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
> +
> +	struct sk_buff *rx_head;
> +
> +	struct tasklet_struct tx_tasklet;
> +	struct tasklet_struct pre_tbtt_tasklet;
> +	struct delayed_work cal_work;
> +	struct delayed_work mac_work;
> +
> +	u32 aggr_stats[32];
> +
> +	struct sk_buff *beacons[8];
> +	u8 beacon_mask;
> +	u8 beacon_data_mask;
> +
> +	u8 tbtt_count;
> +	u16 beacon_int;
> +
> +	struct mt76x02_calibration cal;
> +
> +	s8 target_power;
> +	s8 target_power_delta[2];
> +	bool enable_tpc;
> +
> +	u8 coverage_class;
> +	u8 slottime;
> +
> +	struct mt76x02_dfs_pattern_detector dfs_pd;
> +};
> +
<snip> 
>  static bool
> -mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
> +mt76x2_has_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)

I don't think this is right approach. I would rather prefer to have
common data structures embeded in mt76x2_dev and mt76x0_dev
structures to have chip sepcific fields/data separated.

Regards
Stanislaw


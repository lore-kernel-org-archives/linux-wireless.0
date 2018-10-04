Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D18C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 14:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7BB82082A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 14:10:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7BB82082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbeJDVDz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 17:03:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbeJDVDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 17:03:54 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95F6488E6E;
        Thu,  4 Oct 2018 14:10:25 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAA7677C0A;
        Thu,  4 Oct 2018 14:10:24 +0000 (UTC)
Date:   Thu, 4 Oct 2018 16:10:15 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 07/12] rtw88: phy files
Message-ID: <20181004141015.GC20484@redhat.com>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
 <1538565659-29530-8-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538565659-29530-8-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 04 Oct 2018 14:10:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 07:20:54PM +0800, yhchuang@realtek.com wrote:
> +void rtw_phy_cfg_bb(struct rtw_dev *rtwdev, const struct rtw_table *tbl,
> +		    u32 addr, u32 data)
> +{
> +	if (addr == 0xfe)
> +		msleep(50);
> +	else if (addr == 0xfd)
> +		mdelay(5);
> +	else if (addr == 0xfc)
> +		mdelay(1);
> +	else if (addr == 0xfb)
> +		usleep_range(50, 60);
> +	else if (addr == 0xfa)
> +		udelay(5);
> +	else if (addr == 0xf9)
> +		udelay(1);
> +	else
> +		rtw_write32(rtwdev, addr, data);

This mix of mdelay(), msleep(), udelay() and usleep_range() looks strange.
You should eigher use atomic versions *delay or non-atomic *sleep
versions .

> +#define bcd_to_dec_pwr_by_rate(val, i) \
> +	({ \
> +		typeof(val) __val_ = val; \
> +		typeof(i) __i_ = i; \
> +		((s8)((((__val_ >> (__i_ * 8 + 4)) & 0xF)) * 10 + \
> +		       ((__val_ >> (__i_ * 8)) & 0xF))); \
> +	 })

Can use bcd2bin from include/linux/bcd.h instead ?


Thanks
Stanislaw 

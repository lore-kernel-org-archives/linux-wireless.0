Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E34C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 14:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8CF320652
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 14:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8CF320652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbeJDVQl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 17:16:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbeJDVQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 17:16:41 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88CC031B307;
        Thu,  4 Oct 2018 14:23:09 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC9FB69EF0;
        Thu,  4 Oct 2018 14:23:08 +0000 (UTC)
Date:   Thu, 4 Oct 2018 16:23:06 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 08/12] rtw88: debug files
Message-ID: <20181004142306.GD20484@redhat.com>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
 <1538565659-29530-9-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538565659-29530-9-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 04 Oct 2018 14:23:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 07:20:55PM +0800, yhchuang@realtek.com wrote:
> +static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
> +{
> +	struct rtw_debugfs_priv *debugfs_priv = m->private;
> +	struct rtw_dev *rtwdev = debugfs_priv->rtwdev;
> +	u8 page_size = rtwdev->chip->page_size;
> +	u32 buf_size = debugfs_priv->rsvd_page.page_num * page_size;
> +	u32 offset = debugfs_priv->rsvd_page.page_offset * page_size;
> +	u8 *buf = vzalloc(buf_size);
Error check.

> +void rtw_debugfs_init(struct rtw_dev *rtwdev)
> +{
> +	debugfs_topdir = debugfs_create_dir("rtw88", NULL);

You should use rtwdev->hw->wiphy->debugfsdir like other drivers.

Thanks
Stanislaw

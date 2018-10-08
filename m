Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E7BC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF44420841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF44420841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbeJHUlT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:41:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55772 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeJHUlT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:41:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9VbD-000712-RT; Mon, 08 Oct 2018 15:29:27 +0200
Message-ID: <1539005356.3687.13.camel@sipsolutions.net>
Subject: Re: [RFC v3 08/12] rtw88: debug files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 15:29:16 +0200
In-Reply-To: <1538565659-29530-9-git-send-email-yhchuang@realtek.com> (sfid-20181003_132144_335644_0E0FC8A8)
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-9-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132144_335644_0E0FC8A8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-03 at 19:20 +0800, yhchuang@realtek.com wrote:
> 
> +static struct dentry *debugfs_topdir;
> +
> +void rtw_debugfs_init(struct rtw_dev *rtwdev)
> +{
> +	debugfs_topdir = debugfs_create_dir("rtw88", NULL);

You really can't do this, all hell will break lose if you ever plug two
devices into the same system.

johannes

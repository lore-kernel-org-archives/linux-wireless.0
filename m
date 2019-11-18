Return-Path: <SRS0=8L7/=ZK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B255DC432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Nov 2019 03:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C7E206A5
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Nov 2019 03:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b72SHJeS";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="G5YspjSt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfKRDZN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:25:13 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:54528
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfKRDZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Nov 2019 22:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574047512;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:Message-ID;
        bh=sP0RVI9gRbWx48Xnruy9t2o5xosiItcne3JL1huN1Qs=;
        b=b72SHJeScfd3lw+UMs888sW2XkvXwte85asnEgMIgT27A0fbf5xyemsRWaQagMOl
        ORI3yXOBpa9i8K0W5CCVYNWqiqKIXoG/yUbfcDP26qx/EPDgi94X+odkLqsJw81rmFH
        WWEB4GDTONDSEzEpX5tgWPnt+OgXKjNMXwu+mWxw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574047512;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:Message-ID:Feedback-ID;
        bh=sP0RVI9gRbWx48Xnruy9t2o5xosiItcne3JL1huN1Qs=;
        b=G5YspjStKtwHmdL4Zy3ucWMOMIM8sjSeSbG6Kf4Gm632qrIlOjJNfo8h0kbqzwrJ
        uPwz2ScVJpO1UKp863HFzHu8WJfRFO4CzWBe0+FUfgWVOkTqnRyIcTI4jbOSvcghzjZ
        9UQ/QV3IpSXH6SRIO3bEwZDQKSOv6pfMVg85SyKU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 18 Nov 2019 03:25:12 +0000
From:   wgong@codeaurora.org
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove the max_sched_scan_reqs value
Message-ID: <0101016e7c8af6fd-1ff32cfb-9e8f-4b50-a902-224121b3f376-000000@us-west-2.amazonses.com>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.18-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

patch v2 sent:
https://patchwork.kernel.org/patch/11243015/

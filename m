Return-Path: <SRS0=XMVh=CN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3591C433E2
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Sep 2020 15:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B0D02073B
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Sep 2020 15:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e8ne5V43";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WuLYCmft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbgIDPAO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:00:14 -0400
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:37178
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730202AbgIDPAN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Sep 2020 11:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599231612;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=L87UrJdMaQklOT+01la19QflwWAv9g5Xq3C0wZILUB0=;
        b=e8ne5V43tLgQeu5V+GVUt+MPF4HK8jUSaou84kwxf7zyCU6mQrGIFxcCaEm0VIJy
        01hFpiEJouxyDmWP+FyhMYCcpcIwV89ehjimpzuC+ejw20t52p0SpdM73EFMGP5BAcW
        j/WDrPsQ1AXiF+u4fk8lmB3mTyxrXls0fJB6VLDs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599231612;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=L87UrJdMaQklOT+01la19QflwWAv9g5Xq3C0wZILUB0=;
        b=WuLYCmftUzhvDRLOgrAzVV5u3+c1yzfJnj1/9V72fX4TMwUvOsO8RQZrNgRdAr0/
        7R6GnXEcW/4fK52lpKzNNbNrCVC23gqH5MYwpe9rq3cG6v9+Eup4lTNXaf/+wG5YS0e
        bdRAwk1CvEBQyIYiYMbW26DD5+7xYwDZaMiG1gLg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 4 Sep 2020 15:00:12 +0000
From:   akolli@codeaurora.org
To:     greearb@candelatech.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath11k:  Allow debugfs to work with 2+ radios installed.
In-Reply-To: <20200903172359.29199-1-greearb@candelatech.com>
References: <20200903172359.29199-1-greearb@candelatech.com>
Message-ID: <0101017459a1d409-4d95a8e1-d404-4fba-a25d-b2e3075947e0-000000@us-west-2.amazonses.com>
X-Sender: akolli@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2020.09.04-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-09-03 22:53, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The code is trying to create an ath11k directory on debugfs
> root, but that fails when there is a second radio (and thus
> second instance of the driver).
> 

Hi Ben,

IPQ8074 is soc and it does not need second debugfs entry, its on AHB.
QCA6390 is a pci card and multiple debug entries are needed if multiple 
cards are available,
I am planning to post a patch with bus specific abstraction function 
which creates single debugfs for soc based radios and multiple entries 
for PCI based radios.

AHB:
debugfs/ath11k/IPQ8074/

PCI
debugfs/ath11k/QCA6390_0001:01:00.0/
debugfs/ath11k/QCA6390_0000:01:00.0/

Thanks
Anil

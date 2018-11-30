Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03DDC04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 09:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDC72081C
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 09:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BDC72081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbeK3UqV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 15:46:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbeK3UqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 15:46:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD757356CD;
        Fri, 30 Nov 2018 09:37:38 +0000 (UTC)
Received: from localhost (unknown [10.40.205.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02B2C5D9CD;
        Fri, 30 Nov 2018 09:37:37 +0000 (UTC)
Date:   Fri, 30 Nov 2018 10:37:36 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH v2 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20181130093735.GA19635@redhat.com>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 30 Nov 2018 09:37:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 16, 2018 at 07:31:06PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 supports 8822BE and 8822CE chips, and will be able to support
> multi-vif combinations in run-time.
> 
> For now, only PCI bus is supported, but rtw88 was originally designed
> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> will soon be supported by rtw88, with configurable core module to fit
> with different bus modules in the same time.
> 
> For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
> be selected, built, loaded into kernel. This is one of the major
> difference from rtlwifi, which can only support specific combinations.
> 
> Another difference from rtlwifi is that rtw88 is designed to support
> the latest Realtek 802.11ac wireless network chips like 8822B and
> 8822C series. Compared to the earlier chips supported by rtlwifi like
> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> have different MAC & PHY settings, such as new multi-port feature for the
> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
> 
> Multi-Port feature is also supported under rtw88's software architecture.
> rtlwifi can only support one vif in the same time, most because of the
> hardware limitations for early chips, hence the original design of it
> also restricts the usage of multi-vif support, so latest chipset seems not
> take advantages from its new MAC engine.
> 
> However, rtw88 can run multiple vifs concurrently by holding them on
> hardware ports provided by MAC engine, hence can easily start different
> roles on a single device.
> 
> Based on the reasons mentioned before, we implemented rtw88. It had many
> authors, they are listed here alphabetically:
> 
> Ping-Ke Shih <pkshih@realtek.com>
> Tzu-En Huang <tehuang@realtek.com>
> Yan-Hsuan Chuang <yhchuang@realtek.com>

For the series:
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

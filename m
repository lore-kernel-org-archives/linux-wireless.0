Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE56C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB832077C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EB832077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbeJHVMa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:12:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56214 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbeJHVMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:12:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9W5G-0007XS-JZ; Mon, 08 Oct 2018 16:00:30 +0200
Message-ID: <1539007219.3687.38.camel@sipsolutions.net>
Subject: Re: [RFC v3 12/12] rtw88: Kconfig & Makefile
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 16:00:19 +0200
In-Reply-To: <1538565659-29530-13-git-send-email-yhchuang@realtek.com> (sfid-20181003_132143_363210_BDF3D2A2)
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-13-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132143_363210_BDF3D2A2)
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
> +config RTW88_CORE
> +	tristate
> +	depends on RTW88
> +
> +config RTW88_PCI
> +	tristate
> +	depends on RTW88_CORE && PCI

Those "depends on" lines are misleading, I don't think select honours
that?

> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -0,0 +1,19 @@
> +obj-$(CONFIG_RTW88_CORE)	+= rtw88.o
> +rtw88-y += main.o \
> +	   mac80211.o \
> +	   debug.o \
> +	   tx.o \
> +	   rx.o \
> +	   mac.o \
> +	   phy.o \
> +	   efuse.o \
> +	   fw.o \
> +	   ps.o \
> +	   sec.o \
> +	   regd.o
> +
> +rtw88-$(CONFIG_RTW88_8822BE)	+= rtw8822b.o rtw8822b_table.o
> +rtw88-$(CONFIG_RTW88_8822CE)	+= rtw8822c.o rtw8822c_table.o
> +
> +obj-$(CONFIG_RTW88_PCI)		+= rtwpci.o
> +rtwpci-objs			:= pci.o

This is a weird split? Why even bother with two modules if everything
goes into the main "rtw88" module except for a single file?

johannes

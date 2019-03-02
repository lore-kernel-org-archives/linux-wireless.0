Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99B0C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 07:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A10FA2083D
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 07:05:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="P8XdJQbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfCBHFU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 02:05:20 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:36013 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfCBHFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 02:05:19 -0500
Received: by mail-ed1-f45.google.com with SMTP id g9so179893eds.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2019 23:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=8+pX3UapbALM/AMmltCrRnunELlgW/yfXpcJezo8cX4=;
        b=P8XdJQbPsNcjEjXSmZo9t1P8P4MU3v0x5Q8UmOx+gmeeOLIh+O1PdRhKkq1lphxGnt
         3+tK7prsp4Kr92i90pLD8Vk+JJENxqYC0vhJBBO4pjKh9hss3bAJnq7ieiVMJwt65E+E
         F9p14KEEOSIpSc77vuKGx0Fb6UxlPk8/r8Ba4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=8+pX3UapbALM/AMmltCrRnunELlgW/yfXpcJezo8cX4=;
        b=FHiVDQ5bIuI73XJ/BO8OgT2/c3RrjdpFwKNEnsYuJW/lSdYqJfiap0AJADYreyyklY
         8CkZefQForRxzpI+Wza7liPFbEoE1rjkUZQ1TB//NwbWMzICKRuPxYIK57pKe2zUMgE3
         bldYcgsuZVc7M2nE+TQMT/9nPSe57rKicSFl9WJz6/OtUyD3qw9RRAe6459IWfk9J9KL
         VRfe27NspCmu8kX32LSuqWoUN2cek0Eh5B3XZSijs8yogT+8/wFEbestrwDNJJ/M/duB
         gcO7i0KQ8ru01yJjQN6JLHG3OvR1quDjZKgUeuM8c7oCCfYqIisV16UgGg7W/WO1xvtD
         rF1g==
X-Gm-Message-State: APjAAAWHP7m2kCNClYmNU0rQaUtVZ4l1ixM5VeE7CaAA8VInaiEY/LQl
        kneAATEoWk5Nx5YzHhfTsjxZ1Q==
X-Google-Smtp-Source: APXvYqx9Kz5udEUWucBTcPaLp3S+wgu/yjzmNOuC6S2WHO1W5w1smTb0Lq6p995w5WTXoNh831TsAQ==
X-Received: by 2002:a50:92cb:: with SMTP id l11mr7067969eda.25.1551510317784;
        Fri, 01 Mar 2019 23:05:17 -0800 (PST)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id r1sm108298eds.39.2019.03.01.23.05.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Mar 2019 23:05:17 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
CC:     "linux-wireless" <linux-wireless@vger.kernel.org>
Date:   Sat, 02 Mar 2019 08:05:15 +0100
Message-ID: <1693d389ff8.278a.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <1125416917.128310.1551471017839@email.ionos.de>
References: <1125416917.128310.1551471017839@email.ionos.de>
User-Agent: AquaMail/1.18.2-1413 (build: 101800200)
Subject: Re: brcmfmac: bogus error messages during module unload
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Op 1 maart 2019 21:10:18 schreef Stefan Wahren <stefan.wahren@i2se.com>:

> Hi,
>
> this is some kind of older issue with brcmfmac. Everytime i unload the 
> kernel module (e.g. v5.0-rc8 or next-20190301) on a Raspberry Pi 3 
> (multi_v7_defconfig / arm64_defconfig) after the driver has successful 
> probed, i'm getting such bogus error messages in the kernel log:
>
> [  870.477114] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg 
> failed w/status -5
> [  870.477122] brcmfmac: brcmf_cfg80211_get_tx_power: error (-5)
> [  871.057074] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing 
> to do.
> [  871.057153] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing 
> to do.
> [  871.057870] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing 
> to do.
> [  871.057878] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
>
> Is there a chance to remove or at least reduce them?

These are triggered by user-space. Upon remove we can not communicate with 
the device, but have not yet removed the network interfaces. So when 
user-space does a request we fail. I will have a look at it.

Regards,
Arend

Verzonden met AquaMail voor Android
https://www.mobisystems.com/aqua-mail



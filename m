Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCF4C6787C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 23:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E13D21470
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 23:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jmFSQsHG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E13D21470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbeJMGhd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 02:37:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44607 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbeJMGhd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 02:37:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id r9-v6so6875198pff.11
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 16:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+VMen/FA5rhnGW88kU5on0dGZ+gK/dze+3om2vk04f0=;
        b=jmFSQsHGodocRqTb6xNSUmaF1vsS0AMSl2EZ3PtSKilIdP3JIWlYaimVqOgdoB5poi
         baMq4pB/sRAFy0bY4Jg0DuKya0Vcgj2aNZRHK8Hret+7pd5XazSC++lB34G1OS78yorA
         gKvOKsGXAnMcYR4ERREnz+GvTpoqxOzoCE1QE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+VMen/FA5rhnGW88kU5on0dGZ+gK/dze+3om2vk04f0=;
        b=mfnWU1DVRtOVFRhQzwFjvNrkEDd75a/7lNybPLhVpnO3gRPyLCC+JFaLDHMBPSFHeY
         FkaxDicko6T/JBdEpxsIONfmAfdUf8l3zcFPsQjPQ/TGyisD5x7miMh5VttQZmOpajtn
         /2ZrrvP0i2W7wxea32wOIeug/+p2SKQSBqapK8t+kel3SqNrOIQVcGSZQ9HV61zreNmW
         VYGORpC+CF3FyLEycQourWJSCo0T7PEaH1HuLeiH6BDtpJ5p1jo3m9R7mG6/5da6XYwO
         e+vWEg22BJXxNOIMX+ymwtlCR9cwXyybAuCTE5YI+Ig+8yqur2NQD9bH6O61IKy/cXkw
         LfEQ==
X-Gm-Message-State: ABuFfoi6wHTiseO3TDH4exBN7TATADtbp6ddSGdTSgaQM+l3nr5aa4/n
        AbTEO0HcQ2vzlDjWdvUJvmgPHg==
X-Google-Smtp-Source: ACcGV63Vcep+1nzpLjyQyPZQA0yGoOh+YWFFD+gJ3Sz4svcRUhfyP20vTJhP+PUwUqQ2Te8yjk+1Jg==
X-Received: by 2002:a63:bf46:: with SMTP id i6-v6mr7252931pgo.378.1539385374180;
        Fri, 12 Oct 2018 16:02:54 -0700 (PDT)
Received: from rodete-desktop-imager.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id e6-v6sm35769pfk.3.2018.10.12.16.02.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 16:02:52 -0700 (PDT)
Date:   Fri, 12 Oct 2018 16:02:50 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Enable ath10k wcn3990 wifi driver support on
 sdm845
Message-ID: <20181012230249.GA189259@rodete-desktop-imager.corp.google.com>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 05:22:53PM +0530, Govind Singh wrote:
> This series enables ath10k wifi driver support for WCN3990 target
> on sdm845 SOC. This series also updates the missing dt binding documentation
> and adds optional iommu property.

For the series:

Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

Thanks!

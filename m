Return-Path: <SRS0=ugwx=DQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2BAC433DF
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 15:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15300222C2
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 15:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="EpM5c8im"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbgJIPbr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Oct 2020 11:31:47 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:44623 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389297AbgJIPbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Oct 2020 11:31:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602257506; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=AHbdC6xmc5IiqEGFw3agmVXAXsis+pk0Tyk3svmXQFk=; b=EpM5c8im/vhCyh3YgDFASFPeXuwurj9v7NLEMvga257edt+5IcVf+ocs5y4HpcCDOk+As03W
 sui9/BWZqPnuuNLLzssEA7z5snFfUd2AHq/S1MyvorXwmYXi5P3g9mcDqNrlokvHZgyWbmPH
 ZC9RGB/CdjznSVEhu12XPrcBomY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f80821caad2c3cd1c60180d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Oct 2020 15:30:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A86F5C433CB; Fri,  9 Oct 2020 15:30:35 +0000 (UTC)
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B616C433C9;
        Fri,  9 Oct 2020 15:30:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B616C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: fix OBSS PD min and max offset validation
References: <1601278091-20313-1-git-send-email-rmanohar@codeaurora.org>
Date:   Fri, 09 Oct 2020 18:30:31 +0300
In-Reply-To: <1601278091-20313-1-git-send-email-rmanohar@codeaurora.org>
        (Rajkumar Manoharan's message of "Mon, 28 Sep 2020 00:28:10 -0700")
Message-ID: <87imbjs9go.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> The SRG min and max offset won't present when SRG Information Present of
> SR control field of Spatial Reuse Parameter Set element set to 0. Per
> spec. IEEE802.11ax D7.0, SRG OBSS PD Min Offset =E2=89=A4 SRG OBSS PD Max
> Offset. Hence fix the constrain check to allow same values in both
> offset and also call appropriate nla_get function to read the values.
>
> Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD
> attributes")

Fixes tag should be in one line.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E69ECDE44
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED4F20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EhnAFoq2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CED4F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbeKERmu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 12:42:50 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33280 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKERmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 12:42:50 -0500
Received: by mail-yb1-f196.google.com with SMTP id i78-v6so3450812ybg.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 00:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=t2pebSjTHaSdpg/eTQ/45mr76vNPKaHLreVAgLOE6tI=;
        b=EhnAFoq26zKl+IKN4Sq97uweheWgFgaUnnJAngpUaHrpzxzv+lPsbKr+QgurUTAvzn
         EaYctB4u7SdWpRAH1Q804GrI5SBEyqR33sf1/yyxTBvs7gzNPwuM5PZAl0ZC4XFOfvQv
         NuvPjlpWPyPwec/dhDoWOnOvb0m0NjYP95CTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=t2pebSjTHaSdpg/eTQ/45mr76vNPKaHLreVAgLOE6tI=;
        b=AZSob7n1NSojCVTLMZm+eVWCY6gU+Xake94wtAu39Bn51ZNNmiPCAj2HCQ7/VJDvAd
         7yeXnfvp0y2TOqsbFGeSMzfJ82iodeUFfyuPnTDrQnkR6+M/5UHd2DvTXQCQnOtwyaol
         6cy+LoIWCTyfGU2Iqi1jlZ9Y6RD4vUtAVnUAWracQxgRPenK7VY3/QC0pOx5l2Z8ogNv
         llsBTKVNWAje73GeIhMaMgq1y0kqw64pNxrciOBR8UDbbbk5gEaPEQ+Z0WtDw2dmY4L8
         YwTKFbnInNpPEtg0WA+UqTExNIcH7+whI7rxP0z7uowjg71z/EgxiQ7pG6U7TCK2kAZP
         YDWw==
X-Gm-Message-State: AGRZ1gLJ7lrAnhehgD7uKVxRk1Er2xNQVESpJDMrghi5TFr7ap9benIP
        s67Sr0XjV2dkRg7lpfww28Bb+w==
X-Google-Smtp-Source: AJdET5cmmye8820FFWDhs2TxQObVflXi5gqbcb+u047rUAdd1Pn41/1HVuQ8qzz0wcMCIwkjdRDe7Q==
X-Received: by 2002:a25:7643:: with SMTP id r64-v6mr20633487ybc.403.1541406258885;
        Mon, 05 Nov 2018 00:24:18 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j8-v6sm10597553ywa.17.2018.11.05.00.24.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 00:24:18 -0800 (PST)
Subject: Re: [PATCH 0/5] Use common cordic algorithm for b43
To:     Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <aac01237-6736-e786-b11c-4586ebb25dd1@broadcom.com>
Date:   Mon, 5 Nov 2018 09:24:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/3/2018 10:59 AM, Priit Laes wrote:
> b43 wireless driver included internal implementation of cordic
> algorithm which has now been removed in favor of library
> implementation.
>
> During the process, brcmfmac was driver was also cleaned.

You actually touched the *brcmsmac* driver, not brcmfmac. Please fix the 
driver prefix where appropriate in this series, ie. patches 2 and 3.

> Please note that this series is only compile-tested, as I
> do not have access to the hardware.

I can/will verify brcmsmac. As Kalle mentioned it makes more sense to 
push the 'lib: cordic:' patch through the wireless tree as well as it 
only is used by wireless drivers right now.

Regards,
Arend

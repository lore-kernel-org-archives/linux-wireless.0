Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE5AC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A324F223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RkLbFb2u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A324F223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbeKLUTj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:19:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38916 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbeKLUTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:19:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id b13so8664269wrx.6
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 02:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=PG5Utcq7ACJzaCfB8IKSCZxdBbDMRlPfo+mDZF6VMXg=;
        b=RkLbFb2udecvavqsbMYnfAaD0TylhHOTSV2TE/kf+aB8cWwiCUgV3XGePAfvulT8pj
         /Y4k36pzHQcadRX/p28OVGTTV+mQKNC3is/tP8tN5+5rJbNRhARR4Ru4DOgIJzSvfLfV
         Xpn62Ysd+hDnNr4MLdZ+d331L8JggqjEyqBbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=PG5Utcq7ACJzaCfB8IKSCZxdBbDMRlPfo+mDZF6VMXg=;
        b=kNTPMQcqBrThfWUMMsQAAsIsmCsnH+Xpb/cDchA8E8wkpm+PiU4scCh/yksIyM+IvU
         uH+W/AwkJ5xUhm88naAY7R/shjDBvXm9pies6QtbTkJzb6Hj6Px5hbgoJwYLqDuVDz/r
         Hne2rnxT4dMeBQ2QhLHeyiMpIsOgIjF+2vo/n4speiWjCY2iVpNDI4seADr+w7ohXIkU
         faJIZRR2SVBDIgtyJUlDVT4+khls+hBZy7/xNnmTZzVdxP5NhmWKK7EkLZ5hHulN7kX8
         PZKwdhxz8e6qWt9eTFwLmdIO3YTOR3DKSh2ZoGvndU/JUamsiDGYWMN3TI/nS935RkNh
         ijsg==
X-Gm-Message-State: AGRZ1gKab5+OPuNQcJyWmdlH49UkAhy0GobRMNBkN6a+R6wHWABFs+Np
        DUl7GjT/uR0LvU8CVXJQIWkEHQ==
X-Google-Smtp-Source: AJdET5cikykrQSTMbe5qR2BMj23tAS4clE/gz4Aerj0C+4BDuBj6i2sULA4Y079zh7K69+4oX9ySOA==
X-Received: by 2002:adf:8141:: with SMTP id 59-v6mr399785wrm.128.1542018422468;
        Mon, 12 Nov 2018 02:27:02 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h16-v6sm14788622wrb.73.2018.11.12.02.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 02:27:01 -0800 (PST)
Subject: Re: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
 <e3dba747-2baa-e36a-dd66-1c788dc32288@broadcom.com>
 <d6e7a076-69fc-fda9-8d1b-d59d34609ec1@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <96efe062-b5f2-ccfb-a062-2c426f459a7a@broadcom.com>
Date:   Mon, 12 Nov 2018 11:27:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <d6e7a076-69fc-fda9-8d1b-d59d34609ec1@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/12/2018 11:24 AM, Chi-Hsien Lin wrote:
>
>
> On 11/12/2018 6:16, Arend van Spriel wrote:
>> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>>> GCI core is needed for ULP operation. Allow GCI core enumuration with
>>> below changes:
>>>  - Allow GCI to be added to core list even when it doesn't have a
>>> wrapper.
>>>  - Allow 8K address space size.
>>>  - Don't overwrite the address value when an additional size descriptor
>>>    is in place.
>>
>> One question. This only assures the GCI core is listed. So does the
>> driver need to access it for ULP operation?
>
> Yes, the GCI core registers are accessed when entering/exiting ULP sleep
> modes. There will be other patches for the ULP support.

Yeah. I suspected such. It would have been better to send this patch 
with that ULP series, but let's not make it an issue now. The patch is fine.

Regards,
Arend


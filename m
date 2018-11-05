Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72904C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123792082A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 123792082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbeKETEC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 14:04:02 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45982 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKETEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 14:04:02 -0500
Received: by mail-ed1-f66.google.com with SMTP id w39-v6so2502599edw.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 01:45:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e7Fmk1Yd7EEMNqFSNlMzxzLX7eNPX6U3T3B9A2+lJj8=;
        b=Iydb+aBxvdBWr8LBkw5UJ6SUhvxnpzdHOZe3NRqSRu8zbBI6KKSU75jfeJ5MgebbrN
         vmpdO0nozd6dgHEIO6JQeiZw2AFSqD+yhV1CKa+8whLvhiP/wFTBbKdw4+Yqh9m/u8Zi
         kGSoqPBoIV2SQF3UuwCBMTzs86+cDDIFIdclibe8YSYFFA5WZjSpiQ/4HNtTzP6AVEFh
         3GFYs7n++9wQF1G88Cv1keDjD0oiB6Twg4LJtldkYUmswHMsJrm3rNeMJkbTqHkzXMx1
         Lvhthl+mq4OhZh+zWFdgfBw7V6nueIUpybysB0OXAX8z7/unKapymF2EwXO+matbXbPz
         NovA==
X-Gm-Message-State: AGRZ1gIwFVI+Ylaf0shHtyZlsBV6wr8cL0QiFIsBB3GhGzBuOMSNt9jI
        IK7gZnS5ahJq9vnELwouc5+dYQ==
X-Google-Smtp-Source: AJdET5f5D0vf1S5SLFfPi2EghVSZi0HBmeC9ZZ3vSVLkvhvlvjdqoM5ldw2veqTzXcD9ChnoPw+S3g==
X-Received: by 2002:a50:8144:: with SMTP id 62-v6mr17153909edc.204.1541411109317;
        Mon, 05 Nov 2018 01:45:09 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id f5-v6sm8776032edi.85.2018.11.05.01.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 01:45:08 -0800 (PST)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
 <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
 <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
 <d714db41-f885-7724-6a2d-982a969bb4ab@redhat.com>
 <b2490334-b27b-aedb-dbb3-5cd746d93183@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <85b171d1-b967-9cd5-5560-7b3421a7152a@redhat.com>
Date:   Mon, 5 Nov 2018 10:45:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <b2490334-b27b-aedb-dbb3-5cd746d93183@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-10-18 10:15, Arend van Spriel wrote:
> On 10/10/2018 9:59 AM, Hans de Goede wrote:

>> Any chance you could do a patch-review of this series?
> 
> Yup and test for regressions with some of the chipsets I have here.

Have you gotten around to review and testing this series yet?
it would be nice to get this upstream.

Also a review of the 2 patch series starting with:
"brcmfmac: Add support for getting nvram contents from EFI variables"
would be appreciated.

Regards,

Hans

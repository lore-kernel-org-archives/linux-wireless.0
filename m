Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B31C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7532085B
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B7532085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbeKFAaQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:30:16 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36189 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbeKFAaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:30:16 -0500
Received: by mail-ed1-f65.google.com with SMTP id x2-v6so7793151eds.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 07:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8AsekfAjRiGsWKnqWeLTN5dwG6gsSTRM0e8KyYH9Mok=;
        b=DtVnNVO0SY95XmaGo9x4f9SWoYfqwOkCNI+mBGgR6dB6VYZlM6cik1zhYZFpl6UA9E
         bVOlgmLSbd1mJejTsyw3ocEIJC5G+SDcFB3RPgzUXoylSRDqPt4ay3/nx1/yGfoErwYO
         22nQhUaJsAeVlt7hUF86J6ADBpGUicRuJERs5yLjwTOQHK/K2LBDDP12hNFCxSV+hkrD
         2oO2n++t3KbHNymOPngC0z3wndZxecOjWvEn/z4VhFrRcqKzlDUj87glbbU6ektiU1l+
         QD2PyY/rO8+LMBoJ5Jxuy2WgBOZq2WoWnaAlN6t4prN3WVqtSHsAML5eITU1rvlNNhPr
         htKw==
X-Gm-Message-State: AGRZ1gLnuZ6myJN2fdZEb7lvTKlWPBdQI4jXXVu/rSyNYX5XNzs8Yms0
        cT/HF+IUSiREAQNLm/OFfzZ64g==
X-Google-Smtp-Source: AJdET5eMEYebeX1XBlkibgkGE9FYXAzMVJhmvn3Ygda0t3PgkXPwmkmJnoqjkDus4iQd08pW0BrDfg==
X-Received: by 2002:a50:cb85:: with SMTP id k5-v6mr18760973edi.171.1541430605502;
        Mon, 05 Nov 2018 07:10:05 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id x35-v6sm960663edb.24.2018.11.05.07.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 07:10:04 -0800 (PST)
Subject: Re: [PATCH 1/6] brcmfmac: Remove firmware-loading code duplication
To:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <c6dd19e3-58e2-2eb2-5724-e6718b3fb2cf@broadcom.com>
 <87a7mnbm45.fsf@purkki.adurom.net>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <0c34fc2f-8402-df5c-d34d-0915ba27ce40@redhat.com>
Date:   Mon, 5 Nov 2018 16:10:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <87a7mnbm45.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 05-11-18 16:05, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>>> brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
>>> code to complete the fw-request depending on the item-type.
>>>
>>> This commit adds a new brcmf_fw_complete_request helper removing this code
>>> duplication.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> For some reason you commented on v1 but there was v2 posted already:
> 
> https://patchwork.kernel.org/patch/10634355/
> 
> I guess I can take v2 still?

Yes the only thing different in v2 was dropping the SPDX license header
for the new drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
file and replacing it with the full ISC license text as seen in other
brcmfmac files. Nothing else was changed, so the review of v1 is
valid for v2 too.

Arend had one very minor comment on the name of a variable in the fifth
patch, but that is not important so if you want to pick up v2 as is
go for it.

Note the ISC license text is now in Torvald's tree as:
LICENSES/other/ISC

So could even go with v1, but I guess you prefer to move all files of
a driver over to the SPDX headers in one go ...

Regards,

Hans

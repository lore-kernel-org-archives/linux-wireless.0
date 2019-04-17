Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEBDC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 12:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB3F20835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 12:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJs6ZkGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbfDQMjh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 08:39:37 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34288 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732049AbfDQMjg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 08:39:36 -0400
Received: by mail-ot1-f68.google.com with SMTP id k21so20547688otf.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 05:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tUMsJTUTt1TFs8w+n9dZ+aYgXw0GFKvYwbp9Rgr5/vw=;
        b=JJs6ZkGAsYh3PpsSWBDWQmplOzWCy8Ar4owW4qWt6MfOws1ISieRU1NrJIvaFjOXtL
         nuEUV6nzmfURoVHbcCArGHPuP18tDDTAefuDwSYGuHG4hGhIxzcfysiu++f1/PTr/OBo
         m+YQg7NpwCKMWxpA5dNh1/TeUI3o3SZmVudEzopSuNCV1M8RD3FjWD4MOJHayBmY3rZl
         oqnZvsuLn4GrTYRVybHedrSHtnwUKtkCI/okK9vf8ooP80zhN3NY4/kQmI1TaDZZLRZA
         HjW8RhS+kQktVHX5cEvS5mLtHIADVXpSUjJdol/cM5QK5vfdEZDQyk5ggy7/xI7ZS5yh
         yzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUMsJTUTt1TFs8w+n9dZ+aYgXw0GFKvYwbp9Rgr5/vw=;
        b=PV8+VUpv8f9LC2/S1S3JM793riM5X7HbVsfZ7ZsIxd3CReNBJOAvYWxNB76eHFyptq
         RskmVosgnhbKWVbHfspCK43O/O65w5u1qXxAlXuobZOKA5sAwHQpWunpK9ChmfeazvxQ
         EldrGlADjzp7ddxn7bScI6b9BKU0dqnjpQ98PutYNLdi9zcKHWFG9umYBOVV1VWte5jz
         rSbdZ8pUDwAmVuw+N56i6Ry1lvqF9z2/04tcJrXjJ4BbAC+sUrzGI5BLaUBDcQG2Am8g
         OuwvaszXtbxAiL/2WusIQQgUYpgQ6Ux0qhsstIJCdmYAXZKlFNiXkB5h99rThBBHtowU
         oOlg==
X-Gm-Message-State: APjAAAUsVPZmEJxe7bOH2mXt3A3aHvueSYOJZNYOVhn1GNhtQMBmjNTB
        DX1K0HD53437bcNrmVLs1QaMSjtx
X-Google-Smtp-Source: APXvYqxc2FQqlxK8FMmDjfot02TDDbjzjsYGv+rGyr/vFrMHhUrbLtEdCuhvIKNrgh+aTtEU5q7cXw==
X-Received: by 2002:a9d:7306:: with SMTP id e6mr21822204otk.79.1555504776301;
        Wed, 17 Apr 2019 05:39:36 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id q23sm23288380oic.45.2019.04.17.05.39.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 05:39:34 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
To:     Pkshih <pkshih@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
 <1555464872.3420.2.camel@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d60ef334-15d4-71a3-6963-ba08872675af@lwfinger.net>
Date:   Wed, 17 Apr 2019 07:39:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1555464872.3420.2.camel@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/16/19 8:34 PM, Pkshih wrote:
> On Tue, 2019-04-16 at 19:35 -0500, Larry Finger wrote:
>> Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
>> incorporated into the sources. Obviously, it can be removed.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Reported-by: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>> Andrew,
>>
>> Thanks.
>>
>> Larry
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ----------
>>   1 file changed, 10 deletions(-)
>>   delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> deleted file mode 100644
>> index aa03d4605d8c..000000000000
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> +++ /dev/null
>> @@ -1,10 +0,0 @@
>> ---- drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> -+++ drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> -@@ -373,6 +373,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
>> - 	struct rx_fwinfo_88e *p_drvinfo;
>> - 	struct ieee80211_hdr *hdr;
>> - 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
>> -+	u8 wake_match;
>> -
>> - 	status->packet_report_type = (u8)GET_RX_STATUS_DESC_RPT_SEL(pdesc);
>> - 	if (status->packet_report_type == TX_REPORT2)
> 
> The change of trx.c seems not belong to this patch, right?

That is correct. The change in trx.c was correctly done except for incorporation 
of the extraneous file.

Larry

> 
> 


Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43FEC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A63FD20819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A63FD20819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbeKEXw4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:52:56 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43030 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbeKEXw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:52:56 -0500
Received: by mail-ed1-f68.google.com with SMTP id y20-v6so7647648eds.10
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 06:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bWHA2wcgVIHKjY032rmz051M6tqVbuivomJNiP5/t+8=;
        b=C6MBE6ve3LiZ4XmhFkkbmE45K5H3BznAZP8W36pUNXzvc4f3nuGk/yhyS7I+Z09bI8
         TBXIkk1s+Rfd39c2Qst9Xdpijy8kT2Z1L4LSERfFhtlQNAqDS7omZG0NXcNAZfDjXf75
         eGDL7/oXdAWEJApgfaMmfKEyV8xSp0bCHpml68S9OGhoqcFRgHSQ9SMtBsLbVbmSXjb1
         vgtKcyd+phb0nWrER7Hk1iQfGNnSe/cTCGrGLcO+WTdClu3BXlEQDzvQdLzCSXfndV2v
         x0d0Ke8ouhJANk3W7IDvKWuZcJM3zWDxgZx3BLKxAXDSHDML/RttLVDcX0jx4m6RLsU4
         IoBw==
X-Gm-Message-State: AGRZ1gL8e7KCJibaoLUC+n9WrFi7Wa4Zt2q+AHTFiJoGi88QqdCQPUW7
        wdKKxetdMulztE5DccJLOsi0dKy/yOc=
X-Google-Smtp-Source: AJdET5f1QU5j4szHhnzbWREmk1wR1MMMSkKB0EBq4hH18YJ3dO8VQwONsG75JWQt/Lz9iptckVKVWA==
X-Received: by 2002:a17:906:3d72:: with SMTP id r18-v6mr1595908ejf.186.1541428375553;
        Mon, 05 Nov 2018 06:32:55 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id t1-v6sm10369019eds.44.2018.11.05.06.32.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 06:32:54 -0800 (PST)
Subject: Re: [PATCH 3/6] brcmfmac: Add support for first trying to get a board
 specific nvram file
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-3-hdegoede@redhat.com>
 <c0415f15-d3cf-2693-be61-26151c5c030b@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <193d4020-1a7f-7a9e-1953-4da8a2509d89@redhat.com>
Date:   Mon, 5 Nov 2018 15:32:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <c0415f15-d3cf-2693-be61-26151c5c030b@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Thank you for the reviews.

On 05-11-18 12:41, Arend van Spriel wrote:
> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>> The nvram files which some brcmfmac chips need are board-specific. To be
>> able to distribute these as part of linux-firmware, so that devices with
>> such a wifi chip will work OOTB, multiple (one per board) versions must
>> co-exist under /lib/firmware.
>>
>> This commit adds support for callers of the brcmfmac/firmware.c code to
>> pass in a board_type parameter through the request structure.
>>
>> If that parameter is set then the code will first try to load
>> chipmodel.board_type.txt before falling back to the old chipmodel.txt name.
> 
> minor comment below...
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 27 ++++++++++++++++++-
>>  .../broadcom/brcm80211/brcmfmac/firmware.h    |  1 +
>>  2 files changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> index 08aaf99fee34..6755b2388fbc 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> @@ -532,6 +532,31 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
>>      return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>>  }
>>
>> +static int brcmf_fw_request_firmware(const struct firmware **fw,
>> +                     struct brcmf_fw *fwctx)
>> +{
>> +    struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>> +    int ret;
>> +
>> +    /* nvram files are board-specific, first try a board-specific path */
>> +    if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
>> +        char alt_path[BRCMF_FW_NAME_LEN];
>> +
>> +        strlcpy(alt_path, cur->path, BRCMF_FW_NAME_LEN);
>> +        /* strip .txt at the end */
>> +        alt_path[strlen(alt_path) - 4] = 0;
>> +        strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
> 
> why not string just "txt"?

I'm not entirely sure what your question exactly is here?

Regards,

Hans


> 
>> +        strlcat(alt_path, fwctx->req->board_type, BRCMF_FW_NAME_LEN);
>> +        strlcat(alt_path, ".txt", BRCMF_FW_NAME_LEN);
>> +
>> +        ret = request_firmware(fw, alt_path, fwctx->dev);
>> +        if (ret == 0)
>> +            return ret;
>> +    }
>> +
>> +    return request_firmware(fw, cur->path, fwctx->dev);
>> +}
>> +
>>  static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>>  {
>>      struct brcmf_fw *fwctx = ctx;
>> @@ -544,7 +569,7 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>>
>>      while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
>>          cur = &fwctx->req->items[fwctx->curpos];
>> -        request_firmware(&fw, cur->path, fwctx->dev);
>> +        brcmf_fw_request_firmware(&fw, fwctx);
>>          ret = brcmf_fw_complete_request(fw, ctx);
>>      }
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
>> index 2893e56910f0..a0834be8864e 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
>> @@ -70,6 +70,7 @@ struct brcmf_fw_request {
>>      u16 domain_nr;
>>      u16 bus_nr;
>>      u32 n_items;
>> +    const char *board_type;
>>      struct brcmf_fw_item items[0];
>>  };
>>
>>
> 

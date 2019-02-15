Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70522C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3819721B1C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hOiIdKsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405680AbfBOKkL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:40:11 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35330 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388223AbfBOKkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:40:11 -0500
Received: by mail-ed1-f65.google.com with SMTP id b17so7570667eds.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 02:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q3Yf+2GvME7aIFs20z8qo0ILOj9rUiALFch2xirM3cg=;
        b=hOiIdKsF7XzVD+2WX8+UexqptufikG5j7VFC7bwxFh4mu7dFWoFQZADLM02cR2xKGe
         qApXHS62HnfrH743F68GrCkTYJWFjScAdk6y+3PBJntBf/hqw4rQpNAO5O5aOCeCspnP
         sxRLiG1n07MKQy6tPcviG5TVD2fNzUJXwB7Ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3Yf+2GvME7aIFs20z8qo0ILOj9rUiALFch2xirM3cg=;
        b=LuFKWsV8otFlDnxZoRyg5TeIv5Aj5b5r7huqGUyIFXbROts5c2IJzhDUrmA0kcTiRk
         F23ZlUyMPTsdYMaJNMOZ3NwmHYygUrw+M1Q+MXbseQ6sZ9S1kUCvB3GLMkZxw2eINKcj
         B8v/u8TlLowPDfWCmNrBQSUYis1trb5dHntte4PUaqEz0k/QB/bgwC97OdJqLJTOFk9k
         FJHXvk+H8oSm7mdgb58bQHCoKvRWa62H1ZC3m2DDb6KEpOouyQinQPoZatLusVI5aB8V
         XqJKwS1V16JrWtXdAkHXKG7crN0DZBd2lyifT+JEldlQCGk6vDGNq33GOZ90cdd6azv2
         pY8A==
X-Gm-Message-State: AHQUAuaXGFTgjN+NCPprwksW7XBSKJdlGchQER37gY+l8nNZJai9I6Dh
        w9uSrGNl+0IDllaMmHsTbDXU7g==
X-Google-Smtp-Source: AHgI3IZszRC4HPkaky/VPNjtNCBsCx44kxsEPPkCcTROxN1PjK2lMTvGRPKptyUgqCaCmsQvP5yfQQ==
X-Received: by 2002:a50:d643:: with SMTP id c3mr6783430edj.178.1550227209057;
        Fri, 15 Feb 2019 02:40:09 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id i8sm1444964edg.21.2019.02.15.02.40.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 02:40:08 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>, kbuild@01.org,
        kbuild-all@01.org
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190215061601.GE2304@kadam>
 <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com> <20190215103803.GF2304@kadam>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <87766c4c-f3ec-8f95-0210-0e1971092e61@broadcom.com>
Date:   Fri, 15 Feb 2019 11:40:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190215103803.GF2304@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/15/2019 11:38 AM, Dan Carpenter wrote:
> On Fri, Feb 15, 2019 at 12:04:31PM +0200, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>
>>> Hi Rafał,
>>>
>>> url:
>>> https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bphy_err-in-all-wiphy-related-code/20190214-140004
>>> base:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
>>> master
>>>
>>> smatch warnings:
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114
>>> brcmf_fweh_call_event_handler() warn: variable dereferenced before
>>> check 'ifp' (see line 110)
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187
>>> brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could
>>> be null (see line 184)
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189
>>> brcmf_fweh_handle_if_event() warn: variable dereferenced before check
>>> 'ifp' (see line 187)
>>>
>>> # https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57ddc31ba23376c9
>>> git remote add linux-review https://github.com/0day-ci/linux
>>> git remote update linux-review
>>> git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
>>> vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>>
>>> 5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>> Spriel 2012-11-14 104
>>> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>> Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct
>>> brcmf_if *ifp,
>>> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>> Spriel 2012-11-14 106 enum brcmf_fweh_event_code code,
>>> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>> Spriel 2012-11-14 107 struct brcmf_event_msg *emsg,
>>> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>> Spriel 2012-11-14 108 void *data)
>>> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>
>> This report is very hard to read as the lines seem to be wrapped.
>>
> 
> I feel like removing the filenames would make the reports more legible.
> We can get that information from the git hash if we really need it.
> 
> Maybe just put the filename at the start:
> 
> drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> 5c36b99a Arend van Spriel 2012-11-14 104
> 3e0a97e1 Arend van Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,

Looks good to me.

Regards,
Arend

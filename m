Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B27C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36CA3223AE
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 13:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="dRHLZrgi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36CA3223AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbeKMXcn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:32:43 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:43518 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733229AbeKMXcn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 18:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject; bh=JhIgv2ztgNUTSaJomMtqq/Ao6XEI+705GkZSL6PDSzA=;
        b=dRHLZrgixM/GlBWUL4FsPPmvn/aUH9SKSv7lkwOj2KBKJQ5GBYTsxq1HMaKegh2eQc2lnbUNTwWwgg/dte+rbyy8rfQKK/vSQTHbn4ilKrPcYcYET6maDk2QNQuM1mFwm/EeJ66dP63XgzgMGdBCTQ6zgV12VeBvtHppHmCjpm8=;
Subject: Re: [EXTERNAL] Re: [PATCH] ath10k: Disable 4addr source port learning
 in 10.4 FW by default
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20181109061121.4184-1-murugana@codeaurora.org>
 <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
 <00fd01d4798e$1c0d2f10$54278d30$@codeaurora.org>
 <18df2020-f8c4-b9f7-cf9c-63802ea02429@newmedia-net.de>
 <cc8040a6-47f8-c8f0-0451-2e220d91d62c@newmedia-net.de>
 <4ec664290c20a58f36f2183fc2fd0b4f@codeaurora.org>
 <095fa4b0-883e-192c-e919-0dd0ace026e8@newmedia-net.de>
Message-ID: <cef269dc-b4bc-54a0-5f04-7e4e06bbfe81@newmedia-net.de>
Date:   Tue, 13 Nov 2018 14:34:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <095fa4b0-883e-192c-e919-0dd0ace026e8@newmedia-net.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gMYpr-0002Kx-TV; Tue, 13 Nov 2018 14:34:31 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

is it possible to supply a firmware for 99X0 based devices which suffer 
from the same issue? i know the firmware codebase is the same for these 
chipsets and there are alot of embedded
devices around which this older one. unfortunatly this device suffers 
from the same issue

Sebastian

Am 12.11.2018 um 08:33 schrieb Sebastian Gottschall:
> no problem. glad to help you.
>
> Sebastian
>
> Am 12.11.2018 um 06:34 schrieb Sathishkumar Muruganandam:
>> On 2018-11-12 09:40, Sebastian Gottschall wrote:
>>> i tested my proposal now and it fixes the issue. the submitted patch
>>> was simply broken at that small point
>>>
>>
>> You're right. Thanks for your finding !
>>
>> Due to some reason, my patch formatting missed the vdev param
>> assignments to 10.4 and 10.2.4 (unsupported).
>>
>> Sorry for the confusion, let me resend the patch.
>>
>

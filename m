Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE41C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC5B421722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="HihqKrY9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC5B421722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbeKLRZ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:25:59 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:39997 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeKLRZ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=08GvYfbSFAFXihxLYn382Yx9xh4D4kQ732Hs1UWAfAs=;
        b=HihqKrY9lZK9qKFULrHWIRt5yRYSBRtXKX+3A9GgOhF/RzKu6KXtLwBCW1PsVidKGQJoimI8yS6C8u1Lv1GBD53c3dAC4XXSboLbdELdUOorWn38v6vSAyA/T1fhZ7UpujxmGNHETSAZrsI1SL89oi4XFY0sYehJ8Re2qULtZjk=;
Subject: Re: [EXTERNAL] Re: [PATCH] ath10k: Disable 4addr source port learning
 in 10.4 FW by default
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20181109061121.4184-1-murugana@codeaurora.org>
 <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
 <00fd01d4798e$1c0d2f10$54278d30$@codeaurora.org>
 <18df2020-f8c4-b9f7-cf9c-63802ea02429@newmedia-net.de>
 <cc8040a6-47f8-c8f0-0451-2e220d91d62c@newmedia-net.de>
 <4ec664290c20a58f36f2183fc2fd0b4f@codeaurora.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <095fa4b0-883e-192c-e919-0dd0ace026e8@newmedia-net.de>
Date:   Mon, 12 Nov 2018 08:33:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <4ec664290c20a58f36f2183fc2fd0b4f@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f20:e600:9837:f997:ad57:302d]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gM6jO-0006Qg-K5; Mon, 12 Nov 2018 08:33:58 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

no problem. glad to help you.

Sebastian

Am 12.11.2018 um 06:34 schrieb Sathishkumar Muruganandam:
> On 2018-11-12 09:40, Sebastian Gottschall wrote:
>> i tested my proposal now and it fixes the issue. the submitted patch
>> was simply broken at that small point
>>
>
> You're right. Thanks for your finding !
>
> Due to some reason, my patch formatting missed the vdev param
> assignments to 10.4 and 10.2.4 (unsupported).
>
> Sorry for the confusion, let me resend the patch.
>

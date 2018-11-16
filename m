Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87644C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340C5208A3
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 340C5208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=milecki.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbeKPTPd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:15:33 -0500
Received: from mo183.mail-out.ovh.net ([178.32.228.183]:57527 "EHLO
        mo183.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbeKPTPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 14:15:33 -0500
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2018 14:15:32 EST
Received: from player735.ha.ovh.net (b3.ovh.net [213.186.33.53])
        by mo183.mail-out.ovh.net (Postfix) with ESMTP id D36493B444C
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 09:55:13 +0100 (CET)
Received: from RCM-web1.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player735.ha.ovh.net (Postfix) with ESMTPSA id A08E55CCACF;
        Fri, 16 Nov 2018 08:55:12 +0000 (UTC)
Received: from ip-194-187-74-233.konfederacka.maverick.com.pl
 ([194.187.74.233])
 via ip-194-187-74-233.konfederacka.maverick.com.pl
 ([194.187.74.233])
 by mail.ovh.net
 with HTTP (HTTP/1.1 POST); Fri, 16 Nov 2018 09:55:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 16 Nov 2018 09:55:12 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: wiki: tree labels in patches
In-Reply-To: <87in0x8l4t.fsf_-_@codeaurora.org>
References: <20181108150829.24842-1-zajec5@gmail.com>
 <87lg62cpno.fsf@codeaurora.org>
 <f1e1160ba35a42e12a0162629be23304@milecki.pl>
 <87in0x8l4t.fsf_-_@codeaurora.org>
Message-ID: <b5316181600c25788eb76f246d3482bc@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 9651495479433858584
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrleeigdduvdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-16 09:46, Kalle Valo wrote:
> (changing subject for better visibility and trimming Cc)
> 
> Rafał Miłecki <rafal@milecki.pl> writes:
> 
>> On 2018-11-09 15:05, Kalle Valo wrote:
>>> Rafał Miłecki <zajec5@gmail.com> writes:
>>> 
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>> 
>>>> Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
>>>> important to provide valid & complete info about supported bands for
>>>> each channel. By default no support for 160 MHz should be assumed
>>>> unless
>>>> firmware reports it for a given channel later.
>>>> 
>>>> This fixes info passed to the userspace. Without that change 
>>>> userspace
>>>> could try to use invalid channel and fail to start an interface.
>>>> 
>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>> Cc: stable@vger.kernel.org
>>> 
>>> Should this be queued to 4.20?
>> 
>> That's my suggestion.
>> 
>> I try to mark fixes (patches for currently developed release) with an
>> extra FIX tag in a subject. Do you have any other method in mind that
>> would be preferred by you?
> 
> Yes, I do see your FIX tag in patchwork:
> 
>  [ 31] [FIX] brcmfmac: fix reporting support for 160 MHz channels   
> 2018-11-08
> 
> But "FIX" is a bit ambigous as not all fixes not go to 
> wireless-drivers,
> they can also go to wireless-drivers-next. So I prefer using the 
> release
> number (or name of the tree) like this:
> 
> [PATCH 4.20] brcmfmac: fix reporting support for 160 MHz channels
> 
> After seeing your question I added something about this to the wiki
> which hopefully helps others:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#tree_labels

Got it, thanks!

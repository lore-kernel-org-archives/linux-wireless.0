Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61087ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27BFD214AB
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gJNvu2HD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U09tJVb2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27BFD214AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbeJQSA4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:00:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbeJQSAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 14:00:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 42AB7602D7; Wed, 17 Oct 2018 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539770755;
        bh=mES2zFTj+jVq9qtHlN4ZewCZPFyKqJEIJlKXkRkoICU=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=gJNvu2HD8SDOQRR1rqPv5ZFAaJjRp43s8oFIey3X8YZJ6lr+3+rJrlLktmUMQSirV
         0PKXZNRXsa06QsvHtXIMs8Xu4tu0bEUSzQZS9kPX0S7YqQO4l8vDFGGuayJGbYsvwb
         NkwhoJ4GBzzlh23s8X64e51AX8AvtS5t4eL2Rpk0=
Received: from [10.18.172.103] (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liord@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5973602D7;
        Wed, 17 Oct 2018 10:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539770754;
        bh=mES2zFTj+jVq9qtHlN4ZewCZPFyKqJEIJlKXkRkoICU=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=U09tJVb2xNkp70FQ2eLvgv59wVqYgsKxqLcAdEJELTb0D36ZejmGznQbcai3jscbc
         ELNJCrDqgQkvdLuMoApJ8Qld+VGnffHyTuDBP1/kAPNlTjgC7DKraLhabPu7YE0NbI
         8gK5nDx8P6CiB8AN6DV1R2crH2ueKXEtJZcCWqPg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D5973602D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=liord@codeaurora.org
From:   Lior David <liord@codeaurora.org>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
 <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
 <1538942338.2928.21.camel@sipsolutions.net>
 <0c64b665-5dc6-df94-4d49-a3adfc12f745@codeaurora.org>
 <1539252323.3687.207.camel@sipsolutions.net>
Message-ID: <73dc838a-a703-e587-f1fd-bd492fa900af@codeaurora.org>
Date:   Wed, 17 Oct 2018 13:05:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1539252323.3687.207.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 10/11/2018 1:05 PM, Johannes Berg wrote:
> 
>> Thanks for the explanation. The send to same socket does sound more efficient.
>> (In our internal implementation with vendor commands we were forced
>> to send the results as broadcast...)
> 
> I suppose we can fix that, in the sense that we can add API to allow
> vendor commands to know the socket to send back to etc.
> 
I think that would be useful in general though as far as I know we don't have
any pending feature that requires it right now.

[...]

>>
>> As I remember the driver/FW can easily find the connected channel for connected
>> station. For unconnected station we should probably force this parameter.
> 
> Should be able to, yes, but I suppose even userspace can. It just seems
> like extra complexity to impose on the driver, since cfg80211 doesn't
> necessarily have all the right information.
> 
Agree with this. I guess we can keep the channel parameter mandatory.

> Actually, hmm, that would imply "use maximum bandwidth" or something?
> And then what if that bandwidth isn't possible with FTM for some reason?
> It's a bit tricky then.
> 
DMG always uses the entire channel (2160MHz). We may need to use partial channel
in EDMG but not sure yet. We have an upcoming patch for EDMG support so we can
deal with this later.

>>
>> Good point. I see we currently use 20_NOHT for DMG, guess we can continue using it.
> 
> Well, I think it'd make more sense to just enforce the DMG bandwidth
> everywhere, but I won't force the issue over this.
> 
Ok. I think using 20_NOHT for now is more consistent since other APIs specify it
for DMG channels.

Thanks,
Lior

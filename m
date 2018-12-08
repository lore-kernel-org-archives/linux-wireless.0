Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40155C04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 14:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 552E42082D
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 14:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="ujH9J76T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 552E42082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbeLHO0u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 09:26:50 -0500
Received: from 4.mo179.mail-out.ovh.net ([46.105.36.149]:34432 "EHLO
        4.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeLHO0t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 09:26:49 -0500
Received: from player776.ha.ovh.net (unknown [10.109.143.109])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 6445B10CB51
        for <linux-wireless@vger.kernel.org>; Sat,  8 Dec 2018 15:09:33 +0100 (CET)
Received: from awhome.eu (p57B7E595.dip0.t-ipconnect.de [87.183.229.149])
        (Authenticated sender: postmaster@awhome.eu)
        by player776.ha.ovh.net (Postfix) with ESMTPSA id 1EACE9C0BEB;
        Sat,  8 Dec 2018 14:09:31 +0000 (UTC)
Subject: Re: [RFC PATCH v2 0/2] Extended Key ID support for linux
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544277540;
        bh=ixkPORjU1fNpkWiHjPeQwaJaXK5xfTMwQG/bvBIXn1w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ujH9J76TqditZnYF41zHxxc1HEHLixgewyMvqxoYwxLEEa38bG0veD0LI28bn0bE/
         Kfe7Pgvwssjz0FoI36kjsTe3q1wpImtc4hWAccdJ6UoRHWotYT8XTLkVUDYrJR68cX
         kQ8SpRKdWdbaUcQMaKXYT0jZ8m70Y2pW6OUL/j38=
To:     Jouni Malinen <j@w1.fi>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <6102d09bb53a59b2789e31d84ffdda45165a895c.camel@sipsolutions.net>
 <f20cc734-c861-289c-c041-3fc99f1a5015@wetzel-home.de>
 <20181207100150.GA6183@w1.fi>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <cc54c8c1-8310-0ce2-b28b-c31db3aa3b2e@wetzel-home.de>
Date:   Sat, 8 Dec 2018 14:58:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181207100150.GA6183@w1.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15032171133840202951
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudeguddgieduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>> I got the impression Extended Key IDs were  added without updating all
>> sections which should get updates. But the pattern is suspect, even the igtk
>> numbers fit into the pattern:
>>
>>   PTK 0 & 1
>>   GTK 1 & 2 & 3
>> iGTK 4 & 5
> 
> An AP is allowed to do this, but there is no requirement for doing so.
> The pairwise key (TK, not PTK) is required to use Key ID 0 unless the > optional Extended Key ID for Individually Addressed Frames capability is
> negotiated (and 0 or 1 if that capability is negotiated). Group keys
> (GTK) are allowed to use Key IDs 0..4. IGTKs are allowed to use Key ID
> values 4 and 5.
> 
> There is a long history behind this and some de facto constraints due to
> that history and possible implementation constraints. However, as far as
> the protocol itself is concerned, there would be no real need for having
> IGTK use 4..5; it could have as well been 0..1 or 1..2 or whatever
> combination the AP would like to use.
> 
> These three cases have completely independent namespaces for Key IDs as
> far as RSN is concerned with one exception: "Use group cipher suite"
> that was added as an option for some AP implementation that did not
> support individual key mapping. That special case would end up using GTK
> for both group-addressed and individually-addressed frames. That said,
> I'm not aware of there having ever been an actually deployed device with
> this constraint and even if there were, this mode is highly discouraged
> and should not be used for anything today. Anyway, this exception and
> similar implementation constraints are likely behind the expectations of
> TK and GTK having to use different Key ID values.

Thanks for the clarifications!
If there really are drivers using "Use group cipher suite" it does not 
sound like they would be able to support Extended Key ID with APs using 
key ID 1+2 for GTKs. But sounds not likely anyone would need that...

My experimentation with hw accel and Extended Key ID for existing 
drivers so far are also indicating that it will work using the keyid 1 
for both PTK and GTK, so this should be a trivial change in hostapd only.

> 
> As far as the kernel changes are concerned, cfg80211 and mac80211 should
> support everything that's allowed by the standard, i.e., use of Key IDs
> 0..3 for GTK. It is up to the user space implementation on the AP side
> (e.g., hostapd) to select which Key IDs are actually taken into use.
> 

I'm pretty sure that is already the case, but so far I only tested it 
with GTK shifted to 2+3. I'll make sure to test the next revision with 
GTK using 1+2 also. I'll test that once I get that working again from 
end2end. The patch here is getting a bit dated and makes no sense to 
invest time for that win it.

Alexander

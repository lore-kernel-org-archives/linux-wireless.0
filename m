Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBD8C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C222175B
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JWnkyXea";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m3YtD2Pv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfA3K1j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:27:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbfA3K1i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 05:27:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C449F60D02; Wed, 30 Jan 2019 10:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548844057;
        bh=xeFbAGv+R+EEpUiVr3bBHr5qEmeuBaUllI1G1umJIxo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JWnkyXeai0tPpFLQjXd/O6MmUN5KWSSSLfkaOdfvUQN6xDYuXi4+WiwK2J3fL8SNh
         BEh/CmS2tKqZ64maVoIQZWCP4l76S9FnWl6BtmmOXUnBOKmyQ+LPlmm6Vy3zcGOa70
         WLqo/+fDhEwNTl/IZJ6W3g9rOLyPmbbtMSL4j3V4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8C5ED60C69;
        Wed, 30 Jan 2019 10:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548844056;
        bh=xeFbAGv+R+EEpUiVr3bBHr5qEmeuBaUllI1G1umJIxo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=m3YtD2PvjxZIqEx5lPDyu9K0kb/yNK67bN1b43N6BStqgW5KCZANIh2kBCGM4Uodm
         7YFJ1ixmszdpYq/eA81lmx24zF6qok0ZB9QAJYE//QsMUdvte8aqAVc1pXPmrqfnDy
         UCtMLYOoXPzq7G52KEw3psS+cVhgGSxT9xPeyIfw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8C5ED60C69
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
        <87a7jju1mv.fsf@purkki.adurom.net>
        <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
        <87k1inwtu5.fsf@codeaurora.org>
        <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
        <20190130082937.GA2720@redhat.com>
Date:   Wed, 30 Jan 2019 12:27:33 +0200
In-Reply-To: <20190130082937.GA2720@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 30 Jan 2019 09:29:39 +0100")
Message-ID: <87fttal9t6.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, Jan 29, 2019 at 01:10:08PM +0100, Felix Fietkau wrote:
>> On 2019-01-29 13:07, Kalle Valo wrote:
>> > Felix Fietkau <nbd@nbd.name> writes:
>> > 
>> >> On 2019-01-29 12:47, Kalle Valo wrote:
>> >>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> >>> 
>> >>>> We can configure beaconing, but without TBTT interrupt we
>> >>>> can not support PS buffering. This can be added later using
>> >>>> kernel hrtimer, if we can keep it in sycn with device timer.
>> >>>>
>> >>>> I tested AP and IBSS modes.
>> >>> 
>> >>> So how does this work reliably so that there's no packet loss with
>> >>> clients using power save?
>> >>
>> >> There will be multicast packet loss for clients using power save.
>> > 
>> > Isn't that a problem? At least as a normal user I would very frustrated
>> > if sometimes my connection work and sometimes not, for example if I'm
>> > trying discover devices from my network. Hopefully nobody won't use USB
>> > devices for any real AP stuff, but still enabling something which we
>> > know doesn't work realiably is concerning.
>> I agree. Maybe we should leave out the flag for AP mode in this patch
>> until we have PS buffering and leave the rest of the code intact.
>
> But how serious problem of dropping multicast frames for PS stations
> is?

It's _both_ broadcast and multicast frames. Felix already mentioned ARP
but there are also other protocols which rely on broadcast/multicast
frames.

> I don't think from user perspective this is "sometimes my connection
> work and sometimes not", but something much less annoying.

So basically you are saying that we should just depend on lock and hope
that users don't notice the packet loss. I don't think that's really
good design philosophy.

> Moreover in the tree we have already bunch of drivers that do 
> advertise AP mode support without HOST_BROADCAST_PS_BUFFERING 
> like iwlwifi or brcm80211 .

After seeing how much those drivers are tested I would be very surprised
to see that their broadcast and multicast packet handling is broken.

> So I don't think we should drop AP flag, AP mode works with
> this patch set quite well.

"Works" is a very broad statement and depends on what you have tested.
Sure, if you tested tested with ping and iperf from a client to AP
without using power save mode that will work. But if you try to connect
from another device on the network to another client using aggressive
power saving it's a totally different situation.

Back in the Nokia N800 days I wasted a lot of time debugging all sort of
buggy APs which didn't work correctly with power save, it was really
annoying and very frustrating for the users. Let's not do the same
mistakes, we are better than that.

-- 
Kalle Valo

Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0988CC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C840F20684
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X1uvhbAR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cwCe722b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCHKj7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:39:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHKj6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:39:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A01CE60312; Fri,  8 Mar 2019 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552041597;
        bh=ggZBrKEq+50k2hn5pLbZAF3jrNu7bSg9rHOcUUJ0T5o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X1uvhbAR1MaMVL7vw61jIQiRr3qimBmAaKnj8pn//sH8XkVxvCITNpkkwXiZ1208l
         HaClGcwrqhRkpwI2BO+CZIAg8lQKgfycqDFxLaLPg1rv2bKkf1KtAxHeCSRG3JJaBu
         s1fQX6Z78+bucDvU5oWWqrD31eVBFSQ3UDMvMFRc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84BD56016D;
        Fri,  8 Mar 2019 10:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552041596;
        bh=ggZBrKEq+50k2hn5pLbZAF3jrNu7bSg9rHOcUUJ0T5o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cwCe722bR3wPA3GHfDZzSCq2MHx0uZocGxM0GMxBZn5AqKEapxHK5glNTmwCByWHG
         P/o/jF9y9aFCKsQlrAFXa/Qz8gDXPyrwNJLdPHFEaS10ehfvVUgqwk0cuhAs+n/raI
         nqLkURoGUjvzCxRr6BcR6ZupWvfBIoBl++sxc8rk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84BD56016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris\@chromium.org" <briannorris@chromium.org>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>
Subject: Re: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable functionalities
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
        <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
Date:   Fri, 08 Mar 2019 12:39:51 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Tue, 26 Feb 2019 08:20:33 +0000")
Message-ID: <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> 
>> Note this patch set is based on patch set "rtw88: mac80211 driver for
>> Realtek 802.11ac wireless network chips". For reference:
>> https://patchwork.kernel.org/cover/10811967/
>> https://lkml.kernel.org/linux-wireless/1550131671-2601-1-git-send-email-yhch
>> uang@realtek.com/
>> 
>> These patches are mean to make sure 8822c chip to operate normal for most
>> of the basic functionalities, such as power on, switch channel, scan,
>> connection establish and connection monitor.
>> 
>> As the original patch set was sent 3 months ago, progress has been made
>> by Realtek during the past months. Now we have tested on more chips and
>> released tables and parameters for them. Also the chips are all
>> programed with efuse map released for 8822c.
>> 
>> Most of the changes are about BB and RF, both control the tx/rx path.
>> PHY parameters/seq and efuse info make sure the hardware is powered on
>> correctly. And channel setting updates help driver to switch to target
>> channel accurately. Then trx mode setting and DACK will make hardware to
>> have stable performance to tx/rx to connect to AP.
>> 
>> Here tx power control is also required to transmit with a precise power.
>> Otherwise if the power is too high or too low, the peer might not be able
>> to receive the signal.
>> 
>> Finally, we need to report correct tx status for mac80211's connection
>> monitor system, this requires firmware's C2H of tx status report. After
>> this, users can use 8822c chips for more stable wireless communication.
>> 
>> 
>> v2
>> 
>> This v2 is sent for that https://patchwork.kernel.org/cover/10811967/
>> has many modifications and the original patch set would not apply.
>> Also with a few changes in this one. Listed below
>> 
>>  - report ACK for tx frames not have IEEE80211_TX_CTL_REQ_TX_STATUS,
>>    otherwise they will be marked as "drop"
>>  - add more rf register write protection for patch "rtw88: add a delay
>>    after writing a rf register"
>> 
>
> Can I ask that when will this patch set probably be applied into your tree?

Once everyone are happy about the driver, at least it needs a review
from Johannes and me but reviews from others is more than welcome. I
also saw that Brian gave good comments but not sure if he thinks the
driver is ready for upstream?

An ideal schedule is to apply the driver just after the -rc1 is release,
so within two weeks time. That way we have maximum time to fix any
problems which might arise.

Did Stanislaw already review this driver? I don't see any mentioning of
that in the cover letter[1].

For now freeze please the developement on the driver to make the review
easier. So don't do any changes unless asked by Johannes or me. You can
of course do development on a separate branch and submit fixes after the
driver is accepted upstream.

The cover letter mentions nothing about what features are supported,
that's the first thing I would like to see when I start reviewing a
driver. Also a list of missing features, problematic areas and major
bugs would be very helpful to understand the state of the driver.

I don't see any mention about firmware availability in the cover letter,
please add that.

Also in another thread I saw something about this driver conflicting
with a staging driver, is that true? That should be solved before the
driver is accepted as I don't think two drivers should race for the same
hardware and the driver is randomly chosen.

And in v6 please fold the fixes from this patchset to the original
patchset[1] adding the driver (using the one patch per file format).
That way there's one set of patches to review.

I have now applied both patchsets to the pending patch for build testing
and easier review:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=pending

[1] https://patchwork.kernel.org/cover/10811967/

-- 
Kalle Valo

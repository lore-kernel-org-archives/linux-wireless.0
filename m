Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FF4C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5C220877
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lTmszgcP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ET+wm7Nj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D5C220877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbeJDTVH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:21:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeJDTVH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:21:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2C60D60C72; Thu,  4 Oct 2018 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656083;
        bh=CIj0q6p4RVIBMGI1YwOfQ1FUoCYLVwpp6EV2KqY3GkM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lTmszgcPfkIdGG517k70fmcZ/7TYPkvzbkUoxUKJdd3/Hb++3YLneoNnlTBEO1n6r
         6XpNKJzD7RnFEs2Q11JBBlVmqM0sTjfbo6SlgNql5KIaR5BIKnF0f8eA0LNcGa2psv
         ICULCAgtDn4BurVAYRAyxyFmLtKqPqfjqWqkXlZE=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CFB660C6A;
        Thu,  4 Oct 2018 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656082;
        bh=CIj0q6p4RVIBMGI1YwOfQ1FUoCYLVwpp6EV2KqY3GkM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ET+wm7Nj9orKlryBbpj1j1DWmp2zqsyD37tNVp4bTSo74OuxHiXudywq3Trywhr/y
         YAdYHm+k7+tbUWPhXlf/CSmDAMTKhywBRADaVuaePKCeqCIXreMtq13KelFgN4Me2q
         /61mRSWGTjflnG7T4zJ8s+kf46AFSXxgRAqVu5Tc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CFB660C6A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Nicolas Ferre - M43238" <Nicolas.Ferre@microchip.com>,
        Ganesh Krishna - C00112 <Ganesh.Krishna@microchip.com>,
        Adham Abozaeid - C43058 <Adham.Abozaeid@microchip.com>,
        Aditya Shankar - I16078 <Aditya.Shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net> <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
        <8736vdv3f5.fsf@kamboji.qca.qualcomm.com>
        <5B768574.6060009@broadcom.com>
        <87y3d5tmod.fsf@kamboji.qca.qualcomm.com>
        <20180817143911.5f0ee545@ajaysk-VirtualBox>
        <87r2ipnxxa.fsf@kamboji.qca.qualcomm.com>
        <20180926155743.032caa37@ajaysk-VirtualBox>
Date:   Thu, 04 Oct 2018 15:27:57 +0300
In-Reply-To: <20180926155743.032caa37@ajaysk-VirtualBox> (Ajay Singh's message
        of "Wed, 26 Sep 2018 15:57:43 +0530")
Message-ID: <871s953nhu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ajay Singh <ajay.kathat@microchip.com> writes:

> Hi Kalle,
>
> On Thu, 23 Aug 2018 16:37:45 +0530
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Ajay Singh <ajay.kathat@microchip.com> writes:
>> 
>> >> >>> We need help to review and identify if there are any pending
>> >> >>> items for wilc1000 driver, so we can address those issues and
>> >> >>> make it ready to move to the wireless subsystem.    
>> >> >>
>> >> >> I think the best way to get that forward is to submit a patch
>> >> >> (or patchset) to linux-wireless, that's the easiest for
>> >> >> reviewers.    
>> >> >
>> >> > For brcm80211 drivers we used a single patch introducing it under
>> >> > the wireless drivers folder. Because it was quite a sizable
>> >> > patch we parked it on the wireless wiki page. Had a few
>> >> > iterations doing it like that.    
>> >> 
>> >> Another option is to split it so that there's one patch per file,
>> >> should be even pretty easy to automate that. It's just so much
>> >> easier to comment on a patch submitted by email compared to the
>> >> reviewer manually copying code and then commenting it, yuck.
>> >>   
>> >
>> > Sure. I will prepare a patch per file send for review as its easy to
>> > review.
>> >
>> > As Greg suggested, I will wait for the merge window to close and
>> > after completing pending patches to staging, I will start the
>> > review.
>> >
>> > For my understanding, the patches for review will be based on
>> > wireless-testing branch.  
>> 
>> In this case I think wireless-drivers-next is the safest choise,
>> wireless-testing also has other trees which might cause conflicts etc.
>
> I have submitted a patch series for wilc1000 driver, single file
> per patch and its based on wireless-drivers-next. 
> I hope its done correctly, please provide inputs so we can
> address and make this driver ready for mainline.

Thanks, I see it in patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?series=23251&state=*&order=date

Do note that we have also another new driver (rtwlan/rtw88) under review
so review from the wireless folks might take some time.

-- 
Kalle Valo

Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE694C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 12:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72FED222D0
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 12:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eEng4e5s";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NPaxeQRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfCXMar (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 08:30:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfCXMar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 08:30:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6955B60364; Sun, 24 Mar 2019 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553430646;
        bh=ywSgr2r71j3sQt96mYeapG3Djycj+Z0XAeMS7xGxtRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eEng4e5s+i7h/jpx+wna534sYgItelSFArcv61xV+hH99BSqa6F+q5sWqjPKrkwyI
         gCsAYYpeNttsmSlBRuObVM0NoMLx5iNOwk0tPfTQC0flnnsCyuFsW1PfGD6ue4qy1h
         tP8AmUTT5qlJ61/LluwbCJpplEsv31J5c3tttkhU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id CB22760364;
        Sun, 24 Mar 2019 12:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553430645;
        bh=ywSgr2r71j3sQt96mYeapG3Djycj+Z0XAeMS7xGxtRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NPaxeQRMb2D0PoAlS/BKG0Juuw6j2Y8ps7K98z4DdHgBU584h55I94xbMkHTRGvTD
         aHQRm9yLgoqFb4XjHWbQdjgnGRf3bJyu+eVAtkzD0nPV32GdMUbqbCMjSzt5lCoDNI
         1/QJ51XVg3XdU7ciA2n2/cahy3Lks50YP7Vdq1jo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 24 Mar 2019 14:30:45 +0200
From:   merez@codeaurora.org
To:     Robert Marko <robimarko@gmail.com>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: wil6210 firmware version
In-Reply-To: <CAOX2RU6wFpaP7Zm1MmvJTkxXL12Cz9VcWFvYTJzn=1=9g3wj9Q@mail.gmail.com>
References: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
 <0aabbc6e74fefa8bd5a094dc84b1f87c@codeaurora.org>
 <CAOX2RU6wFpaP7Zm1MmvJTkxXL12Cz9VcWFvYTJzn=1=9g3wj9Q@mail.gmail.com>
Message-ID: <64d97528f4fb088830a5dbcd8b74e934@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-14 12:05, Robert Marko wrote:
> Biggest thing would be Channel 4 support as it is supported by driver
> but requires FW support also.
> But I would also like 20 station limit instead of 8.
> 
> Cheers
> Robert Marko

Those features are supported only on Talyn device (latest wil6210 HW), 
which is not available in market yet.

Thanks,
Maya

> 
> On Thu, 14 Mar 2019 at 11:03, <merez@codeaurora.org> wrote:
>> 
>> On 2019-03-14 11:07, Robert Marko wrote:
>> > Hi,
>> > I am working on OpenWrt support for device using wil6210 card.
>> > I am using firmware and board file provided in linux-firmware for its
>> > development but it appears tha most of newer features that driver
>> > enables are firmware dependant and version 5.2 in linux-firmware is
>> > too old to expose those.
>> >
>> > Is there any chance of QCA pushing updated version to linux-firmware?
>> >
>> > Thanks
>> > Robert Marko
>> 
>> Is there any specific feature you are interested in?
>> 
>> --
>> Maya Erez
>> Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
>> a
>> Linux Foundation Collaborative Project

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project

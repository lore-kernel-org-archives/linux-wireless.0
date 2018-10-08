Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B70BC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154952075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kwo5RfSX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kwo5RfSX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 154952075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbeJHPbu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:31:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeJHPbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:31:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C4FC96079B; Mon,  8 Oct 2018 08:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538986877;
        bh=ibY0uXoZ4oYjo/4Vt7cSFaFS3WcmuUzKbqiec3E6Ea0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kwo5RfSX4CY8hivfCVPnBZ+IkG8x/BktKJK3qBALnwZQ3Ngc6Hoinhuc045G9I31o
         Y5DtCtnmpPh8MO6aXMGwdqF4eCx2g+MIIuL1m2b/IZ4g8LWzxH1hlbY3oGQ0JUQ1bF
         +V5FWwAHFKXLyD1Mv8p4RBuHynHu00KF6OxtltSU=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 089F6602F1;
        Mon,  8 Oct 2018 08:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538986877;
        bh=ibY0uXoZ4oYjo/4Vt7cSFaFS3WcmuUzKbqiec3E6Ea0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kwo5RfSX4CY8hivfCVPnBZ+IkG8x/BktKJK3qBALnwZQ3Ngc6Hoinhuc045G9I31o
         Y5DtCtnmpPh8MO6aXMGwdqF4eCx2g+MIIuL1m2b/IZ4g8LWzxH1hlbY3oGQ0JUQ1bF
         +V5FWwAHFKXLyD1Mv8p4RBuHynHu00KF6OxtltSU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 089F6602F1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: Re: Asus RT-AC58U boardfile (was Re: [PATCH 2/2] ath10k: search DT for qcom, ath10k-calibration-variant)
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
        <3853747.Q0JJmSnsYM@debian64>
        <87bmj9tup8.fsf@kamboji.qca.qualcomm.com>
        <5423847.QPV7e8Q2Ao@debian64>
Date:   Mon, 08 Oct 2018 11:21:13 +0300
In-Reply-To: <5423847.QPV7e8Q2Ao@debian64> (Christian Lamparter's message of
        "Mon, 29 Jan 2018 21:09:50 +0100")
Message-ID: <87in2cetmu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> Sven's boarddata for the OpenMesh A42 has been accepted. \o/
> So let's try to get the board data for the RT-AC58U merged.
>
> On Friday, December 8, 2017 10:50:12 AM CET Kalle Valo wrote:
>> > I've attached the necessary bmi-board-id=16 and bmi-board-id=17 board 
>> > files to this mail as well. So, all that needs to be done is to add
>> > them to the board-2.bin on your codeaurora / ath10k-firmware project.
>> >
>> > Kalle: Can you please update the board-2.bin for the IPQ40XX on your
>> > ath10k-firmware project on github?
>
> Since some time has passed since the original submission, I just stick to
> answering the questions in the the guide from:
> <https://wireless.wiki.kernel.org/en/users/drivers/ath10k/boardfiles>
>
>> description for what hardware this is
> The hardware is the ASUS RT-AC58U [0]. It has a IPQ4018 SoC which
> hosts two ath10k wifis. <https://www.asus.com/Networking/RT-AC58U/>
> It's based on the qcom-ipq4019-ap.dk01.1-c2. machid: 0x8010100 .
> the 5GHz and 2.4GHz radio components were drastically changed and
> as a result, the device's wifis don't work very well with the reference
> board-2.bin values. The 5GHz wifi suffers the most, the max throughput
> tops out at 6 Mbps, even in the best possible "lab conditions".
>
>> origin of the board file (did you create it yourself or where you downloaded)
>
> These files are available in ASUS's GPL Source Code release.
>
> The source code can be downloaded from this site:
> <https://www.asus.com/Networking/RT-AC58U/HelpDesk_Download/>
> Just select "Driver & Tools" in the right frame and "Others"
> in the "Please select OS". It's the second tab called "Source Code":
>
> |Version 3.0.0.4.380.8119
> |2017/10/30  522.32 MBytes
> |GPL of ASUS RT-AC58U for firmware 3.0.0.4.380.8119
> (Note: If you press "Show all", it will list two older releases as well.
> The boarddata files I sent you back then came from the original 
> GPL_RT-AC58U_3.0.0.4.380.6516-g6772678 release. But the boarddata_*.bin
> files have been updated since. So I'm attaching the new ones this time.)
>
> The zip file contains one big GPL_RT-AC58U_3.0.0.4.380.8119-gdb642b4.tgz
> which in turn contain these these two files.
> asuswrt/release/src/router/qca-wifi-fw.ipq40xx/RT-AC58U/boarddata_0.bin
> asuswrt/release/src/router/qca-wifi-fw.ipq40xx/RT-AC58U/boarddata_1.bin
>
> I took the liberty of renaming the files to:
>
> boarddata_0 -> bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=ASUS-RT-AC58U.bin
> boarddata_1 -> bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=ASUS-RT-AC58U.bin
>
>> ids to be used with the board file (ATH10K_BD_IE_BOARD_NAME in ath10k)
>
> Following OpenMesh A42 example of "VENDOR-DEVICE", I choose to go with:
> "ASUS-RT-AC58U" as the variant string:
>
> full board name (ATH10K_BD_IE_BOARD_NAME):
> bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=ASUS-RT-AC58U
> bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=ASUS-RT-AC58U
>
>     {
>         "data": "bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=ASUS-RT-AC58U.bin", 
>         "names": [
>             "bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=ASUS-RT-AC58U"
>         ]
>     }, 
>     {
>         "data": "bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=ASUS-RT-AC58U.bin", 
>         "names": [
>             "bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=ASUS-RT-AC58U"
>         ]
>     },   
>
>     (if this is appended at the end of board-2.json, please remove the
>      last comma)
>
>> attach the actual board file (board.bin)
> attached.
>
> just in case. These are the sha256sum:
> d9eb177737983ed320027d50711fd17fadc8057ff0a99d1d455342ef7a7bb1af  \
>     bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=ASUS-RT-AC58U.bin
>
> 24969cd91553fd915c51a8fe51c7b7e0e273679e1349b47d0a6c5ef4b4bb4a1b  \
>     bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=ASUS-RT-AC58U.bin
>
> I also verified that the ASUS' firmware for the RT-AC58U 
> (FW_RT_AC58U_30043808119.ZIP) uses the very same files.

Added, thanks. But please do double check that I didn't do any mistakes.

https://github.com/kvalo/ath10k-firmware/commit/4b89c2b7efef0ba663339c1a42c673e97c7562bd

-- 
Kalle Valo

Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ABEC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E3E9217F5
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lOO0mFd2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lOO0mFd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405667AbfBOKof (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:44:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60622 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbfBOKof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:44:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E86BB6020A; Fri, 15 Feb 2019 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550227473;
        bh=1cJfnZfzDhAQLPiu4ha81cbpaeJn+gDDFU2pj6dLpf8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lOO0mFd2I8bPlDHZKa1z4fTOvJ8T2h8aopE40xXKu02u3H6u6se5+yeLXj1jPXWNL
         P2YMXazvmMwqOdySojMUOWyLao0o+uMqo12XxOIPSFapdx7VruwcxBsz8f/9JCmySG
         Xab7gYr8xGcj0ox1McKtJw2XJFHpXXto9PUIvlzY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDEE5606FC;
        Fri, 15 Feb 2019 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550227473;
        bh=1cJfnZfzDhAQLPiu4ha81cbpaeJn+gDDFU2pj6dLpf8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lOO0mFd2I8bPlDHZKa1z4fTOvJ8T2h8aopE40xXKu02u3H6u6se5+yeLXj1jPXWNL
         P2YMXazvmMwqOdySojMUOWyLao0o+uMqo12XxOIPSFapdx7VruwcxBsz8f/9JCmySG
         Xab7gYr8xGcj0ox1McKtJw2XJFHpXXto9PUIvlzY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CDEE5606FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
        kbuild-all@01.org, Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        \<brcm80211-dev-list.pdl\@broadcom.com\>\," 
        <brcm80211-dev-list@cypress.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
References: <20190215061601.GE2304@kadam>
        <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
        <CACna6ryji=s3CNc4DHrcQnUKjTV1Dt2rGUyYM+1AVG67Hu4Jag@mail.gmail.com>
Date:   Fri, 15 Feb 2019 12:44:28 +0200
In-Reply-To: <CACna6ryji=s3CNc4DHrcQnUKjTV1Dt2rGUyYM+1AVG67Hu4Jag@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 15 Feb 2019
 11:08:34 +0100")
Message-ID: <871s49z5yr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On Fri, 15 Feb 2019 at 11:04, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>
>> > Hi Rafa=C5=82,
>> >
>> > url:
>> > https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bph=
y_err-in-all-wiphy-related-code/20190214-140004
>> > base:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers=
-next.git
>> > master
>> >
>> > smatch warnings:
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114
>> > brcmf_fweh_call_event_handler() warn: variable dereferenced before
>> > check 'ifp' (see line 110)
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187
>> > brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could
>> > be null (see line 184)
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189
>> > brcmf_fweh_handle_if_event() warn: variable dereferenced before check
>> > 'ifp' (see line 187)
>> >
>> > # https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57dd=
c31ba23376c9
>> > git remote add linux-review https://github.com/0day-ci/linux
>> > git remote update linux-review
>> > git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
>> > vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>> >
>> > 5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>> > Spriel 2012-11-14 104
>> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>> > Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct
>> > brcmf_if *ifp,
>> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>> > Spriel 2012-11-14 106 enum brcmf_fweh_event_code code,
>> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>> > Spriel 2012-11-14 107 struct brcmf_event_msg *emsg,
>> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>> > Spriel 2012-11-14 108 void *data)
>> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
>>
>> This report is very hard to read as the lines seem to be wrapped.
>
> I think it's your client playing tricks on you. I got the report
> correctly formatted and so did patchwork:
> https://patchwork.kernel.org/comment/22483031/

Now that's weird, Gnus has never failed me like this before. And I
remember I didn't have this problem with Dan's previous report few days
ago and all the other reports before that. Oh well, no time to
investigate so have to hope that this line wrapping magically disappears
as it appeared :)

--=20
Kalle Valo

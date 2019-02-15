Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB75C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD9EB21924
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OXHUL2Z1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TtRP+hDo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbfBOKEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:04:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfBOKEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:04:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 436F16030D; Fri, 15 Feb 2019 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550225077;
        bh=hD0d3QFlcN6nCOSoaSyxqRU8cxoNcDuYXRZNZvj/s0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OXHUL2Z1ZRjtjnazdAQKlkJ2OXFvqMJdU0IBWCeH5oJ1cPhv8hZCCXeCFeJJ4Q6CN
         uX8J2YuS/nLSuD42EOJlp4qo4UohMv3KVv4ltk1JW6LE7riGIsJq/uxMfDe8Z5OKep
         Q3ffyYlEdxnwjeCFveNhE7BKpYCLKhR3KTmriUhY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B3A06020B;
        Fri, 15 Feb 2019 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550225076;
        bh=hD0d3QFlcN6nCOSoaSyxqRU8cxoNcDuYXRZNZvj/s0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TtRP+hDoQPw+mABO0devRS8/OY6ppNLhKftsAiT9nKQvMaanWgL0dDuZ13OLwXT1T
         CYlwRj4RBo1WLt/qdD3qPGqxMsgLnLmW3/FsRZ0BLLJVyKxRIVZgaFJUW9Hc9q1u/C
         lbp4RII4HEZK0n3Z9LAb8V7AKqi1d+HoCBDI7l+Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B3A06020B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@01.org,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        kbuild-all@01.org, Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
References: <20190215061601.GE2304@kadam>
Date:   Fri, 15 Feb 2019 12:04:31 +0200
In-Reply-To: <20190215061601.GE2304@kadam> (Dan Carpenter's message of "Fri,
        15 Feb 2019 09:16:01 +0300")
Message-ID: <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Hi Rafa=C5=82,
>
> url:
> https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bphy_e=
rr-in-all-wiphy-related-code/20190214-140004
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-ne=
xt.git
> master
>
> smatch warnings:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114
> brcmf_fweh_call_event_handler() warn: variable dereferenced before
> check 'ifp' (see line 110)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187
> brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could
> be null (see line 184)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189
> brcmf_fweh_handle_if_event() warn: variable dereferenced before check
> 'ifp' (see line 187)
>
> # https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57ddc31=
ba23376c9
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
> vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>
> 5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> Spriel 2012-11-14 104
> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct
> brcmf_if *ifp,
> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> Spriel 2012-11-14 106 enum brcmf_fweh_event_code code,
> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> Spriel 2012-11-14 107 struct brcmf_event_msg *emsg,
> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> Spriel 2012-11-14 108 void *data)
> 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van

This report is very hard to read as the lines seem to be wrapped.

--=20
Kalle Valo

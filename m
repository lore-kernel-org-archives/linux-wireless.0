Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFEBC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEC22087E
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547479878;
	bh=JQjjJr7MNjtgcQ2512YojCbYPo9rt37lCeoc+f82Sfo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=mJLRKwna1QF8Mps16f9aib5PDKxIf1xw3u6nNSCCF8IhOjASwr0mMMC7mZSF1lsje
	 IK7jg2jGWxeEkj3k9dnaodAC7p+dn/RGhnD2clzKap3YpN+pbBNjDWxcFThguTR0qf
	 wV+/Or2bhHfJUZT03xiE08azpIFezMPU/TNvL+gg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfANPbR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfANPbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 10:31:15 -0500
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4577208E4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547479875;
        bh=JQjjJr7MNjtgcQ2512YojCbYPo9rt37lCeoc+f82Sfo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1XtOzqml1YE/MYNSEYKfF5qVoV44+txpg4wNh3VbzY3QRp6oWojAbzUFKy/i/nwVs
         DLw0Xt8GZAkSZ5Na7EgRBR2JHgZqphqYq//5SJES5ZYQI3zWCjYm1iNEB9w3V7kRIY
         CD1yHdd0Fmh6lBImrU89uWiu9VLPmW25ygWHBwKk=
Received: by mail-qt1-f178.google.com with SMTP id d19so26891888qtq.9
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 07:31:14 -0800 (PST)
X-Gm-Message-State: AJcUukdKjGgr0lKlE/L4LWYNWamxRFCajWIYkTlHdJVrG8dhQ5iumAXN
        rx6IvBpXNIMFHylhyx8/ZV9bhzhfCfXlNXkxwgY=
X-Google-Smtp-Source: ALg8bN7Yjl89uwnRpSi+mOG7IgPIZxsVPXVWWi2jiO4eNfOUjcv4T+eV7IY5uFQ/DBcHD6fWM+MsXaSRjAwI54GCmMc=
X-Received: by 2002:a0c:e5c1:: with SMTP id u1mr24611566qvm.113.1547479874070;
 Mon, 14 Jan 2019 07:31:14 -0800 (PST)
MIME-Version: 1.0
References: <1546157106.3213.3.camel@intel.com>
In-Reply-To: <1546157106.3213.3.camel@intel.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 14 Jan 2019 10:31:03 -0500
X-Gmail-Original-Message-ID: <CA+5PVA55Pm_2K8GmA6jQT06BKZQCtmQ2G9J52gHHGTDZhoOyiw@mail.gmail.com>
Message-ID: <CA+5PVA55Pm_2K8GmA6jQT06BKZQCtmQ2G9J52gHHGTDZhoOyiw@mail.gmail.com>
Subject: Re: pull request: iwlwifi firmware updates 2018-12-30
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Dec 30, 2018 at 3:07 AM Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
> Hi,
>
> This contains a fix for:
> https://bugzilla.kernel.org/show_bug.cgi?id=202085
>
> Please pull.
>
>
> Thanks!
>
> The following changes since commit 0f22c8527439eaaf5c3fcf87b31c89445b6fa84d:
>
>   Revert "amdgpu: update vega10 fw for 18.50 release" (2018-12-18 15:38:53 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2018-12-30
>
> for you to fetch changes up to b727739187f05e16e0b84da29615f165e102a2f6:
>
>   iwlwifi: update firmwares for 9000 series (2018-12-30 08:38:01 +0200)
>
> ----------------------------------------------------------------
> updates for -43.ucode for 9260 and 9000
>
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update firmwares for 9000 series
>
>  WHENCE                            |   4 ++--
>  iwlwifi-9000-pu-b0-jf-b0-43.ucode | Bin 2543532 -> 2543536 bytes
>  iwlwifi-9260-th-b0-jf-b0-43.ucode | Bin 2558172 -> 2558176 bytes
>  3 files changed, 2 insertions(+), 2 deletions(-)

Pulled and pushed out.

josh

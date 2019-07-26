Return-Path: <SRS0=cxAL=VX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAB1C7618B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 11:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FCC3229F3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 11:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564140566;
	bh=z8l2D5aAB05N2YPjF7KzXhofQD0PYOa896GbzRFkPl0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XyxLL6LJmKxjsDsHUwDVQVQ3LwVT7eb0zlsExkePY0rJwx9VBPMKJUUkBqFSupJjU
	 x8vdjSUe5ezwczqkShJzQHnvkc4iumNv0KyZcSszFyVI2bxLkj3W/Qsk7vbvUkkyk3
	 75cK/72pLUgBCLzlvSRhg7HAUEJ+MTXsbVESN+tA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfGZL3Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jul 2019 07:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfGZL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jul 2019 07:29:25 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584D6229F3
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2019 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564140564;
        bh=z8l2D5aAB05N2YPjF7KzXhofQD0PYOa896GbzRFkPl0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R3cW1E7qm0mwVzDJSCmzFflghs+JCzjtp2Q2dA8VijsoWPPmI9tfUWnbu0Ein/gDV
         cp/nFguVo0oKZs91m2DbR2n415Iwisgj71hm4KCqvcX8eEQyNk80XsvSGjWFjy6iwQ
         GkJTVErmkF/jrCyWF7GKDKJRpth8lCy4Z2aO4CjA=
Received: by mail-qt1-f169.google.com with SMTP id d23so52246976qto.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2019 04:29:24 -0700 (PDT)
X-Gm-Message-State: APjAAAUIxcmWFC31xoh4Z8ZcrN8FR4f+EdpkJNioJ+r14ItFU/alkRIy
        yCdZuOomIZcHyohpZqpvZ39lMa4dQMiikgpW2MI=
X-Google-Smtp-Source: APXvYqwDzO8JFQAnH2i6oZsLhTR757JyxUITsWr2pvDF0zepDxcTDvi4aJnCbPYjZR0wKF4ny3aFfoO3d6TsyJrT7tE=
X-Received: by 2002:ac8:1410:: with SMTP id k16mr64116002qtj.335.1564140563518;
 Fri, 26 Jul 2019 04:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <b8246cb77dfc2d1344cd194682001a11a01dbf3a.camel@coelho.fi>
In-Reply-To: <b8246cb77dfc2d1344cd194682001a11a01dbf3a.camel@coelho.fi>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Fri, 26 Jul 2019 07:29:11 -0400
X-Gmail-Original-Message-ID: <CA+5PVA5oFEehqOzV=4oUqWeDf1JbKgjUUUrUFuxfQ8rkzNbSjQ@mail.gmail.com>
Message-ID: <CA+5PVA5oFEehqOzV=4oUqWeDf1JbKgjUUUrUFuxfQ8rkzNbSjQ@mail.gmail.com>
Subject: Re: pull request: iwlwifi firmware updates 2019-07-20
To:     Luca Coelho <luca@coelho.fi>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>, dor.shaish@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jul 20, 2019 at 4:03 AM Luca Coelho <luca@coelho.fi> wrote:
>
> Hi,
>
> This contains some updated firmwares for all our currently maintained
> FW binaries.
>
> Please pull or let me know if there are any issues.
>
> --
> Cheers,
> Luca.
>
>
> The following changes since commit bf13a71b18af229b4c900b321ef1f8443028ded8:
>
>   Merge branch 'guc_v33' of git://anongit.freedesktop.org/drm/drm-firmware (2019-07-17 09:05:52 -0400)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2019-07-20
>
> for you to fetch changes up to cd6cb7bc50aa77d531c4417ffe1237510b71c73e:
>
>   iwlwifi: update -48 FWs for Qu and cc (2019-07-20 10:58:24 +0300)
>
> ----------------------------------------------------------------
> iwlwifi: update a bunch of FW binaries
>
> ----------------------------------------------------------------
> Luca Coelho (2):
>       iwlwifi: update FWs for 3168, 7265D, 9000, 9260, 8000, 8265 and cc
>       iwlwifi: update -48 FWs for Qu and cc
>
>  iwlwifi-3168-29.ucode             | Bin 1036276 -> 1036300 bytes
>  iwlwifi-7265D-29.ucode            | Bin 1036432 -> 1036668 bytes
>  iwlwifi-8000C-36.ucode            | Bin 2400700 -> 2401356 bytes
>  iwlwifi-8265-36.ucode             | Bin 2414296 -> 2414592 bytes
>  iwlwifi-9000-pu-b0-jf-b0-46.ucode | Bin 1460788 -> 1467952 bytes
>  iwlwifi-9260-th-b0-jf-b0-46.ucode | Bin 1462324 -> 1469012 bytes
>  iwlwifi-Qu-b0-hr-b0-48.ucode      | Bin 1106208 -> 1106204 bytes
>  iwlwifi-Qu-b0-jf-b0-48.ucode      | Bin 1053156 -> 1052772 bytes
>  iwlwifi-Qu-c0-hr-b0-48.ucode      | Bin 1106228 -> 1106224 bytes
>  iwlwifi-Qu-c0-jf-b0-48.ucode      | Bin 1053176 -> 1052792 bytes
>  iwlwifi-QuZ-a0-hr-b0-48.ucode     | Bin 1105648 -> 1105644 bytes
>  iwlwifi-QuZ-a0-jf-b0-48.ucode     | Bin 1052968 -> 1052584 bytes
>  iwlwifi-cc-a0-46.ucode            | Bin 1044072 -> 1044452 bytes
>  iwlwifi-cc-a0-48.ucode            | Bin 1096684 -> 1096680 bytes
>  14 files changed, 0 insertions(+), 0 deletions(-)

Pulled and pushed out.

josh

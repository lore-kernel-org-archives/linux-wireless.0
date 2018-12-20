Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA80C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2984620815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:15:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IIrG3xI8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l67vUcwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbeLTHP0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:15:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeLTHPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 02:15:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 71BA8601C3; Thu, 20 Dec 2018 07:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545290125;
        bh=yjAqpa4xmeD2T3IJl4Gm8+xTn1QMBkQHlA7m1EAefcs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IIrG3xI8PVOW51ZCCiHdFohnTt4sXh+nQF3WtRMweX5Cvvd9NEjKoc9/Ht4KyCACz
         pqs6ymyFXTztyNBld8CtLVap95FBiPc2rremXQ3D0IxWWlCddTd+gf3/i9Id3nW0vB
         FRSTg6s428VVO/u3DD6aDdBL5HPE34if1BiLflv4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 711376074E;
        Thu, 20 Dec 2018 07:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545290124;
        bh=yjAqpa4xmeD2T3IJl4Gm8+xTn1QMBkQHlA7m1EAefcs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l67vUcwNSRpU/iVWyjl1UzbDg8+/QfqZkCShtEqxNYhRJQG8VjwU8ThD24D6kjJ1D
         F38z0OzMlmxcSsRzu8ticR+c1z48qyYtZ1b5xv5rgiAf1VsI4RcfItvuLciD6DU3sn
         L7/sVK0D4C2mSfGrAM1kaTSMli/KX19Z6wNTjCY0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 711376074E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-12-17
References: <39a3a7b5a34332c62468771c57c06a2c6e40b7ab.camel@coelho.fi>
Date:   Thu, 20 Dec 2018 09:15:21 +0200
In-Reply-To: <39a3a7b5a34332c62468771c57c06a2c6e40b7ab.camel@coelho.fi> (Luca
        Coelho's message of "Mon, 17 Dec 2018 23:21:24 -0200")
Message-ID: <877eg4vfcm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the fourht batch of patches intended for v4.21.  This includes
> only the last patchset I sent.  Usual development work.  More details
> about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 30ed3c6c0922a1f67c3409b9e81087442614db7b:
>
>   Merge tag 'iwlwifi-next-for-kalle-2018-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-12-14 16:58:00 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-12-17
>
> for you to fetch changes up to 04a70797e208337775c6a1905699e4970ed17f8b:
>
>   iwlwifi: bump the API version to 43 for 9000 and 22000 (2018-12-17 23:07:30 -0200)
>
> ----------------------------------------------------------------
> Fourth batch of iwlwifi patches intended for v4.21
>
> * Support for FW version 43 for 9000 and 22000 series;
> * A couple of janitorial fixes from the community;
> * More fixes in the 802.11ax code;
> * Other cleanups and small fixes;
>
> ----------------------------------------------------------------

Applied, thanks. I manually applied these as I had to rebase the patches
to remove the stray "BUGFIX" from the patch title. So the commit ids
have changed etc, I hope that doesn't break anything on your side.

-- 
Kalle Valo

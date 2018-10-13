Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44064C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 11:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E399B20895
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 11:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CFV4WpaV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CFV4WpaV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E399B20895
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbeJMTYn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 15:24:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbeJMTYn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 15:24:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C57F160452; Sat, 13 Oct 2018 11:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431273;
        bh=AqjzZZefc150ATsn2JwsO8jquArOpUceMsWiKagMzdg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CFV4WpaVUc4i//ztIbeEG8XZdnvZ+FzAK1tcRbyOXltOzELkGYx6PYjcBVNKR+utC
         5tqhr7VbtmSy4wFmuNwYRiR+/0VrysYrg8H7wP00m29dD69YIxdeugOZbcHnm99baE
         2l/GG/YO4nC4FaAXes4Oubd7sf95ypUdHqoy3WC0=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FEDA60558;
        Sat, 13 Oct 2018 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431273;
        bh=AqjzZZefc150ATsn2JwsO8jquArOpUceMsWiKagMzdg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CFV4WpaVUc4i//ztIbeEG8XZdnvZ+FzAK1tcRbyOXltOzELkGYx6PYjcBVNKR+utC
         5tqhr7VbtmSy4wFmuNwYRiR+/0VrysYrg8H7wP00m29dD69YIxdeugOZbcHnm99baE
         2l/GG/YO4nC4FaAXes4Oubd7sf95ypUdHqoy3WC0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FEDA60558
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-10-12
References: <f39924d6bbc4621137cf70abe4bbfac0e5949f32.camel@coelho.fi>
Date:   Sat, 13 Oct 2018 14:47:49 +0300
In-Reply-To: <f39924d6bbc4621137cf70abe4bbfac0e5949f32.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 12 Oct 2018 11:40:40 +0300")
Message-ID: <87tvlq1316.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> This is the fourth batch of patches intended for v4.20.  This includes
> only the last patchset I sent.  Usual development work, mostly queue
> handling cleanups.  More details about the contents in the tag
> description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit abf1a08ff3237a27188ff8cc2904f2cea893af55:
>
>   net: vhost: remove bad code line (2018-10-07 21:31:32 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-10-12
>
> for you to fetch changes up to 724fe7710ac5f4289886b90060ed67e3a4bdd584:
>
>   iwlwifi: mvm: kill INACTIVE queue state (2018-10-08 10:49:22 +0300)
>
> ----------------------------------------------------------------
> Fourth set of iwlwifi patches intended for 4.20
>
> * Support for a new scan type;
> * Clean-up in the queue handling code;
> * A few bug fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo

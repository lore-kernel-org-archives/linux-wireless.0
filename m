Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC62C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2851221900
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BMnnvMb3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YOBNVMbB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405956AbfBOKyJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:54:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405807AbfBOKyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:54:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 752A7608C6; Fri, 15 Feb 2019 10:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550228048;
        bh=tWrlyKdu0eIgK6D6megLq2TalL2nc7PWqFP5py/GkRI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BMnnvMb30RUK+aci65p/J6h5snq7jHZuSqJqvnbYlbthgZVNOIECC8ZC3c+8vcSS/
         vZL8pAbPAvXOjRQceb4LyWnzoVVpUMBuUSGYxawlhfiWgYDP7nEA/A56hm+NQB1z7M
         dFDKoomIIosCFHUDxIcqhwr26v8O3yNa8lruYvnE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D804E6053D;
        Fri, 15 Feb 2019 10:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550228047;
        bh=tWrlyKdu0eIgK6D6megLq2TalL2nc7PWqFP5py/GkRI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YOBNVMbBfCfFT495/nmV5LgqeBqRnbzvlXRiGTSxGMMynIJZx5rJqF1tOmvzXBJyQ
         JpuXGsX5CX1G3Isb12/wkzmdLseOrWLUzuRpi+2NwYZLG2JeIBND0X4MgQPEkcLWCX
         aYAxsINmfcwu/rmIcfzfxD63j8WryAdlCyllD+lc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D804E6053D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: [PATCH 0/8] rtlwifi: Remove CamelCase variables from all drivers
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
Date:   Fri, 15 Feb 2019 12:54:04 +0200
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Thu, 14 Feb 2019 16:36:36 -0600")
Message-ID: <87wom1xqyb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> This set of patches fix all instances of CamelCase for all the drivers.
> When the symbol refers to a macro, it is converted to upper case. If a
> variable or a function, then it is converted to lower case.
>
> As noted in the comments, some of the other checkpatch exceptions are
> addressed.

I wish you had separated the camel case fixes from other cleanups, and
otherwise tried to simplify the patches, now you made the patchset
painful to review as all the changes are mixed and the size of patches
is just too large. Remember that the rule of thumb is one logical change
per patch. Of course that's not a hard rule, and can be ignored with
small and trivial patches, but most of the patches here are not small.

No need to resend because of this but please take care with the size of
patches and patchsets in the future.

-- 
Kalle Valo

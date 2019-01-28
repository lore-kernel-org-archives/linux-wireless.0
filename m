Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058D0C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED2B214DA
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UuNqWS70";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nHlhN1E9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfA1UIA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:08:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfA1UH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 15:07:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 85AE96098C; Mon, 28 Jan 2019 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548706078;
        bh=Nt6zQEE3DaCHpr0gzJJK2WlEGB3KeHtTR+2jiAikqc0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UuNqWS70rdqE8tW44DOCYwbPPqLTXDLV9jaBhcid+pwFPVklmi49rNqJt/Zi/mupD
         gNzcFOsZhhBSSvUi0E2w4PnCEcmMzpaOnMEDs8lEYlNlLSou5CWjokTRA6m5vP1gEB
         WVW3usuCoYKK/5Rjk0mohpyZOVy6Wws8h186ZVQw=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10FC6601CF;
        Mon, 28 Jan 2019 20:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548706077;
        bh=Nt6zQEE3DaCHpr0gzJJK2WlEGB3KeHtTR+2jiAikqc0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nHlhN1E9vRYyBzMQ+Uii8i0/JGB8weo7tj3YR9mTEX9Ri+ZGPM71YiBdAtEsePtrc
         qdpZyuaUPKs7orVdUgBBFQzH78SptOwl/MhAwRG1VBP2TEfWqQJV99iCBjN+VL5NSC
         eVwsBUUOC+fFKjkTDajNHOzjWxPubu0BhliB/olY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10FC6601CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
        <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
Date:   Mon, 28 Jan 2019 22:07:52 +0200
In-Reply-To: <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Sun, 27 Jan 2019 12:15:49 +0100")
Message-ID: <87tvhstujr.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Report correct eeprom per channel power value.
> Fix chan_vs_power map in mt76x0_get_power_info routine
>
> Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

So what's the actual bug this fixes? The commit log is not really clear
on that. Wondering because you marked this for wireless-drivers.

-- 
Kalle Valo

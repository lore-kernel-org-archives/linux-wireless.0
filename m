Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81F2C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59AE2080D
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ONBJXRzL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ONBJXRzL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbeLSMjg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 07:39:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbeLSMjg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 07:39:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBA5C61BC0; Wed, 19 Dec 2018 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545223175;
        bh=/uxtDHIu4YWyBNsxet4gD+zRhvKjOsBW/oY3bQGDQN8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ONBJXRzLZIXPc3S8k8qn+yMw8C6AR9vpoRn650Xl0QvH4SlPaQaf40H841ppo13iy
         SjVp6v64FXMvsQbI16fkBMJRa6x93MQU84jECzS9+CUSWhptjyJLfIbM15sdMdWeC8
         HwCMn4lJFb0dcqHF+ZrgpqWagfe7n2epSLKK4u3s=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36B8361BB3;
        Wed, 19 Dec 2018 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545223175;
        bh=/uxtDHIu4YWyBNsxet4gD+zRhvKjOsBW/oY3bQGDQN8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ONBJXRzLZIXPc3S8k8qn+yMw8C6AR9vpoRn650Xl0QvH4SlPaQaf40H841ppo13iy
         SjVp6v64FXMvsQbI16fkBMJRa6x93MQU84jECzS9+CUSWhptjyJLfIbM15sdMdWeC8
         HwCMn4lJFb0dcqHF+ZrgpqWagfe7n2epSLKK4u3s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36B8361BB3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, sara.sharon@intel.com,
        sfr@canb.auug.org.au,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Subject: Re: [PATCH v2] iwlwifi: dbg_ini: fix bad ini tlv parsing
References: <20181219092922.8021-1-emmanuel.grumbach@intel.com>
        <20181219093619.9867-1-emmanuel.grumbach@intel.com>
Date:   Wed, 19 Dec 2018 14:39:31 +0200
In-Reply-To: <20181219093619.9867-1-emmanuel.grumbach@intel.com> (Emmanuel
        Grumbach's message of "Wed, 19 Dec 2018 11:36:19 +0200")
Message-ID: <87woo5vgfw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
>
> Add a break at the end of the ini tlv case.
> Fix both the internal and external tlv parsing.
>
> Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Thanks, I'll apply this directly to wireless-drivers-next.

-- 
Kalle Valo

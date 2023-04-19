Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F265C77B73
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Apr 2023 11:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjDSLhp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Apr 2023 07:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjDSLhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2023 07:37:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBC155AD
        for <linux-wireless@vger.kernel.org>; Wed, 19 Apr 2023 04:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A24CA62C54
        for <linux-wireless@vger.kernel.org>; Wed, 19 Apr 2023 11:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE57EC433D2;
        Wed, 19 Apr 2023 11:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681904260;
        bh=JP788VccofvV99xI8Q+UF9R//0YhY/qQOWlGLhFUZGU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N2q4X3ZhPP+FWmWQNi7V+GuX1FVwNBrpGAGNlvOUASj+tRBZ5xTWkR79NQ6eNUL51
         hUCP77EKhR9EJ2zL7wl+tpDkH76Tfmbjg7ofj7Wj9sMhdsPd5E0fpEEJw78KymMTbt
         3D7/Z00yANCM+PxVInlO/htK0D2okeO82WCwXgP5Om6QFTDLiEotSEVkQ37pLNZcWb
         +uRji8PicHr/uQmGoOKewu7egsoBkgh+RoYDqKS8EcV/dhE40oo00whT4ZQ9QAeetT
         liowd2Cj2D0fUn0ZgpVp8+zakCMEAU6OshF1SKMWjCqVAN2lLiTEBN9vp2ocVUY414
         8l/ZjutNy3EWg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Gilad Itzkovitch <gilad.itzkovitch@morsemicro.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        quic_jjohnson@quicinc.com,
        Kieran Frewen <kieran.frewen@morsemicro.com>
Subject: Re: [PATCH v5 2/2] wifi: mac80211: S1G beacon/short beacon support
References: <20230417012151.2512303-1-gilad.itzkovitch@virscient.com>
        <20230417012151.2512303-2-gilad.itzkovitch@virscient.com>
Date:   Wed, 19 Apr 2023 14:37:36 +0300
In-Reply-To: <20230417012151.2512303-2-gilad.itzkovitch@virscient.com> (Gilad
        Itzkovitch's message of "Mon, 17 Apr 2023 13:21:51 +1200")
Message-ID: <87pm80qf0f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Gilad Itzkovitch <gilad.itzkovitch@morsemicro.com> writes:

> From: Kieran Frewen <kieran.frewen@morsemicro.com>
>
> With the kernel able to send both short and long S1G beacons, include
> the ability for setting the short beacon period. If configured, use
> the S1G short beacon format. The S1G short beacon format includes a
> limited set of information elements. It also adds the support for
> distinguish short beacon head and tail.
>
> Signed-off-by: Kieran Frewen <kieran.frewen@morsemicro.com>
> Co-developed-by: Gilad Itzkovitch <gilad.itzkovitch@morsemicro.com>
> Signed-off-by: Gilad Itzkovitch <gilad.itzkovitch@morsemicro.com>
>
> v4:
>  - squash mac80211 commits together
>  - address hitting short head/tail code path in nl80211.c
>  - update code style
> ---

Same here as in patch 1.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792F8C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB2420835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SBK39AIU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h7LYKnwa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EB2420835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbeJMRX2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 13:23:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbeJMRX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 13:23:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 347E160600; Sat, 13 Oct 2018 09:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539424019;
        bh=01iKl2KKMOslEhQi+7S6Mxs2tX1AQpKxYydU1OB8qBs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SBK39AIUrsg5xo/GbqtHdw9bz7EQSfGcopWREIEKJfL6t0FuENHPxav8N5C2Qss2O
         bUnCqmKfIN33W28TF5p4n4uFJDrKIO+7wBfT++bj42kaBt4kN6khxdppKc5Ejf5ub4
         nJ58VOW6sYqPOw1rWWNtEtV4jc+TnLQgGovZkuhE=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8B7CE60600;
        Sat, 13 Oct 2018 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539424018;
        bh=01iKl2KKMOslEhQi+7S6Mxs2tX1AQpKxYydU1OB8qBs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h7LYKnwakD6xqwYhqSYCNXyrynoWcxDUCK527Paa8W9DpIDeMDAc/Uslqt9DYhKLW
         BP2alpmp+AQX/L175D8cgHXx1yXc8a4qiCNKkiHya5040hcbZWvtrnZZuPOs1DPjCS
         y/JX/eYTvspyfxKdRdRYrDvEEqSpXDDkQ0U2bQHA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B7CE60600
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
        <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
Date:   Sat, 13 Oct 2018 12:46:54 +0300
In-Reply-To: <1539334591-9965-5-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Fri, 12 Oct 2018 10:56:27 +0200")
Message-ID: <8736taqiuo.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> There is duplicated 'if (rt2x00_rt(rt2x00dev, RT6352))' entry that
> causes we do not perform register initialization for RT6352 (MT7620
> SOCs) in correct branch. Fix this and disable registers initialization
> that is specific to particular MT7620 revision.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

[...]

> @@ -5466,6 +5465,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x000C0408);
> +		/* TODO add chip version support and init registers
> +		 * according to the version.
> +		 */
> +#if 0
>  		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
>  		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
>  		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
> @@ -5480,6 +5483,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  		reg = rt2800_register_read(rt2x00dev, TX_ALC_CFG_1);
>  		rt2x00_set_field32(&reg, TX_ALC_CFG_1_ROS_BUSY_EN, 0);
>  		rt2800_register_write(rt2x00dev, TX_ALC_CFG_1, reg);
> +#endif

No '#if 0', please. If the code is not needed you can remove it, it's
available from git history anyway if it's needed later.

-- 
Kalle Valo

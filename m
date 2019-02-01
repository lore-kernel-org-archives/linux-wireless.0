Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCC5C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE65218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c5WLLZ4L";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8G6q9ih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfBAMFg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:05:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfBAMFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:05:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27DF4608C6; Fri,  1 Feb 2019 12:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022735;
        bh=WU84Bf+HB+2B7WNjAdueOcuOKO2uF44KmdH60izAAaw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=c5WLLZ4LTzMK56wtl1lCP9poGjBjdTxj6dzytz6mwAtYR6MCaFR2haKtrwy/iJYGk
         JFMV0gW/KwK/h0CycMquy+hQ1O0mViU6SGoa4HrMJUaMovAtdMERZHEstLYeG8mlMy
         zbk3KPV/qYgLYoLcWvmM7maWa7gcx78EK+vz55Cc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E49716030D;
        Fri,  1 Feb 2019 12:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022733;
        bh=WU84Bf+HB+2B7WNjAdueOcuOKO2uF44KmdH60izAAaw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=g8G6q9ihqu0466Rm2M/f72j/XWXMafqpfiuxi3ZSVLDtu898d+HuJfGO/d77pDl9l
         xXYQQ2jVR4QsTgVwIkz7HgVJm44n0ca5V23gEYi2QdiCP7dkMtAbBasQT3+q38N9eF
         bKYyZNamWF0jWUOPIK00JIUUtgf2lR66Qn/tHc+c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E49716030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] rt2x00: reduce tx power to nominal level on RT6352
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
References: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
To:     =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, hauke@hauke-m.de, nbd@nbd.name,
        john@phrozen.org, sgruszka@redhat.com, daniel@makrotopia.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201120535.27DF4608C6@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:05:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tomislav Požega wrote:

> Current implementation of RT6352 support provides too high tx power
> at least on iPA/eLNA devices. Reduce amplification of variable gain
> amplifier by 6dB to match board target power of 17dBm.
> Transmited signal strength with this patch is similar to that of
> stock firmware or pandorabox firmware. Throughput measured with iperf
> improves. Device tested: Xiaomi Miwifi Mini.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

c2e28ef7711f rt2x00: reduce tx power to nominal level on RT6352

-- 
https://patchwork.kernel.org/patch/10743705/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23D8C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B530D2075C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YyUjJNL/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iKWLrfuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfBHP1O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:27:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60714 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfBHP1N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:27:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA8CF60F36; Fri,  8 Feb 2019 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639633;
        bh=aEFrqbST/pVQx+o8YJCpDbuyoM7TrGB9GW6SD6wRvuk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YyUjJNL/uZo2xZlZN1y6DBKx+dJ2ycq5f9tqNKlXs5D8Hn7Pspq3V4Ld9JlB04OyJ
         tdu8tvGCtZrGSCz/n35Db0p4fCtSgKLlHmr8QIaZCF3UUvE7UVZwiLcbYTnKuQsVkK
         GpZWHJs4ej+KqM04nap8osjW2DX0I2ByLQLr5sB8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CEBEB60E5B;
        Fri,  8 Feb 2019 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639631;
        bh=aEFrqbST/pVQx+o8YJCpDbuyoM7TrGB9GW6SD6wRvuk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=iKWLrfuvc+A1IxEvoXFyv5oUqTzVZOnV5E0VsTYqY7LR4E9Vx9yWjhkQPRETz5ZQW
         A2HbxfqbDHzF/OcjrjH5GPrGYnRgRCzzk1c6g46hZOEOM1Wnv1iUnjJsqC5WfTnwt+
         +RhK14bBcUJDF4DJVBUPFUSb2JxsXZ/pgJ1DUndw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CEBEB60E5B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: fix typos
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190129174717.30566-1-mcroce@redhat.com>
References: <20190129174717.30566-1-mcroce@redhat.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208152712.EA8CF60F36@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:27:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Matteo Croce <mcroce@redhat.com> wrote:

> Fix spelling mistakes in brcmfmac: "lenght" -> "length".
> The typos are also in the special comment blocks which
> translates to documentation.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

2359dd09f981 brcmfmac: fix typos

-- 
https://patchwork.kernel.org/patch/10786663/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


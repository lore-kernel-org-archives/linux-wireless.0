Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FD5C67839
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 13:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 993ED21473
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544792572;
	bh=rH5kj1KZSzRWR9Q4b/nOikxYpxDavE9zwvfrpfbErtk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=l7IT1RFdAwHi6s7z19QDmMhjanMMhCnf+m7K/zXqyNwaQquDWtrXmyeKBRcDIE9JH
	 Gy0M6TtIi3AJkJr5HCLxqfX9q1405U3VUiL2xhTaObourrhstJqPNVf6tZLneDuVA9
	 qznHz0MRAiyqRMzF3BB3DCq3dL+tQNUN8Eh+ptQI=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 993ED21473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbeLNNCv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 08:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbeLNNCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 08:02:51 -0500
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F2F208E7
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2018 13:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544792571;
        bh=rH5kj1KZSzRWR9Q4b/nOikxYpxDavE9zwvfrpfbErtk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B+0j8J3HSIa38oSIEMJKIf5reoxhvCJLbucSCCCAVu9oOsc0Rh68gXjYEJbOj1Xx4
         NdMuauYeJR7aEC612J6+3UZNQEGpQBqUtf0yO9z7XEW1SJp4U35KdWurcdS6nxLcg7
         MlarQmzDCtY7mGTjD/IjJO3vDhamnGugVOiJPCig=
Received: by mail-qk1-f174.google.com with SMTP id y78so3135424qka.12
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2018 05:02:50 -0800 (PST)
X-Gm-Message-State: AA+aEWb6ZVD3bQ9P7nmB7G+iOOyCB9N0hY8hHUUwv6nLBrHA86mv+Mdw
        G1SG0aQCSmVQOuv06SIq6YWgX3qxmw8jtDCOKqc=
X-Google-Smtp-Source: AFSGD/XPCV4xcasPjMUuuEFTWE5BfVODU+UcOase1wub/d2bFyb+GTQlLiGKD/4kjArTXguybagpSOplvPcmwFcXC84=
X-Received: by 2002:a37:5741:: with SMTP id l62mr2491297qkb.44.1544792570160;
 Fri, 14 Dec 2018 05:02:50 -0800 (PST)
MIME-Version: 1.0
References: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
In-Reply-To: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Fri, 14 Dec 2018 08:02:39 -0500
X-Gmail-Original-Message-ID: <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com>
Message-ID: <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com>
Subject: Re: [PATCH] brcm: provide new firmwares for BCM4366 chipset
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 7, 2018 at 3:45 PM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> These firmwares are for the BCM4366 3x3 802.11 ac chipsets, which also comprise of BCM4366E or BCM43664 devices. Signed-off-by: Arend van Spriel

This didn't add brcm/brcmfmac4366c-pcie.bin to WHENCE.  I'm assuming
it's under the same license as the rest of the brcmfmac files?  If so,
I can just amend the patch.

josh

Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED65FC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF652070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EHxz+8YH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bGWE6cc6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfAHQkx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:40:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHQkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:40:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F3EA060B62; Tue,  8 Jan 2019 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965652;
        bh=Z/iji3DS2+TioDqigJjr06w+s4yBBckOAuRtuCmA0+A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EHxz+8YHKkJhmMJo+1Mvp4No+QdZ3aP7aqYHXel8ei4JhDLuJUPrF3ywlvrwwdFwH
         trxxBUg7sfFku398+sZe9GINB3bhb4+D53CTItmuqIrO8zvlRnaHYXRNCcFP8KdX2g
         OCKlzBvwbY6q1rgqL2gBjnYV3BUokxnp6C4e+tPQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD4D660995;
        Tue,  8 Jan 2019 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965651;
        bh=Z/iji3DS2+TioDqigJjr06w+s4yBBckOAuRtuCmA0+A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bGWE6cc6RPiT1PF7RT5Et6VtFrzVccnw1T6e9kZ8U1a+9edQqfogJUyJ76ndRujBc
         1DH0DQhDGZIjSEQoP0vo16ox/pV417Q8sd3ziOrJYrCHD64yppcO4uZMRAFdCCccGc
         jvE5r0Yq6OyQVByAF3a+pO+2mZWb1yqYbSpEN65E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD4D660995
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?= 
        <rafal@milecki.pl>, linux-wireless@vger.kernel.org,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
        <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
Date:   Tue, 08 Jan 2019 18:40:46 +0200
In-Reply-To: <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
        (Arend Van Spriel's message of "Mon, 24 Dec 2018 19:24:22 +0100")
Message-ID: <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> Response using Gmail on phone

Unfortunately it had HTML and not sure if it made it to the list, so
copying your response in full below just in case. Russell, does the
commit below fix your problem?

861cb5eb467f brcmfmac: Fix access point mode

> Op ma 24 dec. 2018 12:09 schreef Russell King - ARM Linux
> <linux@armlinux.org.uk:
>
>     Hi,
>     
>     Commit 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
>     appears to have broken hostapd 2.4, thereby causing a user visible
>     regression when upgrading across the 4.18 boundary (e.g. 4.13 to
>     4.19).
>     
>     The presence of this flag causes nl80211 to add an additional
>     attribute to the netlink wiphy reply:
>     
>     if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
>     nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
>     rdev->wiphy.ap_sme_capa))
>     goto nla_put_failure;
>     
>     which is then parsed by hostapd using a presence/absence test for
>     this property (the value of the property is meaningless):
>     
>     nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
>     genlmsg_attrlen(gnlh, 0), NULL);
>     ...
>     if (tb[NL80211_ATTR_DEVICE_AP_SME])
>     info->device_ap_sme = 1;
>     
>     This causes hostapd to then attempt to subscribe to management
>     frames (via nl80211_mgmt_subscribe_ap_dev_sme()):
>     
>     if (nl80211_register_frame(bss, bss->nl_mgmt,
>     (WLAN_FC_TYPE_MGMT << 2) |
>     (WLAN_FC_STYPE_ACTION << 4),
>     NULL, 0) < 0)
>     
>     and brcmfmac does not support passing any management frames in AP
>     mode (brcmf_txrx_stypes[NL80211_IFTYPE_AP] is empty). That causes
>     nl80211_register_frame() to fail, and hostapd fails to initialise.
>     
>     Checking the hostapd versions (including up to 2.7) shows that
>     nothing has changed, so this change has broken the ability for
>     hostapd to be used with brcmfmac - thereby causing a user-visible
>     regression.
>     
>     Can this commit be reverted to fix this regression please?
>     
>
> A patch has already been applied [1] to wireless-drivers-next repo.
>
> Regards,
> Arend
>
> [1] https://patchwork.kernel.org/patch/10726965/

-- 
Kalle Valo

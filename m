Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C66C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D4C21900
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rnVenRON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406930AbfBNMZN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:25:13 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:42124 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392585AbfBNMZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:25:13 -0500
Received: by mail-lj1-f178.google.com with SMTP id l7-v6so5044797ljg.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 04:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bn7WSKsncraqiSOmjmMQeBIU0NToZDDgaFH9+konIoU=;
        b=rnVenRONx4AlvkIxY79Am6ByCwapqHAJWxX/AZZAssynE8eKF66bxrp7LaLLvFnfpq
         TQce8tqU48MT8xMi0OpuSzrO2+aiUqh1psP8mECRcdPsWNn3pE4JWBbW43udbO/yr0u+
         8PmOEg4k7sbQyVlglsoS3pmbv158/p6XAPfOhjP6lua+ZG6BSqArD4k2vjCK8SBn/Rpk
         +DGbE7uRPclVZ/nfv0Bez/uv7DB/CRZL/ZyMs4puYM54DxLJYfKKGTStyykhzp5rg7ed
         9OGV3+PdP6P/dIWSizVxHGrVBSB6NhElVlZ82qgtWuICQhBTY2MZQ+8wNly+YyQNDFnd
         UnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bn7WSKsncraqiSOmjmMQeBIU0NToZDDgaFH9+konIoU=;
        b=lYoACGk0kgauNBwUWB6cbFrCuAPFhqo3lD/Zhe/s+vqnfhLjRDAH3SxcUCgksFKZgH
         6PEthvTOO/xDdN8yQ7OaXASkeQvheDiV3wgGdyNSl8++x6qAcwDMPjVbFrD7b8Ilyj+l
         uQHgb9toFIctJL5WgjajZS+lvOEkdl04DTXdq7KosbUq8uxbAT2Hi/AO+P9flxxP0bIo
         Y7RWM8MIRV8fw4oTGDNpDwmdu/v3Y8exvNUP+p068UsaoW9LNNWyiCnbzVXk7rq2dmBB
         R9Tx51O5QVa4iQrFyQ9m2YgXSTD9Z62+eS/4fENihecPMNDoRCVPzgSQEpxEPZGhNTh5
         Lkmw==
X-Gm-Message-State: AHQUAuYEj8Bp2cLVwvAPMqmhKB+tJj9TjtSu+fZUGALqHdkJOMoiLoeK
        NPXBzz8husdZGZm+ky1tutI=
X-Google-Smtp-Source: AHgI3IaAS3iqlvG2N3mqOor7gys8IrxM4rN9QaShCCxUDBW6Ji2BmqvPKxkT9SonFTWUpbL7Jn2S6w==
X-Received: by 2002:a2e:3319:: with SMTP id d25-v6mr2208007ljc.187.1550147110717;
        Thu, 14 Feb 2019 04:25:10 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id 8sm411768ljs.42.2019.02.14.04.25.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 04:25:10 -0800 (PST)
Subject: Re: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
To:     Aaron Blair <aaron@aaronpb.me>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
References: <20190212055731.gxy3e3uulztketbf@datkip>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <6f2061fe-b734-1bb4-6608-db8c3fcd1363@gmail.com>
Date:   Thu, 14 Feb 2019 13:25:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190212055731.gxy3e3uulztketbf@datkip>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12.02.2019 06:57, Aaron Blair wrote:
> [18990.872335] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO failed, -12
> [18990.872433] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring
> [18990.872439] brcmfmac: brcmf_cfg80211_get_tx_power: error (-12)

FullMAC firmware (the one running on card's ARM CPU) has crashed.


> Upon trying to rmmod && modload brcmfmac, I receive the oops dump included below, and am unable to continue using the wireless NIC until I reboot.

Interestingly I've experienced the same problem (for the first time)
last week. I started working on it but didn't achieve anything yet.

Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80092C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD3321872
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="apHfDTdO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfAYIv7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:51:59 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46020 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfAYIv7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 03:51:59 -0500
Received: by mail-ed1-f65.google.com with SMTP id d39so6734795edb.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 00:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Li4WzCt04m+YGz7RrLSrAgxZw1QAnE08VZM7cfNIWyE=;
        b=apHfDTdOH1SFS9zU2fo77MxRlUFF0NkU7Z4+4TBqAg6r7SKi3jo1FDOGHAFD4VW0RW
         86/rUBJQR+vSUcqPyRXELS41lsP6UGmD79ev7KjDGREq7hzPQloehgJsE/rIUsaA7/8j
         6FFaUQKQxalBX2/swXectPToYROf/h5ZcQLo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Li4WzCt04m+YGz7RrLSrAgxZw1QAnE08VZM7cfNIWyE=;
        b=nq6eOzTDeiN+UB+ggneCbBjed8ycv/z5AQSVKIabUorUmpFMympOlRVWuuww2zz7Eh
         bOixCqenBQFdVttR6/pPBFIqKlr+16PhVJYCXUEb0mr10dz12y0gZbzUYsIu8UDsmWgu
         4WNc1Z1bBYrb/GkBOjXyrh5AbqjpyygvD/2XlsVgt7O7C6r7RdTF8N8DEXwjgNzwVrtj
         mk1hOxXSIWFMFa2+htw1kJl5MCRTOQ9QhpM7MBuwkF0xEzZW9DlURg4Sj6y9RAxuHQFa
         l8vVx8qVY90+oJKdOId1nm2l++1IWgB9I+qyEgKVZaM2oGrJvoo9ScSfW7Mr052WouZB
         eKZw==
X-Gm-Message-State: AJcUukeAqd4+0WJkOoBfE84g6cXFETjqrPwKkyE2oGm4LkGFFYFYM1Z+
        qBMf0NzwjxPJGdTnXgep/RXESg==
X-Google-Smtp-Source: ALg8bN5FiK3NwmY03NwyQhePLpR2qw4qF7kwZfZzSu2ryJcxAKxe+uHMNmE7XtsCi41Gbqd4adaa0Q==
X-Received: by 2002:a17:906:e282:: with SMTP id gg2mr1093721ejb.84.1548406316573;
        Fri, 25 Jan 2019 00:51:56 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id h8sm11297498edb.95.2019.01.25.00.51.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:51:55 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: support monitor frames with hardware/ucode
 header
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190122110858.12993-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <66fcd804-73f7-ae58-53f5-537ec8cb2802@broadcom.com>
Date:   Fri, 25 Jan 2019 09:51:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122110858.12993-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/22/2019 12:08 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> The new FullMAC firmwares for 4366b1/4366c0 were supposed to provide
> monitor frames with radiotap header but it doesn't seem to be the case.

I was not aware that this was supposed to. I did not build a radiotap 
variant to keep it feature-wise similar to 4366b0 firmware.

> Testing the latest release resulted in discovering a new format being
> used. It seems (almost?) identical to the one known from ucode used in
> SoftMAC devices which is most likely the same codebase anyway.

I am a bit confused. How many formats are there? It is either ucode 
format or radiotap, right?

> While radiotap support was meant to be announced with the "rtap" fw
> capability string it seems no alternative was added for the hw/ucode
> format. It means each firmware requires a feature mapping quirk.

I thought we only needed a quirk for the firmware that provide radiotap 
but do not announce it. For the others we can assume ucode format if 
monitor mode is supported. Probably missing something.

Regards,
Arend

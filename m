Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD426C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E3E02070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qrxt1/8j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfAHRoF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:44:05 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38483 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfAHRoF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:44:05 -0500
Received: by mail-ot1-f66.google.com with SMTP id e12so4242839otl.5
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 09:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ec9BilHRmGJ8KO923HLAMByYnPF71t4zt8/7ytsFc98=;
        b=Qrxt1/8jqZQqygl6HqgTeqDV52Rnl8q9NLIljodHm/ieRlFb3UvHLJu4XfH2WuTsMX
         WjjZpX8mjTFNEF6GmMGIcw0rDKeKLsVAxksz3fj7vPDHrlotPPs1db+lx/iAV9kuZpFX
         hcko9oT/8jXz3xX/1BdzhgWGi9lVmlYT+ZG3bEMRwFMro3nfuE/9ZmC+m+GCfMK6eeYD
         pvcGJ5ZTF2cPtlTguQM5U7BRnwwKLDLURKEZMfIsRqKJmNUkiaG5XTP/GijalIXmDqgy
         Eeiu2D5DDonrUgRkYZbrm6NDqbED6T10tz6b4VvktqXDk0pEvUryJREEYce9rG7wG5CE
         SWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ec9BilHRmGJ8KO923HLAMByYnPF71t4zt8/7ytsFc98=;
        b=ZKgm9rnvSK1ji6FmvxTPQRMq1SM0ZRvkO03+Lbgs7I/Cz/MOIuv67uto6Vk2qCoFgl
         rjRVtBEuvOh+2buHiUtkpZhntOAN2TM8J+uXCg3Pb4FJpg2izzjYG/I3UgwW6VW1URZ0
         4ZupwRtoi88Zbfkuf121c0YCwyO0YriqxWVoTqHOfVlLClWUq6h6T8ivstFZdZPiIloW
         qgOjKlQY6ZjOhk1JBMLafziAVCRqlpFdwv50FxhpGDs6uajRQsNawNsG1bAAP2sZ0Au6
         cV35U5Do0/PbTlWTDPFv5lbflTfnxxIPjiuKYtAe4xO3+iy1hFo/5iRifYIHX4Pm4cpV
         T5OQ==
X-Gm-Message-State: AJcUukenY4SfyZ5xwXnlBur7BIdGq9khsWMdK/URBayvdRTcFbmVe+Tj
        P6U7AAx+OW9b7y8JiPRTMCY=
X-Google-Smtp-Source: ALg8bN749ulEJTnh+kQ9zbatuxdmkqBCctrIVLxHhqTqPK0gLDL733yU1KRSZAEOLGtWKb997TmGRA==
X-Received: by 2002:a9d:3426:: with SMTP id v35mr1939299otb.71.1546969444287;
        Tue, 08 Jan 2019 09:44:04 -0800 (PST)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id m207sm36697896oig.2.2019.01.08.09.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 09:44:03 -0800 (PST)
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>, Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
 <20190103154921.GA25015@w1.fi>
 <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
Date:   Tue, 8 Jan 2019 11:44:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

> However, there is more to it. When these offloads were introduced, we 
> discussed about having a PORT_AUTHORIZED event or not. It was decided 
> passing an attribute in CONNECT and ROAMED event would suffice and that 
> is what was implemented in brcmfmac. However, it seems time passed and 
> the need for an explicit PORT_AUTHORIZED was there (probably Denis 
> knows), which wpa_supplicant now supports thus ignoring the attribute in 
> the CONNECT and ROAMED events. The brcmfmac driver was not changed 
> accordingly. For this there are patches pending in linux-wireless which 
> are necessary to have a working connection.
> 

Coming in a bit late to this discussion, but it does raise a few points 
I wouldn't mind some clarification on:

- With commit 503c1fb98ba3, the kernel effectively changed the userspace 
API.  So I take it that breaking userspace APIs are OK sometimes? If so, 
I have lots of suggestions to make ;)

- Is RTNL LINK_MODE / OPER_STATE status being (supposed to be?) affected 
by the driver during a roam?  E.g. if we're in a 802.1X network with 
userspace authentication, and driver roamed requiring a new 802.1X auth, 
then in theory the RTNL mode needs to be brought back out of UP state...

- The new API leaves a lot to be desired in terms of race conditions. 
For example, how long should userspace wait for EAPoL-EAP packets to 
arrive (before triggering its own EAPoL-Start for example) if a 
CMD_ROAMED event comes?

- What happens if userspace does send an EAPoL-Start in the middle of an 
offloaded 4-way handshake?

Regards,
-Denis

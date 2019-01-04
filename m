Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BFFC43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 13:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 591B021871
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 13:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LGhVH9mz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbfADNXf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:23:35 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:37778 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfADNXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 08:23:35 -0500
Received: by mail-ed1-f43.google.com with SMTP id h15so31776555edb.4
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 05:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wOSooL4XbJE2sKiPIZxhCDRPLMM4jeAY5aQ54B75BM4=;
        b=LGhVH9mzz9Y+tttxlIqJCgzYkjG3PL8nz8wCZ6BM6DCTP2uN28TZH8rFJLNZf44B1w
         xCdyCm+tRkhPbIXkkCJDVzPWeOegsH6c6CjW0hpvPEIfAoOeQMZ/Xjrd/nB2lXUBRJTX
         cJgUNDabjWZUK6RMkIoxVXt3SNoQMZ27o3yyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wOSooL4XbJE2sKiPIZxhCDRPLMM4jeAY5aQ54B75BM4=;
        b=hrjedmR7u1FFenizWO3VjUZ0gBGZQU9hWYMzG5R3CbIPFIHUrfEDOht2wZebbRNdoF
         HgywWYonn2UluMdPqc2m7kSpTenoRp5ly02yoxSHiPG/yLxYmk7MrDQYvAuH6QT/p/ur
         KhbjoperIFXau6CtqDMbanIWdpG4xwTU4JddMqBlqqu+9F87/oPVnHl/XBlZiOCryV3N
         c41P5KvlzoT6BFHtLFWj1YM7lqHLfLJzZnSQx1Ei5z6wCr8uUTeYC4jEERpUaznZtEXn
         lMmpXu3Kl14QeVY5K0T7aan8g18B+D5uck5403uu2ZAic50BmSGSMp2z7URTmysvl4ei
         IpdA==
X-Gm-Message-State: AJcUukeZzNcQ1yfu0q4ddNQUr7vCN75E5fEdbBjq1b2XnXBDYdNmZKT8
        GP27Y5v/OlA90syziosXhh5s0xC0jJCjChafZdvT9HhF0Gh1SIL5t7poNAAP0KxJnGLOfMAHZXe
        bzkfn14wlGZ0d6PmAr7ghxaB3vEphbkeEi3cuSTjYB97asGt1h7YErrTQX5qf3Ytmb7LtP0roMZ
        uJx3kyz8iFJbXE2Q==
X-Google-Smtp-Source: ALg8bN50wSQXskip1I7hVNhCyoa4a4WQ+9PtKOmiW+WTEvg8b2gQNgtE0q4s5PjPc3zQcIFbmpH5Zg==
X-Received: by 2002:a50:b0a4:: with SMTP id j33mr41212040edd.267.1546608212172;
        Fri, 04 Jan 2019 05:23:32 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id v20-v6sm14621970ejr.46.2019.01.04.05.23.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 05:23:31 -0800 (PST)
Subject: Re: nl80211 related warning w/ 4-way handshake offload and failure to
 associate
To:     Eric Blau <eblau@eblau.com>, linux-wireless@vger.kernel.org
References: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d3a083b8-f78d-fcf2-d27a-879eeb77b625@broadcom.com>
Date:   Fri, 4 Jan 2019 14:23:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/3/2019 5:29 PM, Eric Blau wrote:
> There is an Arch Linux bug open on this with a bunch of details here:
> 
> https://bugs.archlinux.org/task/61119

The ArchLinux issue seems to be using broadcom-wl driver, while you have 
issue with brcmfmac. Just to clarify I can only support the brcmfmac driver.

Regards,
Arend

Return-Path: <SRS0=699K=WS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD96C3A5A1
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 22:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9AB205ED
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 22:50:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cantab.net header.i=@cantab.net header.b="fcZQ5zvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390762AbfHVWu4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:50:56 -0400
Received: from mta02.prd.rdg.aluminati.org ([94.76.243.215]:35314 "EHLO
        mta02.prd.rdg.aluminati.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389012AbfHVWu4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Aug 2019 18:50:56 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2019 18:50:55 EDT
Received: from mta02.prd.rdg.aluminati.org (localhost [127.0.0.1])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTP id 550E61FEF6
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2019 23:42:18 +0100 (BST)
Received: from localhost (localhost [127.0.0.1])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTP id 4C6BABB
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2019 23:42:18 +0100 (BST)
Authentication-Results: mta02.prd.rdg.aluminati.org (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=cantab.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cantab.net; h=
        content-transfer-encoding:content-language:mime-version
        :user-agent:date:date:message-id:from:from:in-reply-to
        :references:subject:subject:received:received; s=dkim; t=
        1566513737; bh=rW5DhwGy9dkDoEedIWAUDjv2U9JxW4v6EkSeu/KGfSQ=; b=f
        cZQ5zvhJWIlQIuoAIXTa9FSzpp2JQ2A5PhdE5q2pNhro/l11xuBivSQJU72JSUs2
        5Uqv4Ix7ejIxZBO2+ptmbVx+z7ZFjxrqkbuec9WhUKi3xpZoH6bFyOa3wocgxQ9c
        kyXQ3oD/6wrd0nrgJIrO5UvGOqQ7WYDaxkEGFwD/+6lxJmfr36E6ffZr+MoroxeQ
        nE6qML0xpxpd5lMzjf0n48Zd2UdIcEI0PvUsrbe0qFSlekxSSryFD4EmKOMZLjCy
        YtNZNFSlitwYB8p8kYRGVPvae1m21GyVRTzHvInVT5NR4mV1HHdG99g0Y6+tVjzs
        9u1lerqs2M1timgp3Q3Iw==
X-Quarantine-ID: <meNmWux9vZIu>
X-Virus-Scanned: Debian amavisd-new at mta02.prd.rdg.aluminati.org
Received: from mta.aluminati.local ([127.0.0.1])
        by localhost (mta02.prd.rdg.aluminati.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id meNmWux9vZIu for <linux-wireless@vger.kernel.org>;
        Thu, 22 Aug 2019 23:42:17 +0100 (BST)
Received: from [192.168.1.31] (78-58-236-126.static.zebra.lt [78.58.236.126])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTPSA id 4E7EB3E
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2019 23:42:16 +0100 (BST)
Subject: Re: [linuxwifi] Intel Centrino Ultimate N 6300 regression
To:     linux-wireless@vger.kernel.org
References: <CAG6aBkW09YFz4asHZkhWBUenBiT3dgb7iGXBCq8KkCM09QXjLg@mail.gmail.com>
In-Reply-To: <CAG6aBkW09YFz4asHZkhWBUenBiT3dgb7iGXBCq8KkCM09QXjLg@mail.gmail.com>
From:   =?UTF-8?Q?Antanas_Ur=c5=a1ulis?= <antanas@cantab.net>
Message-ID: <90e4da8a-10a6-2e2d-c3de-27f21e644f3e@cantab.net>
Date:   Thu, 22 Aug 2019 23:42:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I was investigating what appears to be the same issue on my T420 
Thinkpad and at least found a workaround (and perhaps a clue for where 
the bug could lie).

On 22/08/2019 01:12, Nigel Sollars wrote:
> Interesting to be sure,  so here are the versions of kernel and wpa_supplicant,
> 
> 5.2.9-200.fc30.x86_64
> wpa_supplicant-2.8-2.fc30.x86_64

Are you using NetworkManager by chance? I stumbled across a Red Hat bug 
report[0] involving 'CTRL-EVENT-SCAN-FAILED ret=-22' and the proprietary 
broadcom driver. A comment there[1] describes a workaround for their 
issue, by making NetworkManager not randomise the MAC address during 
access point scans.

Adopting that workaround also works for my Centrino Ultimate-N 6300 (rev 
3e). Create a config file /etc/NetworkManager/conf.d/iwl.conf with contents:

[device]
match-device=driver:iwlwifi
wifi.scan-rand-mac-address=no

Then restart NetworkManager. Alternatively, downgrading wpa_supplicant 
(to 2.7-r3 on Gentoo ~amd64) also works for me.

- Antanas

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1703745
[1] https://bugzilla.redhat.com/show_bug.cgi?id=1703745#c56

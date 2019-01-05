Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C64C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C6A2085A
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsFC952j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfAEQhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 11:37:05 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:47074 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfAEQhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 11:37:05 -0500
Received: by mail-oi1-f196.google.com with SMTP id x202so32735148oif.13;
        Sat, 05 Jan 2019 08:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D92SGyyRSguxIXcZZj9uJHPQLd5hAu1Vyym4KYBA5YU=;
        b=lsFC952ju3rpDdhtvHhNXx1VdehE3zFmTy41roVIFZpMIo0n/eJn8mIsfa8gu8koTu
         p5LhCjWQlZqZw9yRwQs/wgCuB5anyVOLVEcQWdczhegM/bjLZN9NGMPgl0ywuqUuczb/
         RmxUee26zsP8vq5I1Wr6HVFkE5JRs+p1IcdDqpTJQmh4I1rqngjem/FDbfBaZPTTPQrn
         xjvmhkW+/MeM2td1QIj/XlieGb7Ezi8foDb6//bVWug1+9KBYounNlyloipf5wxMeTIC
         v20Tc4vB3YnJez0vdEAUwG2rVvV60kGBsttveKXZA75DZ3jkkTjtQ/4aDMws92hmpKim
         GMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D92SGyyRSguxIXcZZj9uJHPQLd5hAu1Vyym4KYBA5YU=;
        b=d9WYFcE0W16zAMbrg9W/3U/wGatB/DpV3Lc8iQk2H6RdMVryXI/ZLcF8FVg4qciWi+
         diW1M9Bb1NqIkeoo+gONV7QQIpwhakTIBAM0dCECg7YDbeo9oHVghHNId4tnagV+kWyZ
         xYA9thpsLymz+ekic1EUj5G4pWmuJI5sqMBROdnhn+iD21+/PFw6E+7R25ldtBYkvlGf
         6LwFvSY2ClGEBY4LnUEN2mKOR4XTFcbr34yWNmZ9V19HphUqyXzxjmHe6DnD7Sh6k4Ld
         Ndp0gpvn9h56sFYjIdKhM6PinFlAvdfOCRoFdYRcWcE+3Baz2oLD50D3Gwvztwg0JSQ2
         OtzA==
X-Gm-Message-State: AJcUuke5kLeoBhcItCsyWCqOxmLpKgz820u6b+VRsZLvc2XxicFhdGYX
        8fnbBqZD57NIkJapsU8KCulPfDPM
X-Google-Smtp-Source: ALg8bN5wFCaiBad8Om4VpNMV2BdWvW66R+WbNlIjjlEeGD+wyyrTGN9hfl+6s5qd/zC7gaanubMZlw==
X-Received: by 2002:a05:6808:159:: with SMTP id h25mr3695594oie.285.1546706223219;
        Sat, 05 Jan 2019 08:37:03 -0800 (PST)
Received: from [192.168.1.102] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id c78sm45549170oig.30.2019.01.05.08.37.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jan 2019 08:37:02 -0800 (PST)
Subject: Re: [PATCH 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling out
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <DB7PR07MB5353320B147CD781B7993783E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <f6406c9c-d095-6c9b-55af-0b2fd05c06bb@lwfinger.net>
 <DB7PR07MB5353984E3E78E24150ED3187E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <7c1f25bc-dfc6-56e2-745c-4607f0f41159@lwfinger.net>
 <DB7PR07MB53539F1836CE716739F2409AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8a594059-fdeb-9abf-24a3-c44cb429fea3@lwfinger.net>
Date:   Sat, 5 Jan 2019 10:37:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <DB7PR07MB53539F1836CE716739F2409AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/5/19 10:30 AM, Bernd Edlinger wrote:
> On 1/5/19 5:13 PM, Larry Finger wrote:
>>> but this works:
>>>
>>> modprobe rtl8723ae debug_mask=0xFFFFFFFF debug_level=5 swlps=1 fwlps=0
>>
>> Yes, I think that is a better thing to do now. If and when Realtek finds a firmware bug, and when the new firmware is readily available, then there will not be a lot of code to reinstall.
>>
> 
> Okay, my assumption of how the firmware bug "works" is this:
> 
> Once the firmware enters power save mode, it will deliver exactly one (or maybe two)
> Rx interrupts. If one of those triggers the driver to leave the power save mode again,
> the firmware continues to work.
> If those are only beacons, they won't leave the power save mode.  Then the firmware
> will usually not recover.
> Since prior to commit 873ffe154ae0 ("rtlwifi: Fix logic error in enter/exit power-save mode")
> the power save mode was only activated when there _is_ busy traffic, the next
> packet did usually wake the firmware, rarely it did freeze however.
> Other things like changing the cck_packet_detection_threshold or refresh_rate_adaptive_mask
> can also kick the firmware back to life.
> 
> Hope this helps to track down the root cause of this bug.

As I know nothing of the firmware, that is outside my expertise, but that 
observation should be of great help to PK Shih, and his colleagues at Realtek.

Larry


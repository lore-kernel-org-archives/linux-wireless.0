Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA522ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 23:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712DF2075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 23:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/bL+xM1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 712DF2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbeJYHdf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 03:33:35 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:46043 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeJYHdf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 03:33:35 -0400
Received: by mail-qk1-f175.google.com with SMTP id m8-v6so4525127qka.12
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 16:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=YWiXQmBHUGHtpfW0A1FRblib1vkHZebP5zWOwP1oTJs=;
        b=Z/bL+xM1MbNrsmmuC2Dcxsv9dtWCPzJpT8ixR/yXzgr0lelCmM6g+09VXJuaOZpeDT
         +ClGJuLsZfG9+ZLArj11I93A1U0b23gUeYJh3uNMyaM38nwbI4NhkU6zpalkfPNZrLnx
         l3FJiauD/VEX9KyL+wfwOV7HXdctCAmWUVtpr0SUHGlmUSUDfiMpOSeapFyHCeZzkI98
         DHNPLKv0a8GOLLx7uwdW/z4JvpqXWps+HJAzB098jjCLLReL58eu0WOj+K+gz/KGJfqm
         Xzpn2gEOdV0wt1bCjTmXwZCJmBUF61XeXkW1Mu+DV8yz+ZALrQzyZy5n7HsFKkTcyXwQ
         IMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=YWiXQmBHUGHtpfW0A1FRblib1vkHZebP5zWOwP1oTJs=;
        b=aUpgffXClYwlOgjlH7Ibh/0A34uyhWFhNaFrhS/NxmZnUycKEQc5IOplHDP3KsB+Uv
         ZsiezBdgyIrWe3oTv4Ui7fH1OoekGpLuuLEQjjAvZDFBxjO6AtOylFIPE0gzdC+tRkax
         KyBSlxGrWLu93FaW+vg2639805aQHtYk0NZN7UqfWQ6ofYHYIFj7y9eTf3sdlRL73vgQ
         rgo8KnEuaXABQn6QB1N2XHb8SltxohwrWuHcOzdt/JSGrtXnLWF4Q+WzVSMvFFDLrTmG
         cGafaGRpGzxukvN88d+w6dKNPkCphAFYISU3l27JuvBX9eaDkPfY1WL7ZTDJDSfowM8p
         B4FQ==
X-Gm-Message-State: AGRZ1gJ6XrWBt44RCvZNpqHeRPWyYE1RHJVfSttZeWVkf+bwq7UX/oqK
        ZS+/ZCEXLXZScJK/arvTRus=
X-Google-Smtp-Source: AJdET5cTlbIvH4z0uQwMaWvhgWoyCyZt3RCcr01fhP8edU7mj6lG1YDao8Q/DxIEJUEQmNihJ4f4Fg==
X-Received: by 2002:a37:5b83:: with SMTP id p125-v6mr4168145qkb.88.1540422214248;
        Wed, 24 Oct 2018 16:03:34 -0700 (PDT)
Received: from ?IPv6:2001:470:1d:7b6::245? ([2001:470:1d:7b6::245])
        by smtp.googlemail.com with ESMTPSA id h4-v6sm3099415qkg.95.2018.10.24.16.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 16:03:33 -0700 (PDT)
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
 <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
 <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
From:   Ellie Revves <ellierevves@gmail.com>
Message-ID: <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
Date:   Wed, 24 Oct 2018 19:05:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
CONFIG_ATH9K_PCOEM is already enabled in my kernel build. In fact if it 
is disabled my card does not show up at all.
Thanks

Tom Psyborg a écrit :
> Hi
>
> Try selecting config option ATH9K_SUPPORT_PCOEM (Support chips used in
> PC OEM cards) and rebuild your image.
>
> I'm not familiar with your architecture but it seems you're not
> getting debug output. It should print a lot of info right after the:
> ath: phy0: WB335 2-ANT card detected


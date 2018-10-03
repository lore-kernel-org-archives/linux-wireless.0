Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECB3C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 17:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE2FE2089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 17:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRnj8uWZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE2FE2089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbeJDA1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 20:27:54 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42837 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbeJDA1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 20:27:54 -0400
Received: by mail-oi1-f178.google.com with SMTP id w81-v6so5208217oiw.9
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7XMatPMZLxMu/FIkN8+YViw8vNYp2bgVNDKcYDZc7qo=;
        b=aRnj8uWZWCe4FyZ+PJjQ7vLsz2gurdAyGOIDaWoGoq/WighJDOjHTZngbH15Wx32d6
         G7jTeQHPXtbMs3kA8ijqtNEysdtod6+dcr+ZsLREeuE+xTxYULRCDSin7Jesm5aKbUPF
         1xnpA2OFtAUhloJLkBcZxKWNCYilMnnhKHxeSWy/3SLuyI5ToVgBPSfG6pMnBAzdYCCC
         wz/+bdTftD5ay4Ly9dq5Po6YzPf37SlU+7ykSxz2jVT4ZYR1RM8CaF6RMoR1mpYP9uiN
         6tFFYqT5AYhNpICX/GJer6hN5vNa1UgmKZbMCdwJGatv/isTTuO/WcQxNhvIIvaZUcPl
         ba1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7XMatPMZLxMu/FIkN8+YViw8vNYp2bgVNDKcYDZc7qo=;
        b=hQ6xbhRaGY6CwysP+vmY4yPC0O4SfkM/wKfH1MbMpOWVRgMqgQNxhQ87YBeSeUjlZY
         Wy2Y0rnebqVhXW2sroDGyC13+puaa8Qq0ekho+z9l1t8zFfJUt0yC86IMMP0Eq94vbl/
         WauHKB0ooqFzxxTHpPXhzd1XgTkWy+ofbpuNc3CU8vSrkObvmQdV70tUSeHY0mhipnOF
         PZpu3SmyJhqmJoIGrLrmtQZ1c5JZvODQM+m/dr0ItuGhxU6DDyDoTCBBjy3CS6S/HozD
         wudgkv7Bm1ufOQ0XG46BoMG6XSgpifuoDHw7Md5oUD8dn9yoKigznm5hnJfE0fqaC7ne
         k4rw==
X-Gm-Message-State: ABuFfojuvHdv9Jl2gkz0vFR0JkQ+UtIkOVCqPmG6GGz6/8hSGx6qAVXz
        vNpEpwg6Nu/z95ZfOyPfRRVO1lfk
X-Google-Smtp-Source: ACcGV61JeDwsFwmUgJh/5q9SSuByGttY6WKxKQ4zBMtV2+g0E90P/uku6Y9EF6nWs+BbnUf1mADMFQ==
X-Received: by 2002:aca:61d6:: with SMTP id v205-v6mr1158171oib.116.1538588311598;
        Wed, 03 Oct 2018 10:38:31 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e9sm625690oth.7.2018.10.03.10.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 10:38:30 -0700 (PDT)
Subject: Re: [RFC v2 00/12] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     yhchuang@realtek.com, Kalle Valo <kvalo@codeaurora.org>,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <CAM0KTbAkm+crgK98kus7N7fCZFA5w9aRJ=Fam+Qe5cv_t9x=DA@mail.gmail.com>
 <3aa94c69-9cdf-77e0-f7b6-d31b501beaee@lwfinger.net>
 <CAM0KTbDE0sHXO2xdo91HuDnDx6Gc2jUfZBfYCie4yqrC7h690g@mail.gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0913534b-8aae-3fdf-c70c-4eea825103cf@lwfinger.net>
Date:   Wed, 3 Oct 2018 12:38:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAM0KTbDE0sHXO2xdo91HuDnDx6Gc2jUfZBfYCie4yqrC7h690g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/3/18 11:57 AM, Sid Hayn wrote:
> On Wed, Oct 3, 2018 at 12:52 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> On 10/3/18 11:15 AM, Sid Hayn wrote:
>>> Is there a public repository where I can track development for this driver?
>>
>> For the moment, this is it. Once the driver is accepted into the
>> wireless-drivers-next tree, I will create a new rtw88 branch in
>> http://github.com/lwfinger.git with this driver to accomodate people that want
> 
> I think you lost part of that link.

Yes. http://github.com/lwfinger/rtlwifi_new.git is the correct one.


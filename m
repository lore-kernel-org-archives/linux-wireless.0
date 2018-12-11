Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93FAC67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963D12086D
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="LBue4hjk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 963D12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbeLKSxU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 13:53:20 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:32921 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbeLKSxU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 13:53:20 -0500
Received: by mail-lj1-f181.google.com with SMTP id v1-v6so14011682ljd.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 10:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HFAmuaR5BVXw6CgtouJkMkubvKolwVgijb2osrDFuw8=;
        b=LBue4hjksYb7FokicFJ5z7htD0W8b1Aqkmu7l2z2+Dba3Doz7teK+/sawFR6rIp4nv
         QGbWQKqxh1jGCoGxRtx4CCzCZMXG7o4cuG3vOU45MDnFtYAJADGq/wk5e4r4lAFc/9Zx
         n9CdgYd/cBMXtYrlJNDp/Ndi5lOrH9Qqhcu9CP2v8yrvPHU/2oYEfJYVT23exsMXma1L
         yG7bBzpNt3ZflPWwBHg8nSwr6fmj+JPJcswmJzWLwt8dvNQnUdFWtmzCyCfmZgrxktXp
         SM//rxaWSYtR/PxTy3JqBAK+OFLx+YMuv2+gyWO52pUvjudw/LAig2Z0ffSmD8XTTD1J
         wHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HFAmuaR5BVXw6CgtouJkMkubvKolwVgijb2osrDFuw8=;
        b=tLuFs6EwpF1XrEcOGzAiMybCYDEbvxSP6qj7FtF5QXrvHqHLDEMVWF7GLKXqf6EK15
         B6rYkQW5V/JYK5iV85cviDbYIf9xJm6FgYsrEsehnrQxGXkXN5Wrw5He4NFM8FXo5Q/n
         nb2VNCBEev4jkfR1/FksL4VEuLxbgcMMToPNOecwquundUhTEiEyanQ7LGd035Xs9HLi
         RKcsYaesXfEWYy8iCAFO9JjJvop1EpSCZn6x7N51c17Qg6XPGmLOS+vmZi2uuwFxPhFS
         sd0bhvCZRKuIrDHm59HF2kxMssFcn+8luSRjlGNqQVmx9olOGquKh/DmOl2L1Dww1J4B
         tLdQ==
X-Gm-Message-State: AA+aEWbRlB8TmPH7hMw9JW+VS3nksfCCcESSEVo8ICi1MKtIsm0JKr++
        wi+CZfksrdbCIYAZ+GOiwW/22UTTsDdwls5i+RdEqg==
X-Google-Smtp-Source: AFSGD/WdO/8bajtOt7/xf3sO/EKIllPX17o2W1SDKeAImRefsl5fLaJaY6+hro2apDxtmet9lhKgGsM2YxATi1lMT0g=
X-Received: by 2002:a2e:9655:: with SMTP id z21-v6mr11775881ljh.136.1544554397949;
 Tue, 11 Dec 2018 10:53:17 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
In-Reply-To: <20181211181944.GW39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 16:52:40 -0200
Message-ID: <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     linux-wireless@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Tue, Dec 11, 2018 at 4:19 PM Tony Lindgren <tony@atomide.com> wrote:
>
> Hi,
>
> * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:06]:
> > John, did you have any similar issue on your test environment with
> > kernel >= 4.19?
>
> This sounds like the same issue that got fixed in the dts
> earlier?
>
> f904390ac8b2 ("arm64: dts: hikey: Define wl1835 power capabilities")

keep-power-in-suspend was removed in 8883ac1db3e2 ("arm64: dts: hikey:
Remove keep-power-in-suspend property"), but I just tested after
adding that property back in and made no difference.

The funny thing is that it works fine if I disable NetworkManager MAC
address randomization.

Thanks,
-- 
Ricardo Salveti de Araujo

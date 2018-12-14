Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546D3C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F63D206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="hlMAavCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbeLNUmZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:42:25 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:42180 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbeLNUmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:42:25 -0500
Received: by mail-lj1-f176.google.com with SMTP id l15-v6so5996072lja.9
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2018 12:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XxAdKgEI/yAbM92b2c2PSLOJXVMOr+Fcm8Ufzy3P7r8=;
        b=hlMAavCsNbnzzepVkDR+s0hDdxRbTBfHUM3ltF/ihnUoiRQdbrW9bYieQnqf5w97ym
         vWZc06JNB7kEFo2MB4DWjJeAhFyC+YZSHQWiclWhrVmnBAHJIIpF7C2QBhrE/Ct6q9Yg
         7XEHMlwvZzGMs77Yf1oixFkOcKn1NSi25J+B7EuL24iRW5IxuVqdyRcMMb96FqTAhdt9
         pM2mgq7wRNedtghahCQAwSBbSpfIbDbzxDvGV7YI9+6aCHkbOnHzyl38XZCagy8+hY1y
         Ao6bffTYzG92d+V0abASx906lKBsU0gw1hJtIxYg+7CaLzrli4W0aVctYxbGokcArhuc
         JRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XxAdKgEI/yAbM92b2c2PSLOJXVMOr+Fcm8Ufzy3P7r8=;
        b=CUPpWKOwXcia+vwkJnGSLZQ9lDnfgyTYcrWRoMnm4QMITw9XVpoKrTYyBeaUxosnm1
         yTj3ucUVs2LpTHQYlOkOyAonGvTpwbmEIBhpzj4U3zZwrsGHCSffmxFpAKETL07rJ2V0
         sdrVplnNyZXZPl2TA5OEhbHyRFNuuaTP8Yw0mREy4UMEdjnmSURSQ4RInovU3YTieVKL
         4C8/R4NCq46VF0b25jr0v+Kc0Z9DkV5vqUeI+2u82qzhxjnnS4yJjsoRj6ZM0fE+ABFn
         ImvHCjjdbnB2La3d69ZJDMEc8xvIUZ4elm5Phay3gIcCvVUjGbYyc1X67xZhA+PUMjqa
         MqjQ==
X-Gm-Message-State: AA+aEWZbYplaWXv+IA491T5sdn7PSsCOFwybr7h0UYtMO75rX7zCNkxH
        zP7E9NvJ7keCpTAyBTYXaAoF63sU+k6qst1LxD+q5A==
X-Google-Smtp-Source: AFSGD/UZsWLrEz4g7Vb4XaPClrflC+EaDZm//0k75aVdF2YSTOqSgeNf0mjXYGUKgcu+NVjSNmb8vR3EGQ0KAcDwvTw=
X-Received: by 2002:a2e:94ce:: with SMTP id r14-v6mr2408163ljh.34.1544820142673;
 Fri, 14 Dec 2018 12:42:22 -0800 (PST)
MIME-Version: 1.0
References: <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com> <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com> <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
 <20181213144522.GO39861@atomide.com>
In-Reply-To: <20181213144522.GO39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Fri, 14 Dec 2018 18:41:45 -0200
Message-ID: <CAHYQr0qg31hqyzm9uK03qz=DmUkA9idqTrhLaP9A6nuXPEW73w@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     eyalr@ti.com, John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Thu, Dec 13, 2018 at 12:45 PM Tony Lindgren <tony@atomide.com> wrote:
> * Ricardo Salveti <rsalveti@rsalveti.net> [181213 13:53]:
> > I tried just increasing WL1271_PRE_POWER_ON_SLEEP from 20ms to 50ms
> > (which gets used before calling wl12xx_sdio_power_on), and that was
> > already enough to fix my issues on both hikey and beaglebone black
> > wireless.
>
> OK good to hear that helps :)
>
> > Should we define another pre power on sleep specifically for the sdio
> > case (and use directly in wl12xx_sdio_power_on)?
>
> I'd probably prefer to just increase WL1271_PRE_POWER_ON_SLEEP,
> chances are the same delay is needed in all cases.

Investigating this issue a bit more, I noticed that the hang happens
when PM decides to not suspend the device when doing an if down/up
cycle.

Basically since commit 60f36637bbbd ("wlcore: sdio: allow pm to handle
sdio power") PM is now handling the sdio power off/on process, and if
wl12xx_sdio_power_on gets called right after wl12xx_sdio_power_off (if
down/up), the device will not go to the required power off/on sequence
(since PM will abort the suspend process), and the firmware loading
process will fail. I would guess the problem only happens with
autosuspend because of the extra delay it causes (pm_runtime_put
always returns -EBUSY on wl12xx_sdio_power_off with autosuspend).

Is there a way to force the suspend on wl12xx_sdio_power_off, or
should we partially restore the old behavior?

Thanks,
-- 
Ricardo Salveti de Araujo

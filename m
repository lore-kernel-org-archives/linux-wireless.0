Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390F9C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF92120877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aG2RxyYF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF92120877
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbeIYPfT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 11:35:19 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:51068 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbeIYPfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 11:35:18 -0400
Received: by mail-it1-f196.google.com with SMTP id j81-v6so14510388ite.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 02:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y7x52z4ZoIBA8H6VUhIR8jIhAP6tooaTqg88+tpo1lA=;
        b=aG2RxyYF4sWuOd4CH8CEXZ+fQuxdD+MkJK0JuSU1GUm8O5zvSq2mUI+41EjanyDSSp
         Dt1PCqA5uTUtCJoK8plX0PrmZCyh7MWniabhWXsDFBqS2rNM7+JJT4JqO0u3+Au9Jb9/
         UWf3TwGSoWRnm337bfLhsusts6WtoG628bBiz1kOsVzvXfCzB6vr7MD6E/70/mmle1lO
         EmODk08PWAjHzfCqXgkRK8N/IMZJSLYgD3CA8L+iDndUMU1chV8b8uD4llxmYSysdx9d
         a/qiE15Ts40M1i5uyYkbjmjy1aWysqBj4O1hoBF1DgTRTEJ+F/stpo/y+G2TJIs16MfS
         byFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y7x52z4ZoIBA8H6VUhIR8jIhAP6tooaTqg88+tpo1lA=;
        b=tkpYlLckYUGFbNPktMUUkDSlRszKUGsJ1hqJsoqNLCyooD+2GMZtVwmj6yftUmlSTC
         7xQxJTxjEvxLwthbZLw4ZEDXGwn0nXC/RHrmh6CAmkdf5MvWUWnqJGGyb0Nts42wdgcC
         DLkBUkri+sgJS+OZqAtdpIgwOoQaZOTRv7Sqt3gwJB2So823GzzdsktOc3cyL2HgdxvC
         H/GujtHMtPsrMXFz6ipSr3PRceOudii+vz/ZFgVt7Ucbeq4bnHVhaYbmJnO0sR8nx6gu
         ra8GPJoHS78McfUkWMWvmke/0J3I7vuitACFJcfkqWkXNTO4xadk4AMF0p5LOwr/DFZO
         jnRg==
X-Gm-Message-State: ABuFfoi9RhYQZHpL5xYh1K71+9UpIzLj7FwpF7Zag+aRHaigDmVSjyoA
        RFeEOaIh3XIrjevnIjzzwV9oYLsWOJ0dGhN3l2OSWyvx
X-Google-Smtp-Source: ACcGV627iap4NKUO0S3DAzszBHXnnfHaLnPwxmbHVRIoxctEl9RjWAATrBbu+5ipn6rhrSAa63pluacZzcwCnPQbP/8=
X-Received: by 2002:a24:76c6:: with SMTP id z189-v6mr58209itb.81.1537867719949;
 Tue, 25 Sep 2018 02:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20180925081933.28553-1-enrique.giraldo@galgus.net> <57143da1-1569-bd98-70e9-91cdcd89d1b8@broadcom.com>
In-Reply-To: <57143da1-1569-bd98-70e9-91cdcd89d1b8@broadcom.com>
From:   Enrique Giraldo <hgiraldos@gmail.com>
Date:   Tue, 25 Sep 2018 11:28:27 +0200
Message-ID: <CAEbaMQ+N=hUwXta9NbrBpF3YcoCyUNWB=s3cynp4pzFLuFrmDA@mail.gmail.com>
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
To:     arend.vanspriel@broadcom.com
Cc:     linux-wireless@vger.kernel.org,
        Enrique Giraldo <enrique.giraldo@galgus.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The main reason is to be able to stop the CAC when you want to make a
channel switch and the CAC is ongoing. It's true that the radio would
not pass to the next phase, the behavior is the same as when during
the CAC a radar event is detected. In the case of aborting, a later
action is expected, for example, switch to the desired new channel.

Regards,
EG
El mar., 25 sept. 2018 a las 10:52, Arend van Spriel
(<arend.vanspriel@broadcom.com>) escribi=C3=B3:
>
> On 9/25/2018 10:19 AM, Enrique Giraldo wrote:
> > Add NL80211_CMD_ABORT_CAC to the nl80211 interface.
>
> This one really needs a good motivation. The CAC duration is a hard
> requirement so aborting it means that the radio can not proceed to the
> next phase. You really need to describe your reasoning for wanting this
> in the commit message.
>
> Regards,
> Arend

Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55995ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 14:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BD6E205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 14:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jopLTEUy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BD6E205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbeJSW1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 18:27:30 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37061 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbeJSW1a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 18:27:30 -0400
Received: by mail-ot1-f68.google.com with SMTP id o14so33358545oth.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 07:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Tel620pv6cC/r5BnusszcuFrRXazeV3I+95aCckCA2I=;
        b=jopLTEUydpV5CXEGrbBd/qiAdAHcki/FC4uRJi5885Y1cLOEdHx75OZgefCHhy3yI5
         3Ln7bfJRn9U46HaWau5yhj3AvAf56lgzrGVqFRPq+qjWIXIZywbP9gBpHk0GKp4yQPKJ
         sSxyfdES64jGL3IpCgTJjSqm6r+sYf5hDg49bWroBw5orw7zC4zrinSF9eMIFURkx+oz
         mfQLu2eKA6DbbgCyCxg5DU4266nD9weNZb5zWM4A+Ua31c1RUKz11sbcdj0Zfnc0W0U+
         Vo9SU++e5vPpNM0Xn8mzSO6619tBX6QUBfQAbVe3rvOJ4+KNLVnO3iMCe3pjrZZT6/uT
         CdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Tel620pv6cC/r5BnusszcuFrRXazeV3I+95aCckCA2I=;
        b=Fq/1/434SXcNzAGFI3D9PEXgZU1vn9UYNbnwxprFs7oj8zHPxnC5PlC36RbYqX5Goo
         qpDcgmb/sx2uI/5GONrJUBNh+KiFUnjhRl7xiiRvOMcLysrX/6rNMtM+D+MJ1ADyThWN
         uiZrheqqdor/NH5Hy+8B9BoG4COpLkpjtezlGbAGgJSDwXKSKkTtZIbt9o9qVoFbaZU0
         DvdER9h4DxWY0kU3xDziH8UsfFKK0ItZdIA/XJiLaR0Eo37MwcisiIQ+xe/chQF0bP4+
         3N6TGPNaorKCQcJTzN/OOLFQqiYO7wxMDnTD/7xSd7xdwp7s/4cNzvbCpPUfzybHd13v
         bh1w==
X-Gm-Message-State: ABuFfojAQuYw0tycEm+BIPuW4l9WgCINl/eTH/T7BjrYYnu/UfyzehFA
        5U0D/3icWALDMZyqhEW6wQJVEq4377clTn9SMoQ=
X-Google-Smtp-Source: ACcGV610b4SXAs6TAGtmLH3ngxdSJg6/YVuFwUQgMPlMotJhRGpS4KXp9kn0gDiybIwuKtHmiWl5qcMLhd8taha5NtY=
X-Received: by 2002:a9d:ec:: with SMTP id 41mr21300896otk.322.1539958870152;
 Fri, 19 Oct 2018 07:21:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 07:21:09
 -0700 (PDT)
In-Reply-To: <20181019090028.GA7023@redhat.com>
References: <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com> <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com> <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com> <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
 <20181016154957.GA8730@redhat.com> <CAKR_QV+p_BP+xvqc65gHjm8t6fRNwfTRwKixCn7DN9+LjG-n3A@mail.gmail.com>
 <20181019090028.GA7023@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 19 Oct 2018 16:21:09 +0200
Message-ID: <CAKR_QVJPKO6Au_WieKjeSZP9vRhFTqukhndgwYAnxAUuwziAaQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> I tried to do this, but somehow after update BUILD1 image into device
> my configuration was wiped out :-( and I have to reconfigure the
> device now. Anyway I'm going to test and provide dmesg , but this
> will take some time.
>
> Regards
> Stanislaw
>

that's because these builds were done on 4.4 that i had in my system
and there are config differences between these builds and current
snapshot. to save you time i need only bootlogs not wifi performance
tests.

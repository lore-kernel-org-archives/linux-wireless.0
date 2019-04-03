Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E31C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B1C206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ARcmMY6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfDCVyg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:54:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37618 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfDCVyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:54:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id v13so234358ljk.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 14:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LSzGYsUBhMejBhdR+T6eDwrJzGUj5uVFCe5qUeMwc4=;
        b=ARcmMY6BIwjUM+i1+uZLfQc81yzqcwvcgXVJ1cj5B0CRgoSeWH9cbaH8C1q4GWhnjX
         2mHoEeMb5lHgYzhzQydj+Gvb4G3VeWIgzA+LLIe7jIdNUdCYUXLKy3SqUl5/TMjNyB0X
         l3a55XKkfuc7ibR3Dyq+KabgaJH9f93BBOEAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LSzGYsUBhMejBhdR+T6eDwrJzGUj5uVFCe5qUeMwc4=;
        b=B/Fb3urCAkoLXtf0RYkc1yAt5xKjWLRPBstAvgKgBPZ6i6eNe2XLDiSmczostIqKOj
         jyWfsnlbl9KVJtzC+AMfb+9g6CSjly4IAGHB3lsfY9ZA/afRmdsWF63mMGQ4GX7Kpy4I
         TiRaQ8RJIRVP6RlUGzm3POkJB3jhuoyYu5AI0VsNlyvk6pkFPtHeLS6dMk3MFF8mJPQG
         zVJE+DIHOm6TcxW4hkTHJwkiwBu8C2Xn3Rc2K+Zh7X5OhfK4haS0pJLUN/PufNCUs4G+
         TN4bO0EvY1uxSiADVgRWjaQfcwhl4gsp6aVUNNYSPahkOZLnK0zrDnCGYqX0TUWwXIa0
         FUUA==
X-Gm-Message-State: APjAAAVKq5uAxM4BROBxGq18KdzEOEkuJ7Sq46aIxWej/qz8ovW14Vzh
        pfbG2em877mXC2iduTn6FiKSf/o2EWs=
X-Google-Smtp-Source: APXvYqx8a2RN4ChnTg9nkGYay/lqZkoOUDDozQctxkq0c/TMH33EZr810BdOGgB3w5lXKaFesOMZ6A==
X-Received: by 2002:a2e:9619:: with SMTP id v25mr1133863ljh.145.1554328474056;
        Wed, 03 Apr 2019 14:54:34 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id o3sm3169066lfd.53.2019.04.03.14.54.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Apr 2019 14:54:32 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id h21so190498ljk.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 14:54:31 -0700 (PDT)
X-Received: by 2002:a2e:9213:: with SMTP id k19mr1209111ljg.118.1554328471072;
 Wed, 03 Apr 2019 14:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan> <20190403195718.GA74723@google.com>
 <1645947.WPhbVaNX0l@aspire.rjw.lan>
In-Reply-To: <1645947.WPhbVaNX0l@aspire.rjw.lan>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 3 Apr 2019 14:54:19 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPoB94o0pbY0TQGS7Dtp2RNz=3goH38gpLtBoJ15i7eoQ@mail.gmail.com>
Message-ID: <CA+ASDXPoB94o0pbY0TQGS7Dtp2RNz=3goH38gpLtBoJ15i7eoQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sriram R <srirrama@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Claire Chang <tientzu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 3, 2019 at 2:47 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I have been wondering whether or not I need to resend this patch or something ...

I think the linux-wireless Patchwork instance is the source of truth
-- Kalle and Johannes use it for tracking status, IIUC. So this says
your patch is still "New":

https://patchwork.kernel.org/patch/10837139/

Brian

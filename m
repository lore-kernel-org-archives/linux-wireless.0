Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FE3C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2C8E207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfBVIwm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:52:42 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41525 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfBVIwm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 03:52:42 -0500
Received: by mail-qk1-f193.google.com with SMTP id y15so695287qki.8;
        Fri, 22 Feb 2019 00:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kvc91ycTMAx+sjmDUxpaVWj/cj40PBFIj+ZwRQAbmgM=;
        b=N0AvMsA6n3gskCrTHTieOSI6fskiZG86dWRzVOMP1dESqfTpxFda46ngq0l7zmjC1a
         QREToGySgw61nAqLwoBzatEiiSN4FnUMMgE8jydPUNfuRn0GbAYWByKvUgA1RuF7wVSW
         /LE+QIhsu9bWwWdT40cFiT3+wUvyn0LgOJBLXe7HvxxraqouCc6dZNo7OvqE3qIdsAru
         s2wZd6wbc+hXtlA9CNOn55LJsyGz4SW2xAUpZj6MQkfqUMamjaqEaDZG+yf/sq3GiYIe
         UL/vyLw4i02lcXbfsDgbiEOOZU7mzAJ4SVaEUSYawuxWtkkbMiAda8IQppnriGpxf1d+
         nrug==
X-Gm-Message-State: AHQUAuacZ94WwKhfw81/OtlnRubVVq4BRpLiFEHKT4X2KpWrRu4kUYQ6
        NOVTYT16ZBJ3OpzM2InFV19DgrL5OXIy4ccXNOg=
X-Google-Smtp-Source: AHgI3IYVzBQ3rEpRHciMiOzgvq0odtLAtF9rlT0bGHFi5duwUet8l5uQXhO0/aCXBSfX3+Rnr/2ZeguOP6nq5yUcRcg=
X-Received: by 2002:a05:620a:12a5:: with SMTP id x5mr2158374qki.291.1550825561015;
 Fri, 22 Feb 2019 00:52:41 -0800 (PST)
MIME-Version: 1.0
References: <20190219182105.19933-1-natechancellor@gmail.com>
 <20190221080617.2795-1-natechancellor@gmail.com> <CAKwvOdmCeHxiGPkXXzjwnTtgzEDDjYRE1QBdu7BHeuzCE4YtRA@mail.gmail.com>
In-Reply-To: <CAKwvOdmCeHxiGPkXXzjwnTtgzEDDjYRE1QBdu7BHeuzCE4YtRA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 Feb 2019 09:52:24 +0100
Message-ID: <CAK8P3a1tJcWkxBKMzshNyP5BmN0SaNWKZ6OHkjUv8YetT9nQaQ@mail.gmail.com>
Subject: Re: [PATCH v2] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_debug_range_resp
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 22, 2019 at 1:14 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> On Thu, Feb 21, 2019 at 12:08 AM Nathan Chancellor <natechancellor@gmail.com> wrote:

> One thing I'm curious about, is "why does do_div exist?" When should I
> use do_div vs div_u64 (not div_s64 as is used in this patch)?

I think do_div() is mostly historic, we've had it since the early days
when C compilers were not as good with inline functions. The various
other versions are regular functions, and I tend to prefer them for new
code, but do_div() is widely known and documented, so I have little
hope of it going away any time soon.

       Arnd

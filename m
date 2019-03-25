Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9127FC4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 18:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C4320848
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 18:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KK3qxYo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfCYSbA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:31:00 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43431 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfCYSa7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 14:30:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id f18so8767049lja.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 11:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VkAbrABHGCAPpKn9bQ0JA4fvmGXFMhtp/PddXf8SBog=;
        b=KK3qxYo0AUzRBqI6HR/J8WLaTzqpZ3R2HsTuMd9BRZ9H6gM7WiU+4PlOe4a8CxQU9y
         9TQcKBEdrTf4/CHlu0rluXleVorihN0L4gdxDDZe90Kemm5rdkyKb/62bpSYudMyvivH
         83FwlRg+90X+2dkBaeUe9F4xhREJ73Gotv/Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VkAbrABHGCAPpKn9bQ0JA4fvmGXFMhtp/PddXf8SBog=;
        b=X5cPY4hObaSmcuR7X8ZSvkSN24R67sbl0yijIXeBRbINugiv58T7ai5r+kan4oLN70
         bFok9qvfQhbUkYDUCsQloy+R3ZOuGj6HNL71eBZwapqv4/oSqeoWjLOc9hXFv9DJmu7W
         Qf/v+csGcTMzcXziZfVtANuOKr4+KSTXOryGvmy1EGaPSs/CE8eIfol6wXz+nLDCYjTu
         JA60YfW1EAXIz+cHCjI7eZ+y5YxhvKZeIQfmKsoKvWhbIOax4HytrbvjDIh7D7qDgyJR
         eYkmMTiUXgyl6vaP8vYCs39J08oIhp2KxUI4FxIRveQYZPvsixjZ6xISRa+OEQW8TmT+
         xlwA==
X-Gm-Message-State: APjAAAW8nQ4305G0XQJqNYpuzB4vgGM1VUhFkihfhHxPXfmAzOY32iAf
        iEi5FX7TLtCWtZ6s2F2AmZWrnOpR69g=
X-Google-Smtp-Source: APXvYqxuIkmxSqgNC5IyMOJqTkTMHL03EahAPO+tNhApsiJvwiO+kdy8nGhLBcMNb+cjUeUm6ezgUA==
X-Received: by 2002:a2e:9682:: with SMTP id q2mr12725142lji.168.1553538656692;
        Mon, 25 Mar 2019 11:30:56 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id m23sm3585137ljh.93.2019.03.25.11.30.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 11:30:53 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id v22so8761742lje.9
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 11:30:53 -0700 (PDT)
X-Received: by 2002:a2e:4a1a:: with SMTP id x26mr12231001lja.49.1553538652928;
 Mon, 25 Mar 2019 11:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190323223339.13703-1-kjlu@umn.edu>
In-Reply-To: <20190323223339.13703-1-kjlu@umn.edu>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 25 Mar 2019 11:30:41 -0700
X-Gmail-Original-Message-ID: <CA+ASDXP59t4P3nO8pGC-7NPOyFwHPSgazLF1WRu3ZexzTogypA@mail.gmail.com>
Message-ID: <CA+ASDXP59t4P3nO8pGC-7NPOyFwHPSgazLF1WRu3ZexzTogypA@mail.gmail.com>
Subject: Re: [PATCH] net: mwifiex: fix a missing check of ssid
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 23, 2019 at 3:34 PM Kangjie Lu <kjlu@umn.edu> wrote:
> sme->ssid may be invalid and thus should be checked.

Under what conditions are you seeing this? I see that brcmfmac, for
one, also has a similar check, but IIUC, the connect API always
pre-checks that there's an SSID provided:

static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
{
        struct cfg80211_registered_device *rdev = info->user_ptr[0];
        struct net_device *dev = info->user_ptr[1];
        struct cfg80211_connect_params connect;
        struct wiphy *wiphy;
        struct cfg80211_cached_keys *connkeys = NULL;
        int err;

        memset(&connect, 0, sizeof(connect));

        if (!info->attrs[NL80211_ATTR_SSID] ||
            !nla_len(info->attrs[NL80211_ATTR_SSID]))
                return -EINVAL;
...
        connect.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);


So this patch shouldn't be necessary.

Perhaps I'm missing something though.

Regards,
Brian

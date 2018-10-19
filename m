Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AD4ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 20:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9280B2087A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 20:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9280B2087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbeJTEhq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 00:37:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37563 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbeJTEhq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 00:37:46 -0400
Received: by mail-io1-f66.google.com with SMTP id m16-v6so23785570ioj.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 13:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIrMCGp+m61rELioa3GwYMfPGCP56WO/U/90NNeCfXA=;
        b=GKZUYHfVoBYas/BV/WPes9eM56lFZgMhroZFx5BVctPRIBa6ye54LIcDGe4MgIKtj5
         MM8RUqKSgy/IWAgiUqLvnH97QFTfrHJ0jRionRUiqFFZ30C4YgusreH/4cRNeMfs1c5a
         ijpnHTVnyJZuzUK1VfvDylE8zZXuqHqFNvV33jucaX5VB71/WVUOmc5mY9kVKYGiZdJm
         ObgEqlTwwa9vFBMKhcI6BG/18y1DxW8XnWAJEdV4pTsQZly6RxoaQhdG60faZuf7ASOh
         gF9xjTU7dDn+4A8J1lrmyBkIqlNo/EbJ2jaPemwoHIWwINvMAIWMh9tvf9lPz+QR66YK
         vlUg==
X-Gm-Message-State: AGRZ1gJpEr/N6LTlNpdFjQJIdmgigboosVkmS46CQc9WVx5SDEvlx1Gd
        8ZTA44GdI5EU/po5nYct34zzGHEETJY=
X-Google-Smtp-Source: AJdET5c9tl758G57Prism4oSc/Lv1oFyp6Y6khD2RWdp54tRwR8aL35pGtca8HyA3IJIIEw5ye+5qA==
X-Received: by 2002:a6b:c892:: with SMTP id y140-v6mr3655868iof.295.1539981007464;
        Fri, 19 Oct 2018 13:30:07 -0700 (PDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id g73-v6sm3694393itg.37.2018.10.19.13.30.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Oct 2018 13:30:07 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id d80-v6so3204541iof.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 13:30:07 -0700 (PDT)
X-Received: by 2002:a6b:5b16:: with SMTP id v22-v6mr3761574ioh.177.1539981006796;
 Fri, 19 Oct 2018 13:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20181019023722.6226-1-andrew.zaborowski@intel.com> <5f46e668ef6f4a273b8b5d65dce1efc6c1aa2ffa.camel@sipsolutions.net>
In-Reply-To: <5f46e668ef6f4a273b8b5d65dce1efc6c1aa2ffa.camel@sipsolutions.net>
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
Date:   Fri, 19 Oct 2018 22:29:55 +0200
X-Gmail-Original-Message-ID: <CAOq732KXw-j9HOcufCG96iv88y7-rnkaUZeFfi5HUSU0DFvh0w@mail.gmail.com>
Message-ID: <CAOq732KXw-j9HOcufCG96iv88y7-rnkaUZeFfi5HUSU0DFvh0w@mail.gmail.com>
Subject: Re: [PATCH] nl80211: Emit a NEW_INTERFACE on iftype change
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 19 Oct 2018 at 08:48, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2018-10-19 at 04:37 +0200, Andrew Zaborowski wrote:
> > Let userspace learn about iftype changes by sending an
> > NL80211_CMD_NEW_INTERFACE when handling a NL80211_CMD_SET_INTERFACE
> > command.  There seems to be no other place where the iftype can change:
> > nl80211_set_interface is the only caller of cfg80211_change_iface which
> > is the only caller of ops->change_virtual_intf.
>
> Why not use SET_INTERFACE? I think I'd be more comfortable with that,
> since it's not really used now and existing userspace might do weird
> things with NEW_INTERFACE?

True, let's use SET_INTERFACE then.

Best regards

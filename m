Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:38896 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759639AbZBMIXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 03:23:48 -0500
Received: by gxk22 with SMTP id 22so524182gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 00:23:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>
Date: Fri, 13 Feb 2009 00:23:47 -0800
Message-ID: <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com> (sfid-20090213_092402_025183_107D629E)
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Vitja Makarov <vitja.makarov@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 12:15 AM, Vitja Makarov <vitja.makarov@gmail.com> wrote:
> Hi!
>
> I was trying to build compat wireless for my arm board.
> First of all I disabled CONFIG_MAC80211 in my kernel, and successfully
> built compat-wireless.
>
> Then at runtime I get kernel panic.
> Then I found that sk_buff in 2.6.28 depends on CONFIG_MAC80211, so
> enabling it solves my problem.

Ah nice catch. Well you're the first to try that and report it.

> Shouldn't compat-wireless Makefile check kernel dot config for this
> option as well as for wireless extension?

Yes, Can you send a patch, put some nasty warn on config.mk if its not
enabled on 2.6.28 and error out.

  Luis

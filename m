Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:53104 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393AbZE0Srs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:47:48 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1285056rvb.5
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 11:47:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2db27c1a0905271140i50e2ac6qe84107308794d389@mail.gmail.com>
References: <2db27c1a0905271140i50e2ac6qe84107308794d389@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 May 2009 11:47:30 -0700
Message-ID: <43e72e890905271147r40142f4cr51d7e5fc908b82dd@mail.gmail.com>
Subject: Re: Reg domain
To: Liketo talk <foreverfrnd@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 11:40 AM, Liketo talk <foreverfrnd@gmail.com> wrote:
> Hi,
> I was going through the 802.11 static regulatory domain info build
> into the kernel initially. I had a few doubts regarding this which I
> hope will get clarified here:
>
> 1) In the US regulatory domain, all the channels are configured for
> active scan where as in the Japan, Europe regulatory domain, all 5 GHz
> channels are configured for passive scan. Why so?

The old static regulatory domain definition for countries in-kernel
are left intact from what they were originally defined by whoever it
is that implemented that originally. They were just ported over to the
new framework. This information is outdated and will be removed
eventually, this is why it falls under OLD_REG kconfig option.

> 2) Why only 3 static reg domains where chosen?

Because the approach we decided to take was to not define country
regulatory domains in-kernel anymore and instead move the definitions
to userspace. The 3 static regulatory domains for US, EU and JP are
purely historical.

If you want to look at the *current* regulatory framework look at the
code and ignore the OLD_REG crap, which will eventually be removed.

Also please read:

http://wireless.kernel.org/en/developers/Regulatory

  Luis

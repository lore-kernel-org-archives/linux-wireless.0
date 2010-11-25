Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0KYS20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 13:28:26 -0500
Received: by iwn33 with SMTP id 33so210726iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Nov 2010 10:28:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290673635.3770.0.camel@jlt3.sipsolutions.net>
References: <20101125200539.GA31878@linux-youquan.bj.intel.com> <1290673635.3770.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 25 Nov 2010 10:28:04 -0800
Message-ID: <AANLkTimqC7vaJHuX3aP+R8M877OKF4XmygpJKvhe1drb@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless:Fix interface redefine when backport to 2.6.32
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Youquan Song <youquan.song@linux.intel.com>,
	linux-wireless@vger.kernel.org, hui.xiao@intel.com,
	youquan.song@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 25, 2010 at 12:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-11-25 at 15:05 -0500, Youquan Song wrote:
>> Netdev_alloc_skb_ip_align already define at 2.6.32 kernel, so only < 2.6.32
>> kernel needs it, so when backport latest compat-wirelss to 2.6.32, it report
>> redefine the interface.
>
> That doesn't seem to be true:
>
> $ git describe --contains --match=v* 61321bbd
> v2.6.33-rc1~388^2~825
>
> Maybe you're using a patched (distro) kernel?

Also please note that you sent a patch using compat-wireless but the
code in questions is part of the compat.git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git

  Luis

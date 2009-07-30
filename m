Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36461 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZG3RGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 13:06:38 -0400
Received: by yxe26 with SMTP id 26so2697903yxe.4
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 10:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A71D172.1000306@gmail.com>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
	<4A719C44.6050208@gmail.com> <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com>
	<4A71D172.1000306@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jul 2009 10:06:17 -0700
Message-ID: <43e72e890907301006p200032e0i11fdb40fc33fa6d0@mail.gmail.com>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
To: Roman Macko <rmacko72@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 9:59 AM, Roman Macko<rmacko72@gmail.com> wrote:
> Yes, I tested it. When you place that config file containing "search updates
> built-in" in /etc/depmod.d
> directory, it doesn't work.

OK you probably have an old version of depmod. depmod is provided by
module-init-tools, what version of module-init-tools do you have?

I have 3.10 (as on Ubuntu Karmic)

> You have to place it in global config file
> /etc/depmod.conf.

If this is an old depmod thing we will have to check the version of
depmod and do this for that case.

> How depmod works with config files in /etc/depmod.d directory is a mystery
> for me.

Its not that tricky, the new version reads /etc/depmod.conf and if
that is not found then moves on to check /etc/depmod.d/* files.

> I wasn't able to learn
> this from manual pages.

That's probably because your version doesn't use depmod.d dir.

> And I tested another thing too. When some of config files (either global
> /etc/depmod.conf or one of those in /etc/depmod.d directory)
> doesn't contain search command ,
> everything works fine, according to manual page for depmod, using builtin
> search string "updates built-in" what  is
> what you need.

Right, built-in will use /lib/modules/$(uname -r)/kernel/ for modules,
chances are if no depmod.conf file or depmod.d dir is present default
may be to use built-in.

> As soon as one of them (either global or one of those in
> /etc/depmod.d directory) contains search command,
> then depmod uses this one. It seems seach command in global config file
> (/etc/depmod.conf) has higher priory. But as I say
> I really don't know how depmod works with all config files.

I believe this is built-in by default, then read depmod.conf first, if
that is not present read depmod.d dir.

  Luis

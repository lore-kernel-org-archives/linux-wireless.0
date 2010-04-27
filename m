Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62681 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0D0Fz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 01:55:56 -0400
Subject: Re: update compat drivers,adpter can not be work,4 help.tks
From: Pavel Roskin <proski@gnu.org>
To: seco.wu@gmail.com
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <s2ne4fca08d1004250142ga518cbfdn1692b54c23191bef@mail.gmail.com>
References: <v2ne4fca08d1004221625o4eb31e79ke1043f0c9a8e686f@mail.gmail.com>
	 <t2qe4fca08d1004221720gc8551b6bq21fb043eb9128f56@mail.gmail.com>
	 <u2p69e28c911004230108pd2452f2fga186ee2155c9e36c@mail.gmail.com>
	 <s2ne4fca08d1004250142ga518cbfdn1692b54c23191bef@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 01:55:54 -0400
Message-Id: <1272347754.22987.54.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-04-25 at 16:42 +0800, SECO wrote:
> tks Sir
> 
> what's matter with update compat-wireless under bt4?
...
> 00000-9FFFF write-back
>   A0000-BFFFF uncachable

Please don't waste bandwidth and space with irrelevant logs.

> b43: Unknown symbol ssb_pmu_set_ldo_paref

It looks like b43 was compiled, but ssb wasn't.  I can reproduce the
problem with Linux 2.6.26 without SSB enabled.

The logic for enabling ssb and SSB based devices in compat-wireless has
been broken for some time.  I reported it in the past.  But not enabling
the ssb module is a new problem.

> 2010/4/23, Gábor Stefanik <netrolller.3d@gmail.com>:
> > On Fri, Apr 23, 2010 at 2:20 AM, SECO <secowu@gmail.com> wrote:
> >> & this is the full log
> >>
> >>
> >> ./scripts/gen-compat-autoconf.sh config.mk >
> >> include/linux/compat_autoconf.h
> >> make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2.6.34-rc4
> >> modules
> >> make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'

Please don't quote text irrelevant to your message.

-- 
Regards,
Pavel Roskin

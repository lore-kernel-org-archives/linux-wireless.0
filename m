Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39267 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYITU4O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 16:56:14 -0400
Date: Sat, 20 Sep 2008 13:56:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Ingo Molnar <mingo@elte.hu>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080920205611.GB8996@tesla> (sfid-20080920_225628_972708_6B5CEF2B)
References: <20080919142801.GA5816@senthil-lnx.users.atheros.com> <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net> <20080919175824.GA5626@senthil-lnx.users.atheros.com> <20080919182322.GB7027@tesla> <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net> <20080919235305.GD11665@tesla> <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com> <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com> <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com> <f488382f0809192040k317660f3yb99806bbdce60449@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f488382f0809192040k317660f3yb99806bbdce60449@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 08:40:04PM -0700, Steven Noonan wrote:
> On Fri, Sep 19, 2008 at 8:29 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> > Anyway, there definitely is an interrupt storm here. Let me demonstrate...
> 
> Worth noting that this change (modified version of the patch by
> Senthil from earlier) made it so it didn't give an 'IRQ 17: nobody
> cared' when I reloaded ath9k during the IRQ storm...

Thanks, for letting us know -- John, seems that IRQ patch by Senthil is
27 material as it fixes an IRQ issue (nobody cared complaint, and it
disables the IRQ otherwise) upon rmmod during an IRQ storm.

  Luis

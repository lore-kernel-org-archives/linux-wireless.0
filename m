Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:13918 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbXH3BuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 21:50:02 -0400
Received: by py-out-1112.google.com with SMTP id u77so2570896pyb
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2007 18:50:02 -0700 (PDT)
Message-ID: <40f31dec0708291850j2d35db6cu9de7c5f0a91e76f7@mail.gmail.com>
Date: Thu, 30 Aug 2007 04:50:01 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070828171034.GB29343@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2713029743177393055@pripojeni.net>
	 <20070828171034.GB29343@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/8/28, Christoph Hellwig <hch@infradead.org>:
> On Tue, Aug 28, 2007 at 11:58:52AM -0400, Jiri Slaby wrote:
> > -ath5k-objs           = ath5k_base.o ath5k_hw.o ath5k_regdom.o
> > +ath5k-objs           = ath5k_base.o ath5k_hw.o ath5k_regdom.o \
> > +                       ath5k_hw_phy.o ath5k_hw_inivals.o
>
> And while I'm at nitpicking :)
>
> ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
> most drivers and ath5k_hw_inivals.o mights aswell be something like
> ath5k_init.o
>

If you check out the code you'll see i'm using the same convention
inside them, ath5k_hw* files contain hw related functions
(ath5k_hw_<name>) while driver code has ath5k_<name>. Also ath5k_init
is misleading, file acually includes initial register settings for
various chips and the functions to apply them on hw, not the
initialization/attach/wakeup etc routines (that can be found  in
ath5k_hw.c), that's why it's inivals, i couldn't find a more
appropriate name.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

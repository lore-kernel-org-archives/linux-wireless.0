Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35924 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab1BCTBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 14:01:40 -0500
Received: by ewy5 with SMTP id 5so887628ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 11:01:39 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 0/3] libertas_spi fixes
Date: Thu, 3 Feb 2011 20:59:26 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>,
	Marek Vasut <marek.vasut@gmail.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <20110131195227.GB3065@tuxdriver.com> <1296759294.9471.0.camel@dcbw.foobar.com>
In-Reply-To: <1296759294.9471.0.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201102032059.27128.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 February 2011 20:54:52 Dan Williams wrote:
> On Mon, 2011-01-31 at 14:52 -0500, John W. Linville wrote:
> > On Fri, Jan 21, 2011 at 10:44:47PM +0200, Vasily Khoruzhick wrote:
> > > This series attempts to fix libertas_spi bug (it calls functions that
> > > may sleep from atomic context) and add pm support to libertas_spi.
> > > Tested on Zipit Z2 device.
> > 
> > Are the libertas folks OK with this series?
> 
> 1 & 2 yes, I'll ack them if you like.  But I think we were waiting on a
> response from Vasily about #3, specifically Marek's question about "can
> this be done from the resume handler instead of a workqueue".

Nope, it can't, I tried to do so and it hangs on resume (console cursor 
flickers, so it's not complete hang, but it does not return control to shell). 
Can investigate why if you want.

Regards
Vasily

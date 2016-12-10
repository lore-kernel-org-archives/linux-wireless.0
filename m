Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:35753 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751263AbcLJGpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Dec 2016 01:45:32 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 022102E71
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 06:39:39 +0000 (UTC)
Message-ID: <1481351974.5946.49.camel@perches.com> (sfid-20161210_074811_823128_5B33185C)
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
From: Joe Perches <joe@perches.com>
To: Markus =?ISO-8859-1?Q?B=F6hme?= <markus.boehme@mailbox.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 09 Dec 2016 22:39:34 -0800
In-Reply-To: <77555ffb-de05-2837-2e13-aaf4ec710fc3@mailbox.org>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
         <20161202014833.6856-11-Larry.Finger@lwfinger.net>
         <20161205213447.GJ8176@mwanda>
         <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
         <20161206071340.GB10292@kroah.com>
         <871sxkdjeh.fsf@kamboji.qca.qualcomm.com> <20161207133219.GM8176@mwanda>
         <87y3zqbq8h.fsf@kamboji.qca.qualcomm.com> <20161208115049.GR8176@mwanda>
         <20161208115450.GK8244@mwanda> <87vaut32qd.fsf@kamboji.qca.qualcomm.com>
         <77555ffb-de05-2837-2e13-aaf4ec710fc3@mailbox.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-12-10 at 00:56 +0100, Markus Böhme wrote:
> On 12/09/2016 09:50 AM, Kalle Valo wrote:
> > Dan Carpenter <dan.carpenter@oracle.com> writes:
> > 
> > > On Thu, Dec 08, 2016 at 02:50:49PM +0300, Dan Carpenter wrote:
> > > > On Thu, Dec 08, 2016 at 01:43:42PM +0200, Kalle Valo wrote:
> > > > > But it would make me very happy if someone would add a similar grouping
> > > > > functionality to dyndbg to make it easy to enable a set of debug
> > > > > messages in a driver.
> > > > 
> > > > Thats seems like a reasonable thing as well.
> > > 
> > > I actually like the ath code...  We could easily change it to be more
> > > generic and make it a top level function for everyone to use.
> > 
> > That would be great. And maybe add a sysfs file with a description
> > different levels, like module parameters have. Too bad that I can't work
> > on that, too much stuff on my plate right now.
> > 
> 
> In this case I would like to step in and try to implement grouping of
> messages in the dynamic debug code. This seems to be an interesting
> learning opportunity.

Use bitmaps and levels.

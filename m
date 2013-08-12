Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64247 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3HLXfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:35:25 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so3790763eek.16
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:35:23 -0700 (PDT)
Message-ID: <1376350516.13046.6.camel@canaries32-MCP7A> (sfid-20130813_013529_022009_E3610B14)
Subject: Re: [PATCH 1/3] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Aug 2013 00:35:16 +0100
In-Reply-To: <20130812230936.GA31302@kroah.com>
References: <1375733094.7004.23.camel@canaries64>
	 <20130812215959.GA1473@kroah.com>
	 <1376348835.12399.15.camel@canaries32-MCP7A>
	 <20130812230936.GA31302@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-12 at 16:09 -0700, Greg KH wrote:
> On Tue, Aug 13, 2013 at 12:07:15AM +0100, Malcolm Priestley wrote:
> > On Mon, 2013-08-12 at 14:59 -0700, Greg KH wrote:
> > > On Mon, Aug 05, 2013 at 09:04:54PM +0100, Malcolm Priestley wrote:
> > > > All structure members of BEACON_BUFFER/TX_BUFFER should be packed.
> > > 
> > > Why?
> > 
> > Only the first 4 members of these structures are live.
> > 
> > The forth member is referenced at run-time by packed structures.
> > typedef struct tagSTxBufHead
> > typedef struct tagSTxShortBufHead
> > in desc.h
> > 
> > If these structures are not packed the alignment of these members
> > will be wrong.
> 
> Then say all of this in the patch please :)
> 
> > > 
> > > What happens if they are not?
> > The driver does not work.
> 
> How is it working today without this change?
Well for *me* it works.

It appears the structure is packed anyway.

But is this guaranteed?

Anyway, do you want me to resend the patch.



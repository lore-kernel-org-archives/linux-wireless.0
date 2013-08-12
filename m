Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3HLXJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:09:38 -0400
Date: Mon, 12 Aug 2013 16:09:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
Message-ID: <20130812230936.GA31302@kroah.com> (sfid-20130813_010941_420338_379E14D7)
References: <1375733094.7004.23.camel@canaries64>
 <20130812215959.GA1473@kroah.com>
 <1376348835.12399.15.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376348835.12399.15.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 13, 2013 at 12:07:15AM +0100, Malcolm Priestley wrote:
> On Mon, 2013-08-12 at 14:59 -0700, Greg KH wrote:
> > On Mon, Aug 05, 2013 at 09:04:54PM +0100, Malcolm Priestley wrote:
> > > All structure members of BEACON_BUFFER/TX_BUFFER should be packed.
> > 
> > Why?
> 
> Only the first 4 members of these structures are live.
> 
> The forth member is referenced at run-time by packed structures.
> typedef struct tagSTxBufHead
> typedef struct tagSTxShortBufHead
> in desc.h
> 
> If these structures are not packed the alignment of these members
> will be wrong.

Then say all of this in the patch please :)

> > 
> > What happens if they are not?
> The driver does not work.

How is it working today without this change?

thanks,

greg k-h

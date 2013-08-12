Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:48647 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3HLXHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:07:24 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so3761391eak.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:07:23 -0700 (PDT)
Message-ID: <1376348835.12399.15.camel@canaries32-MCP7A> (sfid-20130813_010727_339143_C51722A7)
Subject: Re: [PATCH 1/3] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Aug 2013 00:07:15 +0100
In-Reply-To: <20130812215959.GA1473@kroah.com>
References: <1375733094.7004.23.camel@canaries64>
	 <20130812215959.GA1473@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-12 at 14:59 -0700, Greg KH wrote:
> On Mon, Aug 05, 2013 at 09:04:54PM +0100, Malcolm Priestley wrote:
> > All structure members of BEACON_BUFFER/TX_BUFFER should be packed.
> 
> Why?

Only the first 4 members of these structures are live.

The forth member is referenced at run-time by packed structures.
typedef struct tagSTxBufHead
typedef struct tagSTxShortBufHead
in desc.h

If these structures are not packed the alignment of these members
will be wrong.

> 
> What happens if they are not?
The driver does not work.

Regards


Malcolm




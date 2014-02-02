Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:52027 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaBBVwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 16:52:05 -0500
Date: Mon, 3 Feb 2014 08:51:41 +1100
From: James Cameron <quozl@laptop.org>
To: Andrew Wiley <wiley.andrew.j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Fwd: mwifiex and SD8787: How to create AP interface?
Message-ID: <20140202215141.GL30112@us.netrek.org> (sfid-20140202_225209_723954_53EF8E07)
References: <CAAUTuq83oJJ02tMpT6sK4krkwNFEVZYuzfvsTtRoUX=fVYT9-w@mail.gmail.com>
 <CAJwzM1=0xBkQ0cw-T+zMcAHSZVJsJ7vJmK6O9eisqttn_qGyMA@mail.gmail.com>
 <CAAUTuq--5EUYgKb1Bg9UWZnDAZRqcPZFd=GRVEo-YKictJJWwg@mail.gmail.com>
 <CAAUTuq-O1BFBmJfYe2xuRfLmNDNKY=V9CkMCM-QCq1iujE3n2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAUTuq-O1BFBmJfYe2xuRfLmNDNKY=V9CkMCM-QCq1iujE3n2w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 01, 2014 at 11:01:02PM -0600, Andrew Wiley wrote:
> Hello Avinash,
> 
> Thanks! That works for me. Would it be possible to add this to the
> mwifiex page on wireless.kernel.org? As far as I know, this command is
> completely undocumented within iw, and I know I'm not the only
> Dreamplug owner experiencing this problem.
> 
> As for other issues, I'm seeing a hang in the TX queue on the device
> after running an AP for a while, but I'm still gathering information
> on that. I'll follow up with another thread.

I've also seen hangs, in both RX and TX, but mostly RX.

The response to failing to alloc an skb is a bit weak in mwifiex, we
noted this on OLPC XO-4 with the 8787.  You can see more about the
problem and some local fixes in our private branch:

http://dev.laptop.org/git/olpc-kernel/log/?h=arm-3.5

http://dev.laptop.org/ticket/12694 (kernel 3.5)

I did backport the latest mwifiex at the time, but it did not fix the
issue, so I dug into it more.

-- 
James Cameron
http://quozl.linux.org.au/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm12-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.246]:44113
	"HELO nm12-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750812Ab2F2H4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 03:56:16 -0400
From: Schrober <franzschrober@yahoo.de>
To: thomas <thomas@net.t-labs.tu-berlin.de>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org
Subject: Re: [PATCH] mac80211: correct size the argument to kzalloc in minstrel_ht
Date: Fri, 29 Jun 2012 09:50:57 +0200
Message-ID: <1487602.AtWAA39W7Q@bentobox> (sfid-20120629_095620_422030_E0CE5303)
In-Reply-To: <4FED3679.4080107@net.t-labs.tu-berlin.de>
References: <1340926085-54416-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAGRGNgXCoQNYbs7MVtEsDdoPUgvV+JDP28tCbKWG2cBHcJ60kQ@mail.gmail.com> <4FED3679.4080107@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 June 2012 22:00:41 thomas wrote:
> Hi Julian,
> 
> Compiler wise both of our suggestions will lead to the same machine code.
> So beside the matter of taste, I just followed the other overall usage
> pattern of kzalloc in minstrel_ht.
> And it seems to be explicitly using the struct type.

http://lxr.linux.no/linux/Documentation/CodingStyle

                Chapter 14: Allocating memory

The kernel provides the following general purpose memory allocators:
kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
the API documentation for further information about them.

The preferred form for passing a size of a struct is the following:

        p = kmalloc(sizeof(*p), ...);

The alternative form where struct name is spelled out hurts readability and
introduces an opportunity for a bug when the pointer variable type is changed
but the corresponding sizeof that is passed to a memory allocator is not.

Casting the return value which is a void pointer is redundant. The conversion
from void pointer to any other pointer type is guaranteed by the C programming
language.
-- 
Franz Schrober

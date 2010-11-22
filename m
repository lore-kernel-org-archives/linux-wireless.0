Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33794 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0KVToq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 14:44:46 -0500
Date: Mon, 22 Nov 2010 14:30:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-11-22
Message-ID: <20101122193029.GE2117@tuxdriver.com>
References: <20101122181411.GD23109@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101122181411.GD23109@vigoh>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 04:14:11PM -0200, Gustavo F. Padovan wrote:
> Hi John,
> 
> Following batch is intended to 2.6.37, it includes a very trivial return
> err fix from myself and an remote name request fix from Johan Hedberg.
> This fix move the remote name request (during the connection creation
> process) to the kernelspace. In addition we have removed this operation
> from BlueZ in userspace. Quoting part of Johan's patch which already
> explain the change:
> 
>    "So far userspace has been responsible for this extra name request but
>     tighter control is needed in order not to flood Bluetooth controllers
>     with two many commands during connection creation. It has been shown
>     that some controllers simply fail to function correctly if they get too
>     many (almost) simultaneous commands during connection creation. The
>     simplest way to acheive better control of these commands is to move
>     their sending completely to the kernel side."
> 
> As side effect, we have a clean up patch in preparation to this fix.
> 
> Please pull, or let me know any problems you find here. Thanks.

The return code fix seems reasonable -- small and obvious, etc.

The other fixes are larger than I would like to see.  What is the
effect of the bug?  Does the Bluetooth controller stop completely?
Does it cause a crash?

Is this a newly-introduced bug?  Or one that has been around for
a while?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

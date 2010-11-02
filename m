Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45482 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0KBIai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 04:30:38 -0400
Date: Tue, 2 Nov 2010 09:30:35 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] mwl8k: choose proper firmware image as directed by user
Message-ID: <20101102083035.GM1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1288659351-22313-6-git-send-email-brian@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288659351-22313-6-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 01, 2010 at 05:55:50PM -0700, Brian Cavagnolo wrote:

> The mwl8k can operate in AP or STA mode, depending on the
> firmware image that is loaded.  Allow the user to specify
> the desired firmware image at module load time.

Strong NAK on selecting firmware image type with a module parameter,
that's so wrong it's not even funny.

Just use the STA image before ->add_interface() has been called if
it is available.

And please switch to async firmware loading while you're at it.


> Also, the firmware image can be swapped to meet the user's
> add_interface request.  For example, suppose the STA
> firmware is loaded, no STA interface has been added, and the
> user adds an AP interface.  In this case, the AP firmware
> will be loaded to meet the request.
> 
> Based on a patch from Pradeep Nemavat <pnemavat@marvell.com>

Which was suggested by Lennert Buytenhek -- please give credit where
it is due.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:38987 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0KBI6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 04:58:00 -0400
Date: Tue, 2 Nov 2010 09:57:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 4/7] mwl8k: force AP mode to use non-AMPDU frames
Message-ID: <20101102085758.GQ1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1288659351-22313-4-git-send-email-brian@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288659351-22313-4-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 01, 2010 at 05:55:48PM -0700, Brian Cavagnolo wrote:

> From: Nishant Sarmukadam <nishants@marvell.com>
> 
> AP firmware uses xmitcontrol to differentiate between AMPDU
> and non-AMPDU frames. As the support for AMPDU is not yet
> added, set xmitcontrol to non-AMPDU for all tx frames for AP
> firmware. This field will be set to indicate ampdu/non-ampdu
> frames when tx AMPDU support is added.
> 
> Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>

It's still pretty dumb of the firmware to require that the driver tell
the firmware _again_ (it already has that info) whether a TX packet is
part of an AMPDU session or not, but I guess this requirement is set in
stone now.

I'm still not happy that it just does this blindly based on whether
the image is an AP firmware image or not (earlier AP images did not
require this).

Ideally they'd just replace the firmware people by ones that have
some taste, but that probably won't happen.

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44257 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2ICT5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 15:57:00 -0400
Date: Mon, 3 Sep 2012 21:57:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bogus memcpy in brcm80211 ai_detach
Message-ID: <20120903195700.GZ16230@one.firstfloor.org> (sfid-20120903_215705_729381_B5630719)
References: <20120903191335.GW16230@one.firstfloor.org> <50450388.6040506@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50450388.6040506@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 03, 2012 at 02:22:48PM -0500, Larry Finger wrote:
> On 09/03/2012 02:13 PM, Andi Kleen wrote:
> >gcc 4.8 warns for this memcpy. While the copy size is correct, the whole
> >copy seems to be a nop because the destination is never used, and
> >there's no need to use memcpy to copy pointers anyways. And the
> >type of the pointer was wrong, but at least those are always the same.
> >
> >Just remove it.
> 
> Andi,
> 
> Have you compiled all of wireless with gcc 4.8? If so, can I assume that 
> you will report warnings for other drivers?

I did 64bit allyesconfig with LTO yes.  wireless has very few warnings overall,
compared to many other subsystems.

I found one other issue in it for which I'm sending a patch.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

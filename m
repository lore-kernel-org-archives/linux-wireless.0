Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36756 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbXLJSR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 13:17:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/T V2] b43: Fix rfkill radio LED
Date: Mon, 10 Dec 2007 19:16:14 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <475d7609.nURYtfeh6HSdh0Nd%Larry.Finger@lwfinger.net>
In-Reply-To: <475d7609.nURYtfeh6HSdh0Nd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200712101916.14311.mb@bu3sch.de> (sfid-20071210_181802_288865_9E5EC528)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007 18:23:21 Larry Finger wrote:
> This version of the rfkill switch patch is pretty straight forward. Please
> comment on the dropping of wl->mutex before rfkill initialization. This is
> the only way I could avoid the circular locking without a much earlier
> rfkill initialization.

I think that's not acceptable, as it introduces a nasty (although unlikely)
race condition with the band switch. I will think about it and will fix
it myself then. If there's no way to properly fix it, I think it may also
be OK to live with this damn unlikely race.

Please also add the call to request_module() into the rfkill init and test
if it works properly. After that, please send the complete patch back to me
and I will try to fix the locking issue.

Anyway, this patch looks nice. Good work.

-- 
Greetings Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51436 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbXLJTW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 14:22:27 -0500
Message-ID: <475D91EE.6050909@lwfinger.net> (sfid-20071210_192230_206365_B2EF8AD6)
Date: Mon, 10 Dec 2007 11:22:22 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T V2] b43: Fix rfkill radio LED
References: <475d7609.nURYtfeh6HSdh0Nd%Larry.Finger@lwfinger.net> <200712101916.14311.mb@bu3sch.de>
In-Reply-To: <200712101916.14311.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> I think that's not acceptable, as it introduces a nasty (although unlikely)
> race condition with the band switch. I will think about it and will fix
> it myself then. If there's no way to properly fix it, I think it may also
> be OK to live with this damn unlikely race.
> 
> Please also add the call to request_module() into the rfkill init and test
> if it works properly. After that, please send the complete patch back to me
> and I will try to fix the locking issue.

The request_module() call is in the version I just sent you. If rfkill-input is a module, it loads
correctly. If the code is built-in or if the code was not built at al, it generates an error;
therefore, my error message is a little ambiguous. If I use the CONFIG variables, I could generate
really proper messages, but I decided to skip that part.

Larry


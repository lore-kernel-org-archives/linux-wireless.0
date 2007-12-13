Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57245 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLMLNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:13:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix rfkill radio LED
Date: Thu, 13 Dec 2007 12:11:47 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4760c3db.qCB1sy2b6EqODHqS%Larry.Finger@lwfinger.net>
In-Reply-To: <4760c3db.qCB1sy2b6EqODHqS%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712131211.47867.mb@bu3sch.de> (sfid-20071213_111345_422125_7B32025D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 December 2007 06:32:11 Larry Finger wrote:
> Michael,
> 
> I finally found the problem. It turned out that b43_rfkill_soft_toggle()
> was returning -EBUSY even when there was no error. I also changed the

Oh, damn. :)

> logic in the request_module("rfkill-input") section. Now, the code is

Ehm, no. Wait.
There was a
#ifdef CONFIG_RFKILL_INPUT_MODULE
That is only defined if rfkill-input is a module, right?

> only compiled if rfkill-input is not built-in.


-- 
Greetings Michael.

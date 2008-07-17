Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42521 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYGQE5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 00:57:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/4] rfkill: mutex fixes
Date: Thu, 17 Jul 2008 06:56:36 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216150327-10904-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807170656.37190.mb@bu3sch.de> (sfid-20080717_065725_223563_4D5256EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> There are two mutexes in rfkill:
> 
> rfkill->mutex, which protects some of the fields of a rfkill struct, and is
> also used for callback serialization.
> 
> rfkill_mutex, which protects the global state, the list of registered
> rfkill structs and rfkill->claim.
> 
> Make sure to use the correct mutex, and to not miss locking rfkill->mutex
> even when we already took rfkill_mutex.

Can't we rename the global rfkill_mutex?
I think the current situation is highly confusing.
Perhaps rfkill_global_mutex would be good enough. Maybe somebody has a better
idea, however.

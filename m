Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24322 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbZHCT6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:25 -0400
Subject: Re: [ath9k-devel] [PATCH 08/24] ath9k: pass only one argument to
 hw attach
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1249328027-24865-1-git-send-email-lrodriguez@atheros.com>
References: <1249328027-24865-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 15:58:23 -0400
Message-Id: <1249329503.5652.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-03 at 12:33 -0700, Luis R. Rodriguez wrote:
> The softc is cached and set within the ath_hw struct.

That's not meant to criticize this particular patch, but what's the
point in distinguishing sc from ah these days?  I believe "ah" used to
refer to the closed part of the sc structure that was only touched by
Atheros HAL, hence the name.

Since there is no HAL anymore, ah should disappear.

As the first step, ah should be allocated as part of sc.  Then ah and sc
should stop pointing to each other.  Instead, macros based on offsetof
should be used.  Then ah should be dissolved and replaced with sc
throughout the code.

That's probably a good task for an aspiring kernel hacker, as it
requires little specialized knowledge.

-- 
Regards,
Pavel Roskin

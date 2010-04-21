Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39342 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab0DUVzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 17:55:00 -0400
Subject: Re: [PATCH 1/2] ath9k_hw: make two initvals consto for the AR9001
 family
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1271802516-15195-2-git-send-email-lrodriguez@atheros.com>
References: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
	 <1271802516-15195-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 21 Apr 2010 17:54:57 -0400
Message-Id: <1271886897.6212.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-20 at 18:28 -0400, Luis R. Rodriguez wrote:
> This makes ar5416Addac_9160 and ar5416Addac_9160 const
> I guess we skipped them long ago.

It's a step in the right direction, but it makes the code more
misleading.  Those arrays are not constant.

Please see ath9k_hw_def_set_addac() and ath9k_hw_4k_set_addac().  They
both modify ah->iniAddac for AR9160.

The compiler doesn't warn about it because the definition of
INIT_INI_ARRAY uses a cast that removes the const modifier.

It's not an objection against the patch, it's just a reminder that we
have a real problem with the code that is likely to affect parallel
operation of more than one AR9160 device in the system, especially if
they are working on different channels.

-- 
Regards,
Pavel Roskin

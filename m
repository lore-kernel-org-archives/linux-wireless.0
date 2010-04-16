Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36244 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab0DPWBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 18:01:01 -0400
Subject: Re: [PATCH v3 42/97] ath9k: Make bf_desc of ath_buf opaque
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1271367582-992-43-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
	 <1271367582-992-43-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 18:00:59 -0400
Message-Id: <1271455259.16507.43.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-15 at 17:38 -0400, Luis R. Rodriguez wrote:
> From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

> -	struct ath_desc *bf_desc;	/* virtual addr of desc */
> +	void *bf_desc;			/* virtual addr of desc */

Why?

The obvious downside is that bf_desc becomes compatible with pointers of
any type.

The only upside I can think of is that bf_desc won't be dereferenced by
accident.  The same could be done by using a scalar type or
__attribute__((noderef)).

I believe the downside outweighs the upside in absence of any
explanation.

-- 
Regards,
Pavel Roskin

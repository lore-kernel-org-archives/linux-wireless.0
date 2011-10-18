Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1JRUUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 16:20:07 -0400
Date: Tue, 18 Oct 2011 16:19:48 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath9k_hw: min_t() casts u32 to int
Message-ID: <20111018161948.2552f995@mj> (sfid-20111018_222014_862738_A2157274)
In-Reply-To: <20111017072823.GA7812@elgon.mountain>
References: <20111017072823.GA7812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 17 Oct 2011 10:28:23 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The code here treats very large values of "limit" as less than
> MAX_POWER_RATE because of the cast to int.  We should do the compare
> as u32 instead.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Pavel Roskin <proski@gnu.org>

I don't think it can actually happen.  ath9k_hw_set_txpowerlimit() is
called twice.  In one case, limit is MAX_RATE_POWER, in another case,
it's an argument of type u16.  Still, it's better not to have the code
that looks wrong.

ath9k_cmn_update_txpow() also has code that _looks_ wrong.  *txpower is
not assigned a value if the new power happens to be equal to the
current one.  Also, the second argument (cur_txpow) is not used.
Returning a value by a pointer seems unnecessary if the function returns
void.  It could simply return the new tx power.  I'll submit a patch
shortly.

-- 
Regards,
Pavel Roskin

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711933F59A;
	Thu,  1 Oct 2026 23:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790897483; cv=none; b=DaCzCug3Zbxwhok0hH/6t+tp1mSkuhqDo6CYtwMykSDOqxXJomtsZgjJe++xFvF3OPc0LFb90OL8uO5wViIbbc/Xi67x6uNUiILvQQwsx3t5bfeKneNyBZ3+jYZy9As7FEk3JD4TcyGlzWxNkYugQM23UrxuQ180hU2/GloBiNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790897483; c=relaxed/simple;
	bh=W5YOirmr4qxUqSN0DnUVxW7zZ+ftLFN/mEDLTHGnI2c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nToD5mNgoe9VLVln/TK2YZRkayNG/HvX2LlNi9uY95gunlG19c5G2gd7rOH4v2pqHW+gYaAfHyL+e0NCpE1/p+UUckAH1XYrcDLwsXUDeIQRnqQoDVv3/gWesG0SU+TRlREpYX7rQiMw5FsvDhyysta0SRuzH1Pdu+CQu/eutrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AET00+iQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AET00+iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBED91F00893;
	Thu,  1 Oct 2026 23:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790897481;
	bh=idAHKkXnLURpjbiHDs0kTCjxoIpGo2/xsZf0a5a44eY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AET00+iQn6fL31Ji8qr61nNGqtMEr9jrA4zZlprGpXbWizdWj6Ge2SxPpSXT7Bqn7
	 tblNrhpDWNJhXjXgO4m7kt8Kd1I3gxVLEKl38zUYyqjdhEZrSd9sJUW5v+jl0hq11j
	 D/5sw+79WBQmoH6Ff06Nn1zGvd4p1PNYIgHEs+AXBad6JtERXpKjv2U8Kbyr9TivN0
	 wM38TRzendJn/0t7d188FpoWLxPLeG2UW/uRXwVL8vwwNT5lS2SwoMb951eerYfjcs
	 kXgFBq5VmlLiCUhN5YzACibgVIsuxiZIKmjYT8yYyPA8yxMugrM1w++e36WukAfqSJ
	 MGeP3ZRby7hYg==
Subject: Re: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count
 through helpers
From: netdev-bot+sashiko@kernel.org
To: sigefriedhyy@gmail.com
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com,
 andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net,
 dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com,
 idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org,
 johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com,
 kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com,
 pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org,
 sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 01 Oct 2026 23:31:19 +0000
Message-ID: <179089747937.434549.16341143363097629528@kernel.org>
In-Reply-To: <20260930112842.21323-3-sigefriedhyy@gmail.com>
References: <20260930112842.21323-3-sigefriedhyy@gmail.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In the commit "net: change netdev_hw_addr_list count through
  helpers", a new comment on struct netdev_hw_addr_list::_count in…

--

net: change netdev_hw_addr_list count through helpers

This patch adds __hw_addr_count_add(), __hw_addr_count_inc(),
__hw_addr_count_dec() and __hw_addr_count_reset() to
net/core/dev_addr_lists.c and uses them for changes to the list count. It
also renames netdev_hw_addr_list.count to _count so that direct writes
stand out. Drivers, mac80211 and the kunit tests that read the field
directly now use the count helpers. This prepares for a later patch that
accounts every change to dev->mc.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d037faff7c44b..97dc053f234cc 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -252,13 +252,14 @@ struct netdev_hw_addr {
>  
>  struct netdev_hw_addr_list {
>  	struct list_head	list;
> -	int			count;
> +	/* Only changed through the __hw_addr_count_* helpers */
> +	int			_count;

[ ... ]

> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 08528ca0a8b31..23f5db99a702d 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c

[ ... ]

> @@ -492,14 +512,14 @@ void __hw_addr_flush(struct netdev_hw_addr_list *list)

[ ... ]

>  void __hw_addr_init(struct netdev_hw_addr_list *list)
>  {
>  	INIT_LIST_HEAD(&list->list);
> -	list->count = 0;
> +	list->_count = 0;

[Severity: Low]
This isn't a bug, but the new comment in struct netdev_hw_addr_list says
_count is "Only changed through the __hw_addr_count_* helpers". However,
__hw_addr_init() still writes it directly, and the write is still there at
the end of the series.

Could the comment name initialization as an exception? For example:

    /* Only changed through the __hw_addr_count_* helpers after
     * __hw_addr_init()
     */

This has no functional effect on the later dev->mc generation counter
patch. dev_mc_init() calls __hw_addr_init() only from alloc_netdev_mqs(),
on a freshly zeroed device, and dev->mc.owner is set only after that call.
Also, by the end of the series __hw_addr_init() sets list->owner = NULL.
So __hw_addr_changed() would do nothing here even if a helper were used.

A related point: the commit message says readers keep using
netdev_hw_addr_list_count(), but two places in this file still read the
raw field:

__hw_addr_splice():
	__hw_addr_count_add(dst, src->_count);

__hw_addr_list_snapshot():
		if (cache->_count) {

Should these use netdev_hw_addr_list_count() too, so they follow the
reader convention in the commit message?

>  	list->tree = RB_ROOT;
>  }
>  EXPORT_SYMBOL(__hw_addr_init);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930112842.21323-1-sigefriedhyy%40gmail.com

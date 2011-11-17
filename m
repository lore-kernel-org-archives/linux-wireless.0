Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQW1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:27:18 -0500
Subject: Re: [PATCH 2/3] compat: backport kfree_rcu()
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1321564991-7249-2-git-send-email-hauke@hauke-m.de>
References: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>
	 <1321564991-7249-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 23:27:16 +0100
Message-ID: <1321568836.3997.53.camel@jlt3.sipsolutions.net> (sfid-20111117_232721_760191_EA202A7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 22:23 +0100, Hauke Mehrtens wrote:

> +#undef module_exit
> +#define module_exit(exitfn)						\

> +	static inline exitcall_t __exittest(void)			\
> +	{ return exitfn; }						\

This is not necessary since the exitfn() below will already create a
compile error if you try module_exit(no_such_function).

> +	void __exit __exit_compat(void)					\
> +	{								\

Shouldn't that be static?

johannes



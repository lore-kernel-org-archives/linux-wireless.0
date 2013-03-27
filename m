Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3C0KGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 06:06:30 -0400
Date: Wed, 27 Mar 2013 11:07:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Colin King <colin.king@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: 4965-rs: avoid null pointer dereference error
Message-ID: <20130327100712.GA1595@redhat.com> (sfid-20130327_110634_528975_69C69402)
References: <1364319323-14272-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364319323-14272-1-git-send-email-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 26, 2013 at 05:35:23PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> il4965_rs_initialize_lq checks to see if sta is null, however, before that
> check il4965_rs_use_green dereferences sta when intializing use_green.
> Avoid a potential null pointer dereference error by only calling
> il4965_rs_use_green after we are sure sta is not null.
> 
> Smatch analysis:
> 
> drivers/net/wireless/iwlegacy/4965-rs.c:2160 il4965_rs_initialize_lq() warn:
>   variable dereferenced before check 'sta' (see line 2155)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

ACK


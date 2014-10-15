Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65187 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaJOUvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 16:51:10 -0400
MIME-Version: 1.0
In-Reply-To: <20141009095742.GA20875@mwanda>
References: <20141009095742.GA20875@mwanda>
Date: Wed, 15 Oct 2014 13:51:07 -0700
Message-ID: <CA++WF2NinL3_pGtqZxjr6p4BpHBkGRbBTXaXFNSdoxgzX_Lb=Q@mail.gmail.com> (sfid-20141015_225115_590385_A189B134)
Subject: Re: [patch 1/2] ipw2x00: remove unused ->ibss_dfs pointer
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan,

On 9 October 2014 02:57, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The ->ibss_dfs pointer is always allocated with a user controlled
> length.  This caused a static checker warning because what if the length
> was zero?  In that case, any dereference of ->ibss_dfs would lead to an
> Oops.
>
> It turns out that this isn't a problem because the ->ibss_dfs pointer is
> never used.  This patch deletes it along with all the related code.  In
> particular the entire libipw_network_reset() function can be removed.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks fine, thanks.

Stanislav.

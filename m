Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52738 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1D1Spt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 14:45:49 -0400
Date: Thu, 28 Apr 2011 14:34:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Lopez <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, javier@cozybit.com
Subject: Re: [PATCH v2] mac80211_hwsim driver support userspace frame tx/rx
Message-ID: <20110428183435.GB2511@tuxdriver.com> (sfid-20110428_204552_933607_14B3A647)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
 <1303500703-24157-1-git-send-email-jlopex@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303500703-24157-1-git-send-email-jlopex@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 22, 2011 at 09:31:43PM +0200, Javier Lopez wrote:
> This is an updated patch that solve the issues found in the previous 
> patch, it adds frame exchange capabilities with userspace to 
> mac80211_hwsim driver. Allowing user space applications to decide if a 
> frame should be dropped or not.
> 
> Frame exchange between kernel and userspace is done through a generic 
> netlink communication protocol, a new family called HWSIM is proposed 
> in order to communicate with userspace applications. This family 

> +static struct genl_family hwsim_genl_family = {
> +	.id = GENL_ID_GENERATE,
> +	.hdrsize = 0,
> +	.name = "HWSIM",
> +	.version = VERSION_NR,
> +	.maxattr = HWSIM_ATTR_MAX,
> +};

I don't have any big objections to this patch.  But I think that
"HWSIM" is not a very good name.  Most/all of the other genl_family
definitions seem to use a name specific to their function.  While
"HWSIM" is somewhat descriptive, it seems prone to confusion.  I would
prefer to see a name like "mac80211_hwsim".

John

P.S.  Sorry to "bikeshed" this...
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

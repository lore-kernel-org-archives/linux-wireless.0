Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:46294 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751820AbdEJXNA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 19:13:00 -0400
Message-ID: <1494457974.2028.3.camel@perches.com> (sfid-20170511_011345_730478_9FBB1DBE)
Subject: Re: [PATCH] libertas: Avoid reading past end of buffer
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 May 2017 16:12:54 -0700
In-Reply-To: <20170510192451.GA115771@beast>
References: <20170510192451.GA115771@beast>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-10 at 12:24 -0700, Kees Cook wrote:
> Using memcpy() from a string that is shorter than the length copied means
> the destination buffer is being filled with arbitrary data from the kernel
> rodata segment. 

another bit of trivia:

> diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
[]
> @@ -1170,17 +1170,11 @@ int lbs_mesh_ethtool_get_sset_count(struct net_device *dev, int sset)
[]
> +		memcpy(s, *mesh_stat_strings, sizeof(mesh_stat_strings));

That * isn't necessary.

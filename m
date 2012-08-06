Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53813 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFTGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:06:23 -0400
Received: by obbuo13 with SMTP id uo13so6282559obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344162581.4513.1.camel@jlt3.sipsolutions.net>
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net> <1344162581.4513.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 12:06:03 -0700
Message-ID: <CAB=NE6U8HiYaEem+LrULyvh+iL2t4OwUKwBJNqHeZEHQWSKaLA@mail.gmail.com> (sfid-20120806_210626_555069_2A09D4FC)
Subject: Re: [PATCH v2] compat: deal with backported codel
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some distro kernels (in particular the Debian 3.2.0-3
> kernel I'm running) backport codel already, so trying
> to backport it again causes issues. Protect the compat
> backport with #ifdef TCA_CODEL_MAX.
>
> Also link the flow_dissector code into the codel module
> which then won't be loaded on kernels that already have
> codel backported.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Neat, thanks, only one comment below:

> diff --git a/compat/flow_dissector.c b/compat/flow_dissector.c
> index 8affda0..7dd7ec1 100644
> --- a/compat/flow_dissector.c
> +++ b/compat/flow_dissector.c
> @@ -141,4 +141,3 @@ ipv6:
>
>         return true;
>  }
> -EXPORT_SYMBOL_GPL(skb_flow_dissect);

Why is this change required?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35014 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcE3FbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 01:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <637c25b980379d1a98d7c57cc247d49ef295cbc5.1464576022.git.kirtika.ruchandani@gmail.com>
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com> <637c25b980379d1a98d7c57cc247d49ef295cbc5.1464576022.git.kirtika.ruchandani@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 May 2016 15:30:59 +1000
Message-ID: <CAGRGNgX0B-Px5r4-Ad7f4B3Q6UrY=aGLn9g4Xd+=kJoXWt-_dQ@mail.gmail.com> (sfid-20160530_073124_244013_58D6B212)
Subject: Re: [PATCH v2 07/10] nl80211: Avoid multiple assignments on same line
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Mon, May 30, 2016 at 12:53 PM, Kirtika Ruchandani
<kirtika.ruchandani@gmail.com> wrote:
> This patch fixes the checkpatch.pl warning "multiple assignments
> should be avoided."
>
> Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

I'm not sure I agree with checkpatch here, but this looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index ad7cdce..6f8e2a7 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2603,7 +2603,8 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>
>         memset(&params, 0, sizeof(params));
>
> -       otype = ntype = dev->ieee80211_ptr->iftype;
> +       otype = dev->ieee80211_ptr->iftype;
> +       ntype = dev->ieee80211_ptr->iftype;
>
>         if (info->attrs[NL80211_ATTR_IFTYPE]) {
>                 ntype = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

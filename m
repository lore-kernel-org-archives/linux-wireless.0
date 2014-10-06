Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41625 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaJFO3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:29:31 -0400
Message-ID: <1412605769.3098.20.camel@jlt4.sipsolutions.net> (sfid-20141006_162933_962099_63144284)
Subject: Re: [PATCH v2] mac-hwsim:  support destroying radio by name.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 16:29:29 +0200
In-Reply-To: <1411685926-12869-1-git-send-email-greearb@candelatech.com> (sfid-20140926_005851_546550_F0277494)
References: <1411685926-12869-1-git-send-email-greearb@candelatech.com>
	 (sfid-20140926_005851_546550_F0277494)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-25 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It is not always convenient to have to know the device-id,
> so allow deleting by name as well.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2:  Protect against bad input.
> 
>  drivers/net/wireless/mac80211_hwsim.c | 22 +++++++++++++++++-----
>  drivers/net/wireless/mac80211_hwsim.h |  2 ++
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 43435c0..b755920 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2535,16 +2535,28 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  {
>  	struct mac80211_hwsim_data *data;
> -	int idx;
> +	int idx = -1;

you might have to make this an s64?


> + * @HWSIM_ATTR_RADIO_NAME: Name of radio, ie phy666

e.g., not i.e.

johannes



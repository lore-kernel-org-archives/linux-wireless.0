Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33542 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760854AbdAIMgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 07:36:43 -0500
Received: by mail-pf0-f170.google.com with SMTP id y143so9969746pfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 04:36:42 -0800 (PST)
Subject: Re: [PATCH] cfg80211: size various nl80211 messages correctly
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170109101042.23919-1-johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ec9fb205-91ca-9591-0b0b-92672d093395@broadcom.com> (sfid-20170109_133842_170363_449FFC78)
Date: Mon, 9 Jan 2017 13:36:38 +0100
MIME-Version: 1.0
In-Reply-To: <20170109101042.23919-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 9-1-2017 11:10, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Ilan reported that sometimes nl80211 messages weren't working if
> the frames being transported got very large, which was really a
> problem for userspace-to-kernel messages, but prompted me to look
> at the code.
> 
> Upon review, I found various places where variable-length data is
> transported in an nl80211 message but the message isn't allocated
> taking that into account. This shouldn't cause any problems since
> the frames aren't really that long, apart in one place where two
> (possibly very long frames) might not fit.
> 
> Fix all the places (that I found) that get variable length data
> from the driver and put it into a message to take the length of
> the variable data into account. The 100 there is just a safe
> constant for the remaining message overhead (it's usually around
> 50 for most messages.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 23692658fe98..f55b251e4b0d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -13249,7 +13249,7 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
>  	struct sk_buff *msg;
>  	void *hdr;
>  
> -	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	msg = nlmsg_new(100 + ie_len, GFP_KERNEL);

Don't you want the '100' to be a define?

Regards,
Arend

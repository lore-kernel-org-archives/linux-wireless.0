Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:25092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYFIUXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 16:23:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2250786wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 13:23:48 -0700 (PDT)
Subject: Re: [PATCHv2 7/8] mac80211: wme.c use new helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213039703.5974.72.camel@brick>
References: <1213039703.5974.72.camel@brick>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 13:23:46 -0700
Message-Id: <1213043026.5974.78.camel@brick> (sfid-20080609_222356_812541_CDA5DD4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 12:28 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  net/mac80211/wme.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index 14a9ff1..d8c2f96 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -105,11 +105,8 @@ static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
>  {
>  	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> -	unsigned short fc = le16_to_cpu(hdr->frame_control);
> -	int qos;
>  
> -	/* see if frame is data or non data frame */
> -	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
> +	if (!ieee80211_is_data(hdr->frame_control)) {

Sorry, I didn't refresh this patch to preserve the unlikely().

Let me know if you want a replacement.

Harvey


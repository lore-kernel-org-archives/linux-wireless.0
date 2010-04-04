Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57212 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0DDSHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 14:07:23 -0400
Message-ID: <4BB8D54F.7060906@openwrt.org>
Date: Sun, 04 Apr 2010 11:07:11 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type
 to be u16
References: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-04 3:12 AM, Max Filippov wrote:
> According to the current 802.11s draft mesh capability field
> is 16 bits wide.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  include/linux/ieee80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 1998495..910b4bc 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -604,7 +604,7 @@ struct ieee80211_meshconf_ie {
>  	u8 meshconf_synch;
>  	u8 meshconf_auth;
>  	u8 meshconf_form;
> -	u8 meshconf_cap;
> +	u16 meshconf_cap;
Shouldn't that be __le16? You probably also have to add le16_to_cpu in
the place that accesses this field, otherwise this introduces an endian bug.

- Felix

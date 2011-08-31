Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.234]:43678 "HELO
	nm6-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756378Ab1HaPvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 11:51:39 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Alexander Simon <an.alexsimon@googlemail.com>
Subject: Re: [PATCH v2 1/4] nl80211: Parse channel type attribute in an IBSS join request
Date: Wed, 31 Aug 2011 17:51:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <2053881.ENil2Dy3QM@alex-1>
In-Reply-To: <2053881.ENil2Dy3QM@alex-1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108311751.20806.lindner_marek@yahoo.de> (sfid-20110831_175143_169103_13754F30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 29, 2011 16:15:47 Alexander Simon wrote:
>         if (!ibss.channel ||
> +           ibss.channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
>             ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
> -           ibss.channel->flags & IEEE80211_CHAN_DISABLED)
> +           ibss.channel->flags & IEEE80211_CHAN_RADAR)
> +               return -EINVAL;

Do you mind elaborating why this patch removes the IEEE80211_CHAN_DISABLED 
check and adds the IEEE80211_CHAN_RADAR check instead ? Copy and paste error ?

Cheers,
Marek

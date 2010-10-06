Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40470 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab0JFSQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:16:03 -0400
Received: by qyk10 with SMTP id 10so4329712qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 11:16:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286388787-11342-2-git-send-email-zajec5@gmail.com>
References: <1286388787-11342-2-git-send-email-zajec5@gmail.com>
Date: Wed, 6 Oct 2010 20:15:59 +0200
Message-ID: <AANLkTikD1jj-LhzEmacJy6i_WGoe51AiFxbR7vqZhX=Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] b43: N-PHY: store current channel info in PHY common
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 października 2010 20:13 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> @@ -3568,8 +3572,8 @@ static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
>  static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
>                                      unsigned int new_channel)
>  {
> -       struct b43_phy_n *nphy = dev->phy.n;
> -       struct b43_chanspec chanspec;
> +       struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
> +       enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;

Ah, and as you can see I decided to get more raw data about new
channel there. This is because in case on N-PHY we have to know about
band freq (2/5 GHz) and band with (20/40 MHz) to do full channel
setup.

-- 
Rafał

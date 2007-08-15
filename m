Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51147
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760652AbXHOPBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:01:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 18/20] mac80211, drivers: remove reset callback
Date: Wed, 15 Aug 2007 17:00:21 +0200
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <20070815144920.135826000@sipsolutions.net> <20070815145049.384297000@sipsolutions.net>
In-Reply-To: <20070815145049.384297000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708151700.21821.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 15 August 2007 16:49:38 Johannes Berg wrote:
> -static int b43_dev_reset(struct ieee80211_hw *hw)
> -{
> -	struct b43_wl *wl = hw_to_b43_wl(hw);
> -	struct b43_wldev *dev;
> -	int err = -ENODEV;
> -
> -	mutex_lock(&wl->mutex);
> -	dev = wl->current_dev;
> -	if (dev) {
> -		b43_controller_restart(dev, "Reset by ieee80211 subsystem");
> -		err = 0;
> -	}
> -	mutex_unlock(&wl->mutex);
> -
> -	return 0;
> -}

Ack. This also fixes the bug here, that was on my todo list ;)

-- 
Greetings Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33178 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0ESRHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 13:07:46 -0400
Received: by pwi5 with SMTP id 5so1642083pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:07:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519013147.22206.71360.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk> <20100519013147.22206.71360.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 May 2010 10:07:25 -0700
Message-ID: <AANLkTikgyTZptw5CGu8MFinkqlXeqEJMJixdckb89aFc@mail.gmail.com>
Subject: Re: [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 18, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:

> + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
> + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.

This gets the job done, but that's it. The API defined allows for a
hugely loose implementation on each driver. Users could end up using
for ath5k:

iw dev wlan0 set_tx_antenna 1 # for AR5K_ANTMODE_FIXED_A
iw dev wlan0 set_tx_antenna 2 # for AR5K_ANTMODE_FIXED_B
iw dev wlan0 set_tx_antenna 3 # for AR5K_ANTMODE_DEFAULT

And yet for another driver it could be something completely different
in usersepace. I think it would be better for us to define a static
API for all legacy cards and another for 802.11n cards, or unify them
but to be very specific about the API for antenna settings/chainmask
settings.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaBZLKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 06:10:54 -0500
Message-ID: <1393413044.4133.6.camel@jlt4.sipsolutions.net> (sfid-20140226_121057_555440_242A153B)
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the
 network device
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Feb 2014 12:10:44 +0100
In-Reply-To: <530DC56E.9040202@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
				 <1393356639-19169-2-git-send-email-arend@broadcom.com>
				 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>
			 <530DAECD.8010405@broadcom.com>
		 <1393406278.4133.4.camel@jlt4.sipsolutions.net>
		 <530DB3BA.20106@broadcom.com>
	 <1393407473.4133.5.camel@jlt4.sipsolutions.net>
	 <530DC56E.9040202@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-26 at 11:43 +0100, Arend van Spriel wrote:

> Actually, this was not the reason for the doing the msleep(). The
> problem was that wpa_supplicant received RTM_DELLINK, before getting the
> NL08211_DISCONNECT. This resulted in RTM_DELLINK, immediately followed
> by RTM_ADDLINK, followed by NL80211_DISCONNECT.

I'm not sure this isn't still possible? I don't know when DELLINK is
sent.

johannes


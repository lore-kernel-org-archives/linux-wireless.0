Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:57484 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab3E0SWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 14:22:03 -0400
Date: Mon, 27 May 2013 21:11:12 +0300
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jithu Jance <jithu@broadcom.com>
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface option
Message-ID: <20130527181112.GA20210@w1.fi> (sfid-20130527_202207_207756_930923F0)
References: <51A09F43.5030004@broadcom.com>
 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
 <51A36603.7020403@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51A36603.7020403@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 27, 2013 at 03:56:19PM +0200, Arend van Spriel wrote:
> In this mac80211_hwsim is a special case. We could make P2P_DEVICE
> support in mac80211_hwsim optional using module parameter to allow
> testing both cases.

Yes, that would be helpful. I don't understand why my test setup moves
to using P2P Device by default when mac80211_hwsim is perfectly capable
of operating without that.. I have been thinking of applying the
wpa_supplicant changes in a way that would make them disabled by default
and use a runtime configuration parameter (e.g., driver_param to
driver_nl80211.c) to enable this functionality for now. This would allow
the patches to go in now and make it somewhat easier to test them.
Anyway, if mac80211_hwsim changes its default behavior, this would be of
lesser needed (well, once a new kernel release or compat-drivers gets
released).

In general, I don't think it is a good idea to change existing behavior
with a kernel or wpa_supplicant upgrade. It is obviously fine if this is
needed for the functionality to work in the first place, but that is not
the case with mac80211_hwsim.

-- 
Jouni Malinen                                            PGP id EFC895FA

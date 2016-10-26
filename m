Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54853 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754001AbcJZJXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:23:22 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8] mac80211: Claim Fast Initial Link Setup (FILS)
 support
Date: Wed, 26 Oct 2016 09:23:19 +0000
Message-ID: <20161026092315.GB3660@jouni.qca.qualcomm.com> (sfid-20161026_112333_113876_A479A953)
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
 <1477435489-8555-4-git-send-email-jouni@qca.qualcomm.com>
 <1477461036.4059.14.camel@sipsolutions.net>
In-Reply-To: <1477461036.4059.14.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 07:50:36AM +0200, Johannes Berg wrote:
> On Wed, 2016-10-26 at 01:44 +0300, Jouni Malinen wrote:
> > With the previous commits, initial FILS support is now functional in
> > mac80211-based drivers for both AP and stations roles.
>=20
> That's a bit misleading, I guess AP role is handled entirely in
> hostapd? You documented the extended feature bit to explicitly mean
> station role only :)

Yeah.. In case of mac80211, there was not really changes needed in the
kernel side for AP mode. That may be different with non-mac80211
drivers, though, since they might be easier to handle with the AES-SIV
operations for associations frames handled within the driver.

Would you prefer to split that NL80211_EXT_FEATURE_FILS into two
separate values (_STA and _AP) and have mac80211 advertise both? Or just
add a _STA only case for now and see what we need to do with
NL80211_ATTR_DEVICE_AP_SME cases separately once such a thing is in in
functional state?

--=20
Jouni Malinen                                            PGP id EFC895FA=

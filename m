Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51274 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752511AbdEJMaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 08:30:23 -0400
Date: Wed, 10 May 2017 15:24:58 +0300
From: Jouni Malinen <j@w1.fi>
To: mike@hellotwist.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet
 decode.
Message-ID: <20170510122458.GA4796@w1.fi> (sfid-20170510_143026_821027_254071E1)
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 09, 2017 at 02:16:31PM -0400, Michael Skeffington wrote:
> In order to allow wpa_supplicant to correctly identify a perceived WPA TKIP key
> recovery attack the michael MIC must be checked before the packet decode is
> attempted.  A packet with an invalid MIC will always fail a decrypt check which
> previously was being checked first.  Therefore the MIC failure bit of
> status flags
> describing the error would remain unset.

Which driver and WLAN hardware are you using? Michael MIC is encrypted,
so to be able to check that, the frame will obviously need to be
decrypted first. If that WEP decryption fails, this frame needs to be
dropped without indicating Michael MIC failure. WEP part here is
completely independent of Michael MIC.

It is possible that there is a driver that handles these steps in
hardware/firmware and if so, that driver may have a bug if you do not
see Michael MIC failures reported correctly. Anyway, as Johannes pointed
out, this part in mac80211 is in the correct sequence and that cannot be
changed since it would completely break TKIP for more or less all
software-based cases.

-- 
Jouni Malinen                                            PGP id EFC895FA

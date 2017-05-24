Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56268 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932941AbdEXSGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 14:06:45 -0400
Message-ID: <1495649200.20833.1.camel@sipsolutions.net> (sfid-20170524_200649_061750_A0F642A2)
Subject: Re: WPA and WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>, "Tobin C. Harding" <me@tobin.cc>,
        linux-wireless@vger.kernel.org
Date: Wed, 24 May 2017 20:06:40 +0200
In-Reply-To: <1495644240.12939.3.camel@redhat.com> (sfid-20170524_184417_597726_14DB4F2B)
References: <20170524072750.GI8158@eros> <20170524073459.GJ8158@eros>
         <1495644240.12939.3.camel@redhat.com>
         (sfid-20170524_184417_597726_14DB4F2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a small correction:

On Wed, 2017-05-24 at 11:44 -0500, Dan Williams wrote:
> 
> For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.

PTK and GTK, and in theory you could have more than two GTKs but that's
not usually done.

> Because WEXT is pretty convoluted, I woudn't necessarily try to
> translate what eg ks_wlan_set_encode_ext() is doing directly to
> cfg80211, but to understand how the firmware interface works and then
> just write the cfg80211 code to the firmware interface.
> 
> Basically, you have the following modes:
> 
> a) open, no encryption
> b) WEP encryption (4 possible WEP keys, each either 40 or 104 bits)
> c) WPA/RSN (PMK and GMK are computed by wpa_supplicant and supplied
> to you, just need to send to firmware)

Again, PTK/GTK :)

> And to answer Johannes, this firmware looks much more fullmac than
> softmac; BSS selection seems left up to the firmware.  You just send
> it a "connect with these parameters" command (HIF_INFRA_SET_REQ)
> including channels, SSID, BSSID, mode, etc and it does everything.

Yeah. Makes sense then.

johannes

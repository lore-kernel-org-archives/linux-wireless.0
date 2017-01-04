Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968160AbdADPHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 10:07:13 -0500
Date: Wed, 4 Jan 2017 16:02:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Can't authenticate to WPA network with rt2800usb driver
Message-ID: <20170104150243.GA11582@redhat.com> (sfid-20170104_160716_383654_FD5E7F6B)
References: <1483526270.8560.70.camel@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1483526270.8560.70.camel@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 04, 2017 at 11:37:50AM +0100, Xavier Bestel wrote:
> Jan  4 11:22:29 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: SME: Trying to authenticate with 5c:33:8e:56:78:d3 (SSID='MySecretSSID' freq=2437 MHz) 
> Jan  4 11:22:29 pcxav kernel: [2921135.972360] wlx7cdd90463ef8: authenticate with 5c:33:8e:56:78:d3 
> Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3774] device (wlx7cdd90463ef8): supplicant interface state: inactive -> authenticating 
> Jan  4 11:22:29 pcxav kernel: [2921135.990588] wlx7cdd90463ef8: send auth to 5c:33:8e:56:78:d3 (try 1/3) 
> Jan  4 11:22:29 pcxav kernel: [2921135.999983] wlx7cdd90463ef8: authenticated 
> Jan  4 11:22:34 pcxav kernel: [2921140.991625] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 

This looks like problem when wpa_supplicant do not talk to correct
kernel socket when cfg80211 module was removed and then loaded again.
This can happen when you remove wireless device driver using
modprobe -r  i.e:

modprobe -r rt2800usb
modprobe rt2800pci

This problem is fixed in current version of wpa_supplicant or maybe
in kernel.

> Does anyone have a hint to make it work ?

"systemctl restart wpa_supplicant.service" recovers from bad state.

Stanislaw

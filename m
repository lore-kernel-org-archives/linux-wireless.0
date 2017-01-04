Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:53735 "EHLO
        smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754315AbdADQEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 11:04:46 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
        by smtpfb2-g21.free.fr (Postfix) with ESMTP id D3064D1B9BE
        for <linux-wireless@vger.kernel.org>; Wed,  4 Jan 2017 17:04:18 +0100 (CET)
Message-ID: <1483545757.8560.79.camel@free.fr> (sfid-20170104_170450_607753_DE94D5EA)
Subject: Re: Can't authenticate to WPA network with rt2800usb driver
From: Xavier Bestel <xavier.bestel@free.fr>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2017 17:02:37 +0100
In-Reply-To: <20170104150243.GA11582@redhat.com>
References: <1483526270.8560.70.camel@free.fr>
         <20170104150243.GA11582@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mercredi 04 janvier 2017 à 16:02 +0100, Stanislaw Gruszka a écrit :
> On Wed, Jan 04, 2017 at 11:37:50AM +0100, Xavier Bestel wrote:
> > Jan  4 11:22:29 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: SME: Trying to authenticate with 5c:33:8e:56:78:d3 (SSID='MySecretSSID' freq=2437 MHz) 
> > Jan  4 11:22:29 pcxav kernel: [2921135.972360] wlx7cdd90463ef8: authenticate with 5c:33:8e:56:78:d3 
> > Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3774] device (wlx7cdd90463ef8): supplicant interface state: inactive -> authenticating 
> > Jan  4 11:22:29 pcxav kernel: [2921135.990588] wlx7cdd90463ef8: send auth to 5c:33:8e:56:78:d3 (try 1/3) 
> > Jan  4 11:22:29 pcxav kernel: [2921135.999983] wlx7cdd90463ef8: authenticated 
> > Jan  4 11:22:34 pcxav kernel: [2921140.991625] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
> 
> This looks like problem when wpa_supplicant do not talk to correct
> kernel socket when cfg80211 module was removed and then loaded again.
> This can happen when you remove wireless device driver using
> modprobe -r  i.e:
> 
> modprobe -r rt2800usb
> modprobe rt2800pci
> 
> This problem is fixed in current version of wpa_supplicant or maybe
> in kernel.
> 
> > Does anyone have a hint to make it work ?
> 
> "systemctl restart wpa_supplicant.service" recovers from bad state.

I just upgraded wpa_supplicant from 2.5 to 2.6 (latest version AFAIK)
and restarted it but still no luck:
Jan  4 17:01:19 pcxav kernel: [2941466.617276] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
Do you know which kernel should I run to have the fix ?

Regards,
	Xav

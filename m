Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758126AbdAELBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:01:06 -0500
Date: Thu, 5 Jan 2017 11:56:37 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Can't authenticate to WPA network with rt2800usb driver
Message-ID: <20170105105636.GA15224@redhat.com> (sfid-20170105_120112_604324_E87BBCCE)
References: <1483526270.8560.70.camel@free.fr>
 <20170104150243.GA11582@redhat.com>
 <1483545757.8560.79.camel@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1483545757.8560.79.camel@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 04, 2017 at 05:02:37PM +0100, Xavier Bestel wrote:
> Le mercredi 04 janvier 2017 à 16:02 +0100, Stanislaw Gruszka a écrit :
> > On Wed, Jan 04, 2017 at 11:37:50AM +0100, Xavier Bestel wrote:
> > > Jan  4 11:22:29 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: SME: Trying to authenticate with 5c:33:8e:56:78:d3 (SSID='MySecretSSID' freq=2437 MHz) 
> > > Jan  4 11:22:29 pcxav kernel: [2921135.972360] wlx7cdd90463ef8: authenticate with 5c:33:8e:56:78:d3 
> > > Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3774] device (wlx7cdd90463ef8): supplicant interface state: inactive -> authenticating 
> > > Jan  4 11:22:29 pcxav kernel: [2921135.990588] wlx7cdd90463ef8: send auth to 5c:33:8e:56:78:d3 (try 1/3) 
> > > Jan  4 11:22:29 pcxav kernel: [2921135.999983] wlx7cdd90463ef8: authenticated 
> > > Jan  4 11:22:34 pcxav kernel: [2921140.991625] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
> > 
> > This looks like problem when wpa_supplicant do not talk to correct
> > kernel socket when cfg80211 module was removed and then loaded again.
> > This can happen when you remove wireless device driver using
> > modprobe -r  i.e:
> > 
> > modprobe -r rt2800usb
> > modprobe rt2800pci
> > 
> > This problem is fixed in current version of wpa_supplicant or maybe
> > in kernel.
> > 
> > > Does anyone have a hint to make it work ?
> > 
> > "systemctl restart wpa_supplicant.service" recovers from bad state.
> 
> I just upgraded wpa_supplicant from 2.5 to 2.6 (latest version AFAIK)
> and restarted it but still no luck:
> Jan  4 17:01:19 pcxav kernel: [2941466.617276] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
> Do you know which kernel should I run to have the fix ?

4.7 kernel and 2.5 supplicant works here. But if wpa_supplicant
restart do not fix the problem this is likely a different issue
than I describe. 

Stanislaw

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49642 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab3CSPlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 11:41:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UHyfE-0006ZF-HJ
	for linux-wireless@vger.kernel.org; Tue, 19 Mar 2013 16:41:24 +0100
Received: from 213.48.13.39 ([213.48.13.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 16:41:24 +0100
Received: from vishnu.kopparapu by 213.48.13.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 16:41:24 +0100
To: linux-wireless@vger.kernel.org
From: vishnu <vishnu.kopparapu@gmail.com>
Subject: Re: problem connecting to AP on new kernel (disassociating continuously after associating ) . Can some one please comment on the issue I am facing
Date: Tue, 19 Mar 2013 15:40:42 +0000 (UTC)
Message-ID: <loom.20130319T163402-330@post.gmane.org> (sfid-20130319_164109_792100_6AB4302E)
References: <loom.20130315T140953-940@post.gmane.org> <5144A184.1060900@iki.fi> <loom.20130318T191350-236@post.gmane.org> <51475D23.70108@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> On 03/18/2013 01:20 PM, vishnu wrote:
> >
> > Hello Jussi,
> >
> > I have applied the patch to kernel 3.7.8 and it doesn't fix my issue. I have
> > started testing the latest 3.9.0-rc2 version. I will let you know once I 
have
> > tested.
> 
> Please be aware that the patch is not in 3.9-rc2 from Linus's git tree (yet), 
> but it is in the wireless-testing git repo.
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hello Larry,

I have tried with 3.9-rc2 wireless-testing kernel and it is working fine . But 
it is taking around 10 to 15 minutes , until which it is continuously 
disassociating after association.  Is this behaviour expected? Please find the 
log if it is useful (Please discard the dates). This continuous for about 10 to 
15 minutes and finally it doesn't disassociate with the AP.


Feb 25 05:20:06 buildroot kern.info kernel: wlan0: RX AssocResp from 
00:17:3f:15:8f:55 (capab=0x411 status=0 aid=3)^M
wlan0: associated^M
Feb 25 05:20:06 buildroot kern.info kernel: wlan0: associated^M
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)^M
Feb 25 05:20:16 buildroot kern.info kernel: wlan0: deauthenticating from 
00:17:3f:15:8f:55 by local choice (reason=3)^M
cfg80211: Calling CRDA to update world regulatory domain^M
Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: All devices are 
disconnected, going to restore regulatory settings^M
Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: Restoring regulatory 
settings^M
Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: Kicking the queue^M
Feb 25 05:20:16 buildroot kern.info kernel: cfg80211: Calling CRDA to update 
world regulatory domain^M
wlan0: authenticate with 00:17:3f:15:8f:55^M
Feb 25 05:21:18 buildroot kern.info kernel: wlan0: authenticate with 
00:17:3f:15:8f:55^M
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
Feb 25 05:21:18 buildroot kern.info kerwlan0: authenticated^M
nel: wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
Feb 25 05:21:18 buildroot kern.info kernel: wlan0: authenticated^M
rtl8192cu 1-1:1.0 wlan0: disabling HT/VHT due to WEP/TKIP use^M
rtl8192cu 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP^M
Feb 25 05:21:18 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling 
HT/VHT due to WEP/TKIP use^M
rtl8192cu 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP^M
Feb 25 05:21:18 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling 
HT as WMM/QoS is not supported by the AP^M
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)^M
Feb 25 05:21:18 buildroot kern.info kernel: wlan0: associate with 
00:17:3f:15:8f:55 (try 1/3)^M
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=3)^M
Feb 25 05:21:18 buildroot kern.info kernel: wlan0: RX AssocResp from 
00:17:3f:15:8f:55 (capab=0x411 status=0 aidwlan0: associated^M
=3)^M
Feb 25 05:21:18 buildroot kern.info kernel: wlan0: associated^M
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)^M
Feb 25 05:21:28 buildroot kern.info kernel: wlan0: deauthenticating from 
00:17:3f:15:8f:55 by local choice (reason=3)^M
cfg80211: Calling CRDA to update world regulatory domain^M
Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: All devices are 
disconnected, going to restore regulatory settings^M
Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: Restoring regulatory 
settings^M
Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: Kicking the queue^M
Feb 25 05:21:28 buildroot kern.info kernel: cfg80211: Calling CRDA to update 
world regulatory domain^M
wlan0: authenticate with 00:17:3f:15:8f:55^M
Feb 25 05:22:30 buildroot kern.info kernel: wlan0: authenticate with 
00:17:3f:15:8f:55^M
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
Feb 25 05:22:30 buildroot kern.info kernel: wlan0: send auth to 
00:17:3f:15:8f:55 (trwlan0: authenticated^M
y 1/3)^M
Feb 25 05:22:30 buildroot kern.info kernel:rtl8192cu 1-1:1.0 wlan0: disabling 
HT/VHT due to WEP/TKIP use^M
 wlan0: authenticated^M
Feb 25 05:22:31 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling 
HT/VHT due to WEP/TKIP use^M
rtl8192cu 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP^M
Feb 25 05:22:31 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0rtl8192cu 1-
1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP^M
: disabling HT as WMM/QoS is not supported by the AP^M
Feb 25 05wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)^M
:22:31 buildroot kern.info kernwlan0: RX AssocResp from 00:17:3f:15:8f:55 
(capab=0x411 status=0 aid=3)^M
el: rtl8192cu 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the 
AP^M
Feb 25 05:22:31 buildroot kern.info kernel: wlan0: associate with 00:1wlan0: 
associated^M


Regards,
Vishnu.


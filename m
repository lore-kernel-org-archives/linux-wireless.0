Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48946 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0JBLcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:32:14 -0400
Received: by fxm14 with SMTP id 14so1067320fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 04:32:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Sat, 2 Oct 2010 13:32:09 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <AANLkTimmSaQsBdTLAjZT2_8sQ9V7r4OvAzGATr+bmOxG@mail.gmail.com> <AANLkTimXGQLnSaU6ASeRPkw1YThF18_zC7peu_uCeGKU@mail.gmail.com>
In-Reply-To: <AANLkTimXGQLnSaU6ASeRPkw1YThF18_zC7peu_uCeGKU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021332.09809.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 08:18:07 Saqeb Akhter wrote:
> I guess you were right about it being unstable - almost unusable for
> video streaming.
Video streaming? Does your application use QoS AC_VI(deo) for streaming,
or just bulk data (AC_BE(st effort))?

> sakhter@sakhter-laptop:~$ dmesg | grep Reason
> [ 1166.512087] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 1526.059997] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 2125.324356] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 2845.783011] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 3565.994832] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 5128.903576] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 5726.046230] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 6326.042938] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 6835.689445] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 7197.337060] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> 
> Seems to disconnect quite frequently. Even tried uninstalling networkmanager.
Reason 7 is: [AP received a] class 3 (data) frame from non-associated STA.
This can happen when your are "actively" disassociating from the AP (unlikely),
when the AP thinks you are out-of-reach(unlikely, since your signal seems to
be strong and PSM isn't enabled by default) or when the AP crashes and resets.

You should check your AP's TSF. (iw dev wlanX scan).
It should not go backwards.
(But if it does, then it might be because carl9170 has accidentally DoSed it?!)

Regards,
	Christian

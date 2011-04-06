Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab1DFPRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 11:17:02 -0400
Received: by bwz15 with SMTP id 15so1228128bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 08:17:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kimmo Huoso <kimmo.huoso@saunalahti.fi>
Subject: Re: 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB Adapter(rev.A) [Atheros AR9001U-(2)NG] Invalid misc and Tx excessive retries
Date: Wed, 6 Apr 2011 17:16:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <4D9B077E.3090106@saunalahti.fi> <201104061438.43678.chunkeey@googlemail.com> <4D9C764E.2040107@saunalahti.fi>
In-Reply-To: <4D9C764E.2040107@saunalahti.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104061716.43553.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 April 2011 16:18:54 Kimmo Huoso wrote:
> And for third even the softmac numbers/statistics might be 
> bogus, im still having problems with the driver while trying to run 
> programs that are strict for smooth connection like online games.
ah, that's why you are so concerned about excessive tx retries & invalid
misc numbers. Well, one of the worst enemy of programs that rely on low latency,
time-critical connection is "bufferbloat". However, by design 11n aggregation
needs to do a fair amount of additional caching & reordering so it's not
really suited for rt data anyway... Given that you have already ruled out your
router/AP and your environment, etc.. as a culprit, the good news is that
someone has already thought about this [QoS + the fact that aggregation is
not enabled for AC_VO]. The bad news is that ar9170's QoS [note: I'm talking
about the device and not the driver] does not work every well unless 11n is
completely disabled [module parameter noht=1 does that].

Regards,
	Chr

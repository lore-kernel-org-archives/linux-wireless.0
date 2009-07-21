Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:55074 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZGUL1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 07:27:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Howard Chu <hyc@highlandsun.com>
Subject: Re: ath9k rfkill behavior
Date: Tue, 21 Jul 2009 13:27:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <4A65122B.2040500@highlandsun.com>
In-Reply-To: <4A65122B.2040500@highlandsun.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907211327.03954.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 21 July 2009 02:56:11 Howard Chu wrote:
> I'm currently running 2.6.31-rc2 and noticed an annoying change in rfkill 
> behavior now; I can no longer toggle the state by echoing 0/1 into 
> sys/class/rfkill/rfkillX/state, it says write operation not permitted. I 
> haven't found any posts online related to this change in behavior, can anyone 
> point me to an explanation/rationale? The only way to change the state now 
> appears to be by using the wifi toggle switch on the laptop.

http://lkml.org/lkml/2009/7/10/339

but no need to patch the kernel (again):
the legacy iwconfig tool can let you do the same:

iwconfig wlanX txpower off
and if you want it back:
iwconfig wlanX txpower auto

(or there's a nice utility there: http://git.sipsolutions.net/?p=rfkill.git )

Regards,
	Chr

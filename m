Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56082 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0INRoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:44:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 10:44:15 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 14 Sep 2010 23:14:17 +0530
Subject: RE: [PATCH] ath9k_htc: Enable fastcc for HTC devices.
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C2@CHEXMB-01.global.atheros.com>
References: <1283497888-8294-1-git-send-email-rmanoharan@atheros.com>,<87zkvk5tyx.fsf@purkki.adurom.net>
In-Reply-To: <87zkvk5tyx.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanoharan@atheros.com> writes:
>
>> By enabling fastcc, the scan time reduced to half.
>
>It helps the users if a patch like this describes what fastcc really
>is and why it reduces the scan time. And what might be the side
>effects. This is valuable information especially when someone is
>debugging regressions. So please try to be as informative as possible,
>especially when enabling new features.
>
>For example, I have no idea what fastcc means. Fast C Compiler? ;)
>
>--
>Kalle Valo

On every channel set, the full hw reset happens which issue mutiple register writes.
For HTC devices, the host issue wmi commands. These register ops are time consumable one.
Instead of full hw reset, ath9k is doing partial reset which is fast channel change (fastcc).
By doing fast channel change, the scan period is considerably reduced. 

Thanks for your input Kalle. :)

Thanks,
Rajkumar

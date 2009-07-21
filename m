Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:34121 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbZGURVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 13:21:07 -0400
Message-ID: <4A65F901.7030803@highlandsun.com>
Date: Tue, 21 Jul 2009 10:21:05 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k rfkill behavior
References: <4A65122B.2040500@highlandsun.com> <200907211327.03954.chunkeey@web.de>
In-Reply-To: <200907211327.03954.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 21 July 2009 02:56:11 Howard Chu wrote:
>> I'm currently running 2.6.31-rc2 and noticed an annoying change in rfkill
>> behavior now; I can no longer toggle the state by echoing 0/1 into
>> sys/class/rfkill/rfkillX/state, it says write operation not permitted. I
>> haven't found any posts online related to this change in behavior, can anyone
>> point me to an explanation/rationale? The only way to change the state now
>> appears to be by using the wifi toggle switch on the laptop.
>
> http://lkml.org/lkml/2009/7/10/339
>
> but no need to patch the kernel (again):
> the legacy iwconfig tool can let you do the same:
>
> iwconfig wlanX txpower off
> and if you want it back:
> iwconfig wlanX txpower auto
>
> (or there's a nice utility there: http://git.sipsolutions.net/?p=rfkill.git )

Thanks very much, that covers everything.
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

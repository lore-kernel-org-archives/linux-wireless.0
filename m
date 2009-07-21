Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:60416 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZGUBYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 21:24:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.highlandsun.com (Postfix) with ESMTP id 4C72510F96
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 20:56:11 -0400 (EDT)
Message-ID: <4A65122B.2040500@highlandsun.com>
Date: Mon, 20 Jul 2009 17:56:11 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k rfkill behavior
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm currently running 2.6.31-rc2 and noticed an annoying change in rfkill 
behavior now; I can no longer toggle the state by echoing 0/1 into 
sys/class/rfkill/rfkillX/state, it says write operation not permitted. I 
haven't found any posts online related to this change in behavior, can anyone 
point me to an explanation/rationale? The only way to change the state now 
appears to be by using the wifi toggle switch on the laptop.

This is particularly obnoxious on recent HP Pavilion laptops, because there's 
a single button/LED and it affects both the bluetooth and the wifi 
transmitters. I never use bluetooth and I want that turned off, but I want to 
keep the wifi enabled. I used to be able to do this by explicitly echoing 0 
into the bluetooth rfkill/state but not any more. Even with the bluetooth 
software disabled, powertop shows it's still eating power+cycles on my USB 
controller unless I zero its rfkill state.

Also, when I press the toggle switch, the bluetooth device unregisters itself 
and disappears from the rfkill directory, while the wifi entry remains, but 
its state reads as "2" instead of 0 or 1. When it gets into this state, 
further toggling of the button doesn't reactivate it (though it continues to 
toggle the bluetooth on and off), and a reboot is required to re-enable the 
wifi. What is state "2" ?
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

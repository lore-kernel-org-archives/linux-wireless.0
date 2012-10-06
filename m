Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63107 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JFVoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 17:44:19 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so2135751wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2012 14:44:18 -0700 (PDT)
Message-ID: <5070A61B.6070903@googlemail.com> (sfid-20121006_234449_639593_5BBD64C8)
Date: Sat, 06 Oct 2012 23:43:55 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RT2500 and hard block
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello together!

I'm the owner of a 7 year old notebook with a RT2500 chipset. As I use 
the computer mostly stationary as a "desktop replacement" I'm normally 
using a wired network connection, but sometimes the connection to the 
router (using powerline) chokes up and I resort to a wireless 
connection. Now since some time I have the problem that I can't use my 
wireless connection anymore, because the wireless device is reported as 
hard blocked by the rfkill subsystem. Toggling the wireless button on 
the laptop does not change anything. So I googled around and hit this 
forum post https://bbs.archlinux.org/viewtopic.php?id=147906 . As I'm 
using ArchLinux with currently a 3.5 kernel as well I had the idea to 
check the changes that happened in the RT2500 drivers since the 
branching of 3.0.

I discovered the following two commits related to rfkill:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=a396e10019eaf3809b0219c966865aaafec12630
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=e2bc7c5f3cb8756865aa0ab140d2288f61599dda

I then downloaded the source of my current kernel version and checked 
what state my drivers are currently in. I already have the second 
change, so I decided to patch the first one in as well, but that didn't 
change anything. After that I simply reverted the second one (but kept 
the first one in) and after updating the modules my device was indeed no 
longer hard blocked! I was also able to initiate a wireless connection 
(though it isn't that stable, but that isn't something new sadly... :( 
). Using the hardware button now also correctly toggles the hard blocked 
state.

So now my question is: what could be the reason that I need to revert 
that second commit to get my device unblocked and what could be done to 
fix this without breaking some other devices in the progress?

If you answer, please CC me as I'm not subscribed to the list.

Regards,
Sven

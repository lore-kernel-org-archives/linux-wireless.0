Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34218 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1FNOTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 10:19:13 -0400
Received: by iyb14 with SMTP id 14so4703926iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 07:19:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Jun 2011 16:19:12 +0200
Message-ID: <BANLkTinuDZH_QHiZb+GKa39VNmWVrZfDkQ@mail.gmail.com> (sfid-20110614_161916_875136_2A11687F)
Subject: Makefile deleting previous install when two WiFi interfaces are from
 the same chip vendor
From: ch wp4 <cohomewp4@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am facing an issue during installation of an external USB-WiFi stick
on my Linux box (Ubuntu 10.04).
Actually, I have already successfully compiled and installed ath9k
driver using compat-wireless-2.6.38.2-2.
The internal WiFi NIC is fully operational.
Now, I want to add temporarily an external USB-WiFi stick (D-Link DWA
160). I've found that this hardware
is using an ar9170 chipset and therefore I've recompiled
compat-wireless targeting now the carl9170 driver.
Once again, this working perfectly.
But when I switch-off and back on my PC, only the latest installed
WiFi interface is working.

Digging into the system, I've found that ath9k has disappeared from the
/lib/modules/2.6.32-27-generic/updates/drivers/net/wireless/ath directory.
It looks like the 'make install' command is doing some cleaning which
has, in my particular use case, an undesirable
side-effect.
Can someone point me to the line in the Makefile causing this problem
or is it the desired behaviour ?

Thanks for your help
Fred Plissonneau

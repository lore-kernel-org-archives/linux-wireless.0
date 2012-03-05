Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63454 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2CEIoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 03:44:55 -0500
Received: by vcqp1 with SMTP id p1so3160685vcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 00:44:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
Date: Mon, 5 Mar 2012 14:14:55 +0530
Message-ID: <CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com> (sfid-20120305_094459_605316_4BA21026)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

> echo 0x404c to which file in /sys/kernel/debug/ath9k ?

root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x404c > regidx
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c45
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c45

-> toggle the rfkill button, wifi off

root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c55
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k#
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c55
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c55

-> toggle the rfkill button, wifi ON

root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c45
root@shafi-laptop:/sys/kernel/debug/ieee80211/phy0/ath9k# cat regval
0x00000c45

please also see the dump of rfkill list, as i am external PCI card, my
card is only softblocked.

-- 
thanks,
shafi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1JHQwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 12:52:13 -0400
Received: by iakk32 with SMTP id k32so5467167iak.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 09:52:12 -0700 (PDT)
Message-ID: <4E907FB8.1040101@lwfinger.net> (sfid-20111008_185223_266586_3E5A2A7A)
Date: Sat, 08 Oct 2011 11:52:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Toddy <toddy@fishpost.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org>
In-Reply-To: <loom.20111008T181929-517@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2011 11:24 AM, Toddy wrote:
> Hello Larry,
>
> thanks for the quick reply! Yes I know this version is a bit older, but when I
> use the newest compat-wireless (eg.
> http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2011-10-07.tar.bz2)
> the driver loads but some features like monitor-mode and packet injection
> doesn't work. The listing of available networks (with airodump) doesn't work
> too. Usually I have 13 channels because I live in Germany but if I use the
> newest driver I have only 11 channels. But if I use the older compat-wireless
> package all works fine.

The difference between 11 and 13 channels depends on your CRDA settings. Do you 
have that package installed? Check the output of dmesg to see what domain is 
being set. If you have CRDA installed, then you can force the use of Germany in 
the domain by creating a file named /etc/modprobe.d/50-cfg80211.conf containing 
a single line with "options cfg80211 ieee80211_regdom=DE" (without the quote marks).

You can get a list of available networks using iwconfig or iw. I know those work.

As I do not test, support, nor condone packet injection, I cannot speak to it 
working on any driver.

Larry

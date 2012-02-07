Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45192 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2BGRW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 12:22:26 -0500
Received: by yenm8 with SMTP id m8so3116710yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 09:22:26 -0800 (PST)
Message-ID: <4F315DCE.4060704@lwfinger.net> (sfid-20120207_182229_889753_72A9DFA2)
Date: Tue, 07 Feb 2012 11:22:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: dganic@bmail.ru
CC: ali@internetdog.org, wlanfae@realtek.com,
	linux-wireless@vger.kernel.org
Subject: Re: drivers realtek rtl8191su [rtl8712 ]
References: <web-16212948@mail-be01.sovam.com> <20120207020837.GA29465@internetdog.org> <web-10842365@mail-be03.sovam.com>
In-Reply-To: <web-10842365@mail-be03.sovam.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 10:53 AM, dganic@bmail.ru wrote:
> Thank you Ali for your reply email. One can wonder why you continue to develop
> this driver, and still the most interesting place: (Maybe you can help me by
> passing this information in any other developer in a position to write the full
> realization of this driver? The average user like me, they are unlikely to be
> listen, and you as the developer will have to listen. Perhaps you have the
> opportunity to publish this information in the Linux kernel mailing list or
> linuxdrivers.org? or have any contacts who can I turn? itself does not implement
> realtek drivers for their devices under Linux?

Alexander,

I am not quite sure what you are asking, but let me explain the situation as I 
understand it.

There is a Linux driver for the RTL8191SU devices. It is in the staging sub-tree 
and is called r8712u. This driver has been available since kernel 2.6.37. It is 
stable, and handles the HT rates quite well. The one thing it does not do is 
work as an AP. It cannot be used with hostapd. The reason is that modern 
versions of hostapd use the features of mac80211 through the nl80211 interface, 
but r8712u has its own IEEE802.11 stack and does not implement mac80211.

The ultimate fix will be to rewrite the driver to utilize mac80211, which will 
be a major undertaking. It is on my TODO list, but it has low priority. Realtek 
does not plan to do that rewrite, thus it will be up to the community.

I hope this message helps you understand what is happening.

Larry

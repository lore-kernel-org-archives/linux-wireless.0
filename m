Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64374 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3CISYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 13:24:30 -0500
Received: by mail-ob0-f171.google.com with SMTP id x4so2201942obh.16
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 10:24:27 -0800 (PST)
Message-ID: <513B7E58.9000505@lwfinger.net> (sfid-20130309_192438_305249_E6F7C4B8)
Date: Sat, 09 Mar 2013 12:24:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <20130307192920.GB8668@Fea.lerya.net> <20130308215833.GA2829@Fea.lerya.net> <513A960B.2020304@lwfinger.net> <20130309113222.GA3009@Fea.lerya.net>
In-Reply-To: <20130309113222.GA3009@Fea.lerya.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2013 05:32 AM, Vincent Brillault wrote:
> Thanks for your email, please find my comments inline
>
> On Fri  8.Mar'13 at 19:53:15 -0600, Larry Finger wrote:
>> The firmware in all the cards that use the rtlwifi family of drivers its own
>> rate control. The drivers do not pay any attention to any rate-setting calls
>> from user space.
> Do you mean that those warnings are only cosmetic and I should not care
> about those ?

You can safely ignore them, but I wonder why I have not seen them. What is the 
configuration of your AP? Is it g or n?

>> I also see reason 7 disconnects; however, with NetworkManager, the network is
>> reconnects. If you are using ifup or similar method, it probably does not reconnect.
> It does reconnect, but some higher level daemon (e.g. openvpn) suffer
> from those disconnect/reconnect.

I have been doing tests on rtl8723ae for the past week, and I do not get those 
disconnects. Obviously, I need to find what differs between the two drivers in 
that respect. I suspect something in the rekeying part of TKIP.

Larry



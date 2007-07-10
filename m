Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:55540 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbXGJFV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 01:21:58 -0400
Message-ID: <4693176F.6070407@warmcat.com>
Date: Tue, 10 Jul 2007 06:21:51 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jorge_Luc=E1ngeli_Obes?= <t4m5yn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Monitor mode with RTL8187
References: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com>
In-Reply-To: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jorge Luc=E1ngeli Obes wrote:
> Hi all,
> I've come into possession of a RTL8187-based wireless USB adapter
> (Encore ENUWI-G2). I am trying the new RTL8187 driver in wireless-dev
> GIT. The question is: does this driver support monitor mode?
>=20
> tamsyn@rory:~$ sudo iwconfig wlan0 mode monitor
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Device or resource busy.
>=20
> Any clues? Please CC me as I'm not subscribed to the list. Thanks in
> advance.

mac80211 needs you to bring the interface down before changing the mode

ifconfig wlan0 down

Then after changing the mode, bring it up and set the channel.

-Andy
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

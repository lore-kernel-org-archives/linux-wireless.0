Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40085 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZLAWVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 17:21:50 -0500
Received: by yxe17 with SMTP id 17so5024848yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 14:21:57 -0800 (PST)
Message-ID: <4B159703.1060008@lwfinger.net>
Date: Tue, 01 Dec 2009 16:21:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: htl10@users.sourceforge.net, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187 warnings on suspend
References: <665313.63774.qm@web23102.mail.ird.yahoo.com> <200912011149.49427.herton@mandriva.com.br> <4B15785C.30603@lwfinger.net> <200912011926.52595.herton@mandriva.com.br>
In-Reply-To: <200912011926.52595.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2009 03:26 PM, Herton Ronaldo Krzesinski wrote:
> Em Ter 01 Dez 2009, às 18:11:08, Larry Finger escreveu:
>> On 12/01/2009 07:49 AM, Herton Ronaldo Krzesinski wrote:
>>> Michael Buesch reports that his rtl8187 gives warnings on suspend
>>> ("queueing ieee80211 work while going to suspend" warnings), as rtl8187
>>> can call ieee80211_queue_delayed_work after mac80211 is suspended.
>>>
>>> This change enhances rtl8187 led code so we can avoid queuing work after
>>> mac80211 is suspended: now we register a radio led and make additional
>>> checks to ensure led is off/on properly as mac80211 wants.
>>>
>>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>> ---
>>
>> NACK. After a few minutes of a rmmod/insmod infinite loop, I go a kernel
>> oops. I did not capture any of the details.
> 
> I can't reproduce here, can you get the oops? Currently I can't guess which is
> missing, I reviewed patch again and can't found anything which could cause the
> issue. Also how is your rmmod/insmod (with ifconfig up involved etc.)?

I'll try to reproduce the panic.

I'm using NetworkManager. As soon as it recognizes the creation of the
wlanX interface, it starts bringing the device up.

My loop is

modprobe -v rtl8187 ; sleep 1 ; modprobe rtl8187 ; echo -n "a" ; sleep 1

Larry


Larry

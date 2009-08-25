Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:43395 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbZHYDhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:37:33 -0400
Received: by pxi34 with SMTP id 34so5511341pxi.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 20:37:35 -0700 (PDT)
Message-ID: <4A935C2D.5010308@lwfinger.net>
Date: Mon, 24 Aug 2009 22:36:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
References: <622090.22128.qm@web23106.mail.ird.yahoo.com>
In-Reply-To: <622090.22128.qm@web23106.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Tue, 25/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>>> [PATCH] rtl8187: fix circular locking
>> (rtl8187_stop/rtl8187_work)
>>
>> This patch fixes the problem. You can add a Tested-by to
>> it.
> 
> Hmm, I am still wondering about why NM insists on if up'ing the device. I read bits of things and apparently hal is supposed to know the device is rfkill'ed and let NM know. But lshal is not listing the device as having an killswitch. I don't know how hal is supposed to work out that info though. 
> 
> also I noted that /sys/class/rfkill_backport/rfkill0/state goes from 1 to 2 when I slide the switch to the 'off' position. Some says it should be 0?
> Don't know if hal is affected by its being rfkill_backport (compat-wireless) rather than rfkill (stock vendor kernel). well, it should look there if it isn't :-).
> 
> It looks like it is a hal problem...

The interpretation is as follows:
0 - blocked by software such as 'rfkill block 1'
1 - unblocked
2 - blocked by hardware

Your state is doing exactly what I would expect. When NM brings the
device up, does the above state change? Does dmesg show anything?

Larry

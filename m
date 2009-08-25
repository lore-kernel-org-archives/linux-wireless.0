Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:49127 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZHYBbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 21:31:03 -0400
Received: by pxi34 with SMTP id 34so5461244pxi.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 18:31:05 -0700 (PDT)
Message-ID: <4A933E87.7030600@lwfinger.net>
Date: Mon, 24 Aug 2009 20:29:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
References: <200908220038.35564.herton@mandriva.com.br> <4A91F100.9040804@lwfinger.net> <200908241503.38020.herton@mandriva.com.br>
In-Reply-To: <200908241503.38020.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Dom 23 Ago 2009, às 22:46:40, Larry Finger escreveu:
>> Herton Ronaldo Krzesinski wrote:
>>> This change implements rfkill support for RTL8187B and RTL8187L devices,
>>> using new cfg80211 rfkill API.
>>>
>>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>> ---
>> I found a problem with this patch. When I issue an 'rfkill block 1'
>> command, I get the following circular locking warning:
> 
> Hmm, this is a issue that was already present before the rfkill patch, but
> seems with it, it became more likely to happen. Please try this patch:
> 
> [PATCH] rtl8187: fix circular locking (rtl8187_stop/rtl8187_work)

This patch fixes the problem. You can add a Tested-by to it.

Larry


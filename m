Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49224 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1JMCKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 22:10:33 -0400
Received: by ggnv2 with SMTP id v2so1311188ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 19:10:33 -0700 (PDT)
Message-ID: <4E964896.5050004@lwfinger.net> (sfid-20111013_041036_901522_FC7F1EA1)
Date: Wed, 12 Oct 2011 21:10:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	645055@bugs.debian.org,
	=?UTF-8?B?QW50b2luZSBCZWF1cHLDqQ==?= <anarcat@koumbit.org>
Subject: Re: Bug#645055: realtek 8188CE ad-hoc mode not supported
References: <20111012052940.17383.59248.reportbug@localhost>  <1318424918.4024.180.camel@deadeye> <87pqi2s0cg.fsf@marcos.anarcat.ath.cx>  <20111012160135.GK3366@decadent.org.uk> <1318461858.4024.197.camel@deadeye>
In-Reply-To: <1318461858.4024.197.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 06:24 PM, Ben Hutchings wrote:
> I looked a little further and saw that nl80211 does support changing
> interface type (mode).  But this driver (rtl8192ce) only supports
> creating new interfaces, not changing their type.
>
> Should mac80211 drivers generally support changing interface type
> (change_interface operation)?

I don't think that implementation of the WEXT interface is necessary. As to 
using iw, the following sequence worked:

iw dev wlan14 interface add wlan15 type adhoc
iw dev  set rename5 type managed
iw dev  set rename5 type adhoc

Why it was called "rename5" when I asked for "wlan15" is not understood, but the 
iw interface changes the mode for an existing interface when using rtl8192ce.

BTW, I added a new iface because I did not want to interrupt my internat connection.

Larry

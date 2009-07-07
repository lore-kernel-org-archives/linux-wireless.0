Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:51345 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZGGUhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 16:37:13 -0400
Received: by bwz25 with SMTP id 25so2344274bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 13:37:12 -0700 (PDT)
Date: Wed, 8 Jul 2009 00:37:34 +0400
From: Alexander Barinov <alex.barinov@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Message-ID: <20090708003734.0d57b389@dream>
In-Reply-To: <200907070859.39413.hs4233@mail.mn-solutions.de>
References: <20090704130346.01b2e869@dream>
	<200907070859.39413.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 7 Jul 2009 08:59:39 +0200
Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> > By executing 'cat /proc/net/wireless' I get the same bug:
> 
> I haven't tested your exact but, but I've the following in my 
> mind, back from about 1 year ago when I did lots of libertas and 
> libertas_cs work:
> 
> Access wireless stats made the libertas driver (in wext.c) issue 
> a command towards the firmware in the hardware. I think it was 
> the command to get the current SNR/RSSI/whatever.
> 
> The libertas command-response-cycle does sleep, so you could 
> trigger a bug. I once had a patch (and I think I posted that 
> patch). The patch lied, by providing the last SNR/RSSI/whatever, 
> and issueing a "get SNR/RSSI/whatever" in the background, just 
> storing the result. So just one "cat /proc/net/wireless" returns 
> bogus, but a continues command returns "valid" info, e.g. when 
> doing "watch iwconfig eth1".

Sorry for asking a potentially stupid question as I am no way a
wireless hardware expert, but can this bug be caused by wrong firmware
version?

BTW, it is really hard to find a patch you are talking about in the
archive. Could you please give some clues on the key words to search
(besides your name and "patch", of cause)?

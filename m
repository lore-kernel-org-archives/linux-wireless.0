Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:64794 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZK0Rs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 12:48:58 -0500
Received: by ywh12 with SMTP id 12so1858215ywh.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 09:49:05 -0800 (PST)
Message-ID: <4B10110E.8030402@lwfinger.net>
Date: Fri, 27 Nov 2009 11:49:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: htl10@users.sourceforge.net, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187 warnings on suspend
References: <665313.63774.qm@web23102.mail.ird.yahoo.com> <200911270945.31125.herton@mandriva.com.br>
In-Reply-To: <200911270945.31125.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/27/2009 05:45 AM, Herton Ronaldo Krzesinski wrote:
> 
> Also because we don't register assoc/radio leds, we end up now having to put
> led switch code in rtl8187_stop, and assume led always on in tx/rx, this is
> something now worth to look and fix.
> 
> A better patch is below, tested here now too, avoiding adding the extra stopped
> flag:

I cannot test with suspend to RAM as it fails on my computer even without
rtl8187 being loaded. This patch survived my load/unload tests, but failed when
I tried unplugging/plugging the device - it crashed KDE and I ended up at the X
login screen. Without the patch, I have not seen that failure.

Larry

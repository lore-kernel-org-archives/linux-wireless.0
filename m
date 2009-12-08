Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64238 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966125AbZLHVAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:00:55 -0500
Received: by gxk26 with SMTP id 26so5492934gxk.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 13:01:02 -0800 (PST)
Message-ID: <4B1EBE86.7000303@lwfinger.net>
Date: Tue, 08 Dec 2009 15:00:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to
 suspend' warning
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081341.20682.herton@mandriva.com.br> <4B1EB43B.8090806@lwfinger.net> <200912081857.49661.herton@mandriva.com.br>
In-Reply-To: <200912081857.49661.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2009 02:57 PM, Herton Ronaldo Krzesinski wrote:
> It's because without registering a radio led the current behaviour is wrong 
> for some cases, the led stays on when it shouldn't. For example, if you bring 
> the interface down (ifconfig <if> down) the led stays on, when it shouldn't. 
> The led should only be active while interface is active, between start and 
> stop (or in other words, the radio is on). After mac80211 stops the device, 
> any i/o (led activity) shouldn't happen.

OK, then the turn off of the radio LED eliminates the "turn-off" that
I put in the shutdown process.

Larry

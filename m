Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:54991 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966112AbZLHVHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:07:19 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to suspend' warning
Date: Tue, 8 Dec 2009 19:07:23 -0200
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081857.49661.herton@mandriva.com.br> <4B1EBE86.7000303@lwfinger.net>
In-Reply-To: <4B1EBE86.7000303@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912081907.23949.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter 08 Dez 2009, às 19:00:54, Larry Finger escreveu:
> On 12/08/2009 02:57 PM, Herton Ronaldo Krzesinski wrote:
> > It's because without registering a radio led the current behaviour is
> > wrong for some cases, the led stays on when it shouldn't. For example, if
> > you bring the interface down (ifconfig <if> down) the led stays on, when
> > it shouldn't. The led should only be active while interface is active,
> > between start and stop (or in other words, the radio is on). After
> > mac80211 stops the device, any i/o (led activity) shouldn't happen.
> 
> OK, then the turn off of the radio LED eliminates the "turn-off" that
> I put in the shutdown process.

Yes, but note it isn't the same thing, only if the turn off happened at 
rtl8187_stop, which doesn't happen at the moment, the led should be turned off 
at _stop.

> 
> Larry
> 

-- 
[]'s
Herton

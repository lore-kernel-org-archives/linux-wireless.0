Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60130 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995Ab3LEMvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:51:25 -0500
Message-Id: <1386247884.2532.55857449.5A49BAC7@webmail.messagingengine.com> (sfid-20131205_135134_801041_8E0C8BEA)
From: "Nikita N." <nikitan@operamail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: RTL8187 bugs
Date: Thu, 05 Dec 2013 04:51:24 -0800
In-Reply-To: <529F9550.7030604@lwfinger.net>
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com>
 <52966D64.2030805@lwfinger.net>
 <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com>
 <52968893.6060405@lwfinger.net>
 <1385812990.14905.53777877.7646278B@webmail.messagingengine.com>
 <529A1B52.6040605@lwfinger.net>
 <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
 <529A36C5.4060209@lwfinger.net>
 <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
 <529E0166.90302@lwfinger.net>
 <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com>
 <529E9437.7020305@lwfinger.net>
 <1386143567.23274.55300753.5C861343@webmail.messagingengine.com>
 <529F9550.7030604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BTW you right, got nervous me too.. configure_filter is called too many
times.. mostly in managed mode! is that correct behavior?
If its correct, the function needs a little optimization, in my
opinion..I mean, I noticed that, after the first few calls, later the
value of priv->rx_conf becomes redundant, IN value of priv->rx_conf is
the same as OUT.. and rtl818x_iowrite32_async unleashes a hell of stack
at every call.. :P

Is it worth putting one more condition such as, only if priv->rx_conf
IN!=OUT then call rtl818x_iowrite32_async ?

Thanks :)

On Wed, Dec 4, 2013, at 12:49 PM, Larry Finger wrote:

> Until I fixed your patch, I could not be assured that it would work. I
> get 
> nervous when that small a patch generates that many warhings.

-- 
http://www.fastmail.fm - Does exactly what it says on the tin


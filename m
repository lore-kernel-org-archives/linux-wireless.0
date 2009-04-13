Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:42019 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZDMPkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 11:40:14 -0400
Message-ID: <49E35CCB.1010003@lwfinger.net> (sfid-20090413_174018_596402_8C71CE9E)
Date: Mon, 13 Apr 2009 10:39:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC] rtl8187: Remove some magic numbers
References: <49e28a0e.w2E55OwYOA9yeg+w%Larry.Finger@lwfinger.net>	 (sfid-20090413_024115_059324_BFAA839F) <1239616304.8243.0.camel@johannes.local>
In-Reply-To: <1239616304.8243.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-04-12 at 19:40 -0500, Larry Finger wrote:
> 
>> -	rtl818x_iowrite16(priv, (__le16 *)0xFFF4, 0xFFFF);
>> +	rtl818x_iowrite16(priv, &priv->map->FEMR, 0xFFFF);
> 
> That looks strange -- I can tell it works because priv->map is set to
> 0xFF00, but wouldn't actual constants make more sense?

The value 0xFFF4 is the address offset of the Function Event Mask Register, not
a data value. Using a symbol emphasizes that we are referring to a register and
not a constant.

Larry


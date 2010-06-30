Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:45232 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752128Ab0F3H1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 03:27:21 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0526312837
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 16:27:19 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Date: Wed, 30 Jun 2010 16:26:57 +0900
Cc: linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006281021.47132.br1@einfach.org> <4C2AEF25.1702.2DF7E2@jafojtik.seznam.cz>
In-Reply-To: <4C2AEF25.1702.2DF7E2@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006301626.57547.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed June 30 2010 16:15:49 Jaroslav Fojtik wrote:
> > > Before this patch there were short peeks from -78dB to -71dB.
> > > After patch there are short measurement drops from -62dB to -70dB.
> > > 
> > > The week charting simply averages it:
> > >   http://78.108.103.11:11080/cgi-bin/rodga_1week_big.cgi
> > 
> > i guess this must be the same situation as before, no?
> 
> Just repeat:
> ## Before this patch there were short peeks from -78dB to -71dB.
> 
> ## After patch there are short measurement drops from -62dB to -70dB.

i meant: did you see the same kind of drops with the older compat-wireless 
versions, before you reported the problem?

> > how many antennas do you have attached to your device?
> 
> One miniPCI device has only one antenna attached. Second U.FL. connector
> is empty.
> 
> > it might be interesting to check if you get more consistent
> > signal measurements by disabling antenna
> > diversity, setting it to a fixed antenna. you can do this by using a
> > debugfs file "echo fixed-a > /sys/kernel/debug/ath5k/phy0/antenna" (or
> > "fixed-b")...
> 
> I have found that "fixed-b" is a right connector. There is a stupid
> question why? When I am using "out" and not "aux". I just guess that "out"
> should be 'a' and 'aux' should be 'b'.

yes, i have noticed the same thing on some cards. maybe a wrong setting in 
eeprom, or some bug in ath5k.

> Please again have a look at:
>   http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
> 
> It looks like signal power jumped to -46dB.
> It seems that ATH5k never switched to "fixed-b" and I has been receiving
> garbage from empty U.FL. It is a miracle that it has been worked.

i have also had problems with diversity in ath5k when there is only one 
antenna attached and in this case i always need to set a fixed antenna for 
optimal performance.

> MadWiFi is much more intelligent. It tests both inputs and selects better
> one.

glad to hear it works for you; i had many inconsistencies with antenna 
diversity on madwifi as well..

bruno

PS: CC'ing nick, maybe he has some idea?

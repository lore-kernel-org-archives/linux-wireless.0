Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:41166 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755376Ab0CXLP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 07:15:27 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0837569324
	for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 20:15:25 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Michael Stahn <m1kes@web.de>
Subject: Re: [Proposal]TX flags
Date: Wed, 24 Mar 2010 20:15:21 +0900
Cc: linux-wireless@vger.kernel.org,
	=?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Jouni Malinen <j@w1.fi>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com> <201003230942.15718.br1@einfach.org> <loom.20100323T162144-640@post.gmane.org>
In-Reply-To: <loom.20100323T162144-640@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003242015.21409.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 March 2010 00:50:31 Michael Stahn wrote:
> > similar to this we would also need to be able to specify that the beacon
> > TSF should not be overwritten. maybe a general flag like "do not change"
> > would do?
> 
> Is TSF really overwritten at manual injection from userspace?

Yes, it is, at least on ath5k. And as jouni has pointed out recently this 
behaviour is expected by hostapd (maybe not for beacons but for probe 
request/response frames, i dont know).

Gabor Stefanik proposed a while ago that frames should only be modified by the 
driver in cooked monitor mode (COOK_FRAMES), that way we could avoid defining 
new radiotap flags. What's your view on that, Jouni?

bruno

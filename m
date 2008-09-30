Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17963 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYI3LIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 07:08:07 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
Date: Tue, 30 Sep 2008 13:07:59 +0200
Cc: "Anadi Mishra" <reachanadi@gmail.com>
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com> <200809301018.31678.hs4233@mail.mn-solutions.de> <e001a6370809300234j7f84a9f0j50213e9912dd5c08@mail.gmail.com>
In-Reply-To: <e001a6370809300234j7f84a9f0j50213e9912dd5c08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301307.59344.hs4233@mail.mn-solutions.de> (sfid-20080930_130812_815609_E7E65084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> regarding rest of the things u pointed out, its all greek to
> me (I am noob). But could u plz tell me from where can i get
> the firmware details of the card
> USB8388??

I don't think that you have a firmware problem.

Probably some compiler / alignment issue.

Result codes from the firmware are 16 bit, but 0x160000 doesn't 
fit into an 16 bits. So you need to search why your 
compiler/hardware creates 0x160000 out of two transferred bytes. 
But *ANY* firmware for the 8388 chips returns the result as 16 
bits, that is two bytes. If you get bogus / hosed result, you 
have a problem there. And using a different firmware won't help 
you there. There is an underlying problem that you need to solve 
first.


BTW: you can get the firmware specification via this driver 
portal: http://wireless.kernel.org/en/users/Drivers/libertas

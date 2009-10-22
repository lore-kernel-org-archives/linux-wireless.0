Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:57123 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZJVHxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 03:53:54 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: remove handling for CMD_802_11_LED_GPIO_CTRL
Date: Thu, 22 Oct 2009 09:53:17 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <200910191331.20476.hs4233@mail.mn-solutions.de> <1256149730.5010.39.camel@localhost.localdomain>
In-Reply-To: <1256149730.5010.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910220953.17995.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's actually used by the OLPC folks; but right now there's
> simply no mechanism to configure that ability via WEXT.  Is
> there some way to do this via the kernel LED  framework instead
> that libertas should be using?

They use it?

No one did bother to send a patch for the in-kernel Libertas 
driver during the last year. Sigh.

Also, if they use it, they need a patch on top of what is now in 
the kernel, because the current in-kernel libertas driver has no 
code to issue the CMD_802_11_LED_GPIO_CTRL. That's why I removed 
it in the first place.

It's O.K. for me to keep this code in (it doesn't harm), but a 
better approach would be

a) use a new-style commands, a.k.a. lbs_cmd_with_response()

b) use the in-kernel LED support (as you said)

-- 
http://www.holgerschurig.de

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47320 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1EMUby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 16:31:54 -0400
Received: by fxm17 with SMTP id 17so2000454fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 13:31:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: WPA in ad-hoc mode with carl9170
Date: Fri, 13 May 2011 22:31:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <20110513160113.GA14293@zenon.in.qult.net> <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com> <20110513174041.GA4690@zenon.in.qult.net>
In-Reply-To: <20110513174041.GA4690@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105132231.48232.chunkeey@googlemail.com> (sfid-20110513_223158_274432_66AC35F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 May 2011 19:40:41 Ignacy Gawedzki wrote:
> On Fri, May 13, 2011 at 12:39:53PM -0400, thus spake Brian Prodoehl:
> > Have you tested only with hw crypto?  Try passing the nohwcrypt param
> > to the module while loading.
> 
> I just tried that and at first it seemed to make no difference.  But at some
> point, one of the two nodes of my testbed started to send encrypted frames
> (both broadcast and unicast) and the other node could receive them okay.
> 
> Unfortunately, I just can't make the other node work (the difference being it
> is a x86_64 netbook vs. an i386 embedded atom industrial PC for the first
> node).
> 
> My preliminary tests show that setting the nohwcrypt option makes no difference.
not too surprising, the driver does not set IEEE80211_HW_SUPPORTS_PER_STA_GTK.
Therefore the software crypto is always used in this case. 

Note: there's a special bit [RX_MAC_CONTROL - bit 6] which instructs the key
cache controller to do the "key security settings" lookup with addr2 for all
bc/mc frames. If we enable this bit and modify carl9170_op_set_key to set the
per station gtk correctly [i.e.: use sta->addr as MAC and put the keys into
the per-sta space [0-63?]] we should be able to enable PER_STA_GTK...
although the driver will be restricted to a single vif [I think].

> Next week, I'll hopefully have more time to investigate and find a repeatable
> procedure to make that work or break.
you should try your setup with mac80211_hwsim first [so we can rule out all
driver bugs].

Regards,
	Chr
 

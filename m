Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0GaNya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 09:54:30 -0400
Received: by bwz1 with SMTP id 1so855696bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 06:54:29 -0700 (PDT)
From: Holger Schurig <holgerschurig@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [wt PATCH 0/5] libertas: make association work again
Date: Sat, 31 Jul 2010 15:54:20 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1280470034.14523.4.camel@dcbw.foobar.com> <1280471706.3710.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280471706.3710.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007311554.20888.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm a bit tempted to say we could use the connect logic in cfg80211 to
> provide this? cfg80211 _already_ provides this if the hardware wants
> auth()/assoc() rather than connect() calls, so it seems fairly simple to
> also (optionally) do it here?

Some months ago I was thinking the same. I thought that the auth/assoc and 
connect driver APIs where quite unorthogonal. However, I did not understand 
all of cfg80211's state machinery to make the connect branch of the API also 
support a BSSID.

If that could be done this way, I'd prefer it over a libertas-internal hack.

Basically we'd need this to be controller from the driver:

do scan before connect
use connect() or auth()/assoc() to connect

That way ...

... some driver can say "no scan, use connect" (orinoco, e.g.)
... or "scan, use connect" (libertas)
... or "scan, use auth/assoc" (mac80211)

-- 
http://www.holgerschurig.de

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab0LBRKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:10:50 -0500
Received: by fxm20 with SMTP id 20so1341393fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 09:10:48 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: "Kernel bug detected" when using pktgen together with mac80211_hwsim
Date: Thu, 2 Dec 2010 18:09:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <201012021731.09440.helmut.schaa@googlemail.com> <1291307938.3481.48.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291307938.3481.48.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012021809.41623.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 02 Dezember 2010 schrieb Johannes Berg:
> On Thu, 2010-12-02 at 17:31 +0100, Helmut Schaa wrote:
> 
> > Unfortunately pktgen keeps a reference to the skb and thus pskb_expand_head
> > triggers a BUG when called from mac80211. I worked around that issue by adding
> > a skb_copy for shared skbs.
> > 
> > Maybe, someone else has a better idea on how to fix that?
> 
> Oops! That seems like the right way to fix it though.

Ok, thanks, I'll send a patch then. I guess we cannot use pskb_copy due to
(for example) our own fragmenation list usage, right?

Helmut

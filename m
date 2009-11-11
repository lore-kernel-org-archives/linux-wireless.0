Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:50909 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZKKEM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 23:12:59 -0500
Received: by fxm21 with SMTP id 21so691774fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 20:13:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF99EF9.4040408@nets.rwth-aachen.de>
References: <4AF99EF9.4040408@nets.rwth-aachen.de>
Date: Tue, 10 Nov 2009 23:13:03 -0500
Message-ID: <b6c5339f0911102013k20d927d3mc021d25bf6703303@mail.gmail.com>
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
From: Bob Copeland <me@bobcopeland.com>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: ath5k-devel@lists.ath5k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 12:12 PM, Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:
> Hi,
>
> is there any reason the packet is dropped and "NETDEV_TX_OK" is returned,
> in this case?
> Seems pretty stupid to me, because now we are randomly dropping
> packets before kernel queuing (qdisc etc) can handle them,
> or am I missing something?

Yes, there is a good reason (there are no buffers for the hardware to
play with).  Actually mac80211 tx is never supposed to return anything
but TX_OK.

Try this patch (it needs work which is why it's not upstream yet):

http://patchwork.kernel.org/patch/56785/

-- 
Bob Copeland %% www.bobcopeland.com

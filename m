Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:5623 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXFALze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 07:55:34 -0400
Received: by mu-out-0910.google.com with SMTP id i10so619583mue
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 04:55:31 -0700 (PDT)
Message-ID: <7b4bf7ff0706010455t75b1e2bdq46585ac9d74bc0ae@mail.gmail.com>
Date: Fri, 1 Jun 2007 13:55:31 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706011129.12432.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706011129.12432.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/1, Michael Buesch <mb@bu3sch.de>:
> This updates stop_queue(s) kdoc as currently there's
> a undocumented dependency.
>
> Stopping the queue from anywhere else than the ops->tx()
> callback will result in a hard to debug deadlock and
> system freeze (on UP).

Sorry but: why would one call ieee80211_stop_queue() from outside of
the tx handler in the first place? Wouldn't that simply be a driver
design problem?
Unless i missed something, stop_queue() isn't called outside of the tx
handler in bcm43xx code...

--
Olivier Cornu

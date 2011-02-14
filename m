Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34828 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1BNIvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 03:51:19 -0500
Received: by qwa26 with SMTP id 26so2929443qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 00:51:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102140943.13801.jordipujolp@gmail.com>
References: <201102131531.29984.jordipujolp@gmail.com>
	<201102140943.13801.jordipujolp@gmail.com>
Date: Mon, 14 Feb 2011 09:51:18 +0100
Message-ID: <AANLkTi=057tQL07iBit=uZnckXVs4V+1=2pMCBpha+RU@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: synchronize transmission routines
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> A new version of this patch to synchronize transmission and receipt for each
> device,

Well that address my first  major objection against this patch.
But could you please explain what is working better with this patch?
Both rxdone as txdone are for USB devices on a singlethreaded
workqueue. So it the work items will be scheduled only once...

And I am not aware of any race conditions on the txdone/rxdone
paths (my testing environment is a dual-CPU system as well, so
I am always testing with SMP enabled...)

Ivo

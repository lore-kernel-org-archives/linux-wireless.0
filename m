Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55868 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3CSN2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 09:28:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix size_t printf warnings
References: <20130319132520.30756.84770.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 15:28:15 +0200
In-Reply-To: <20130319132520.30756.84770.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 19 Mar 2013 15:25:20 +0200")
Message-ID: <87wqt3zfgw.fsf@kamboji.qca.qualcomm.com> (sfid-20130319_142826_736846_35A456A9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> My new tracing code for ath6kl introduced these warnings on 64-bit:
>
> trace.h:38:1: warning: format '%d' expects argument of type 'int',
> 	but argument 4 has type 'size_t' [-Wformat]
> trace.h:61:1: warning: format '%d' expects argument of type 'int',
> 	but argument 4 has type 'size_t' [-Wformat]
> trace.h:84:1: warning: format '%d' expects argument of type 'int',
> 	but argument 6 has type 'size_t' [-Wformat]
> trace.h:119:1: warning: format '%d' expects argument of type 'int',
> 	but argument 7 has type 'size_t' [-Wformat]
> trace.h:173:1: warning: format '%d' expects argument of type 'int',
> 	but argument 3 has type 'size_t' [-Wformat]
> trace.h:193:1: warning: format '%d' expects argument of type 'int',
> 	but argument 5 has type 'size_t' [-Wformat]
> trace.h:221:1: warning: format '%d' expects argument of type 'int',
> 	but argument 5 has type 'size_t' [-Wformat]
>
> Fix them by using %zd.
>
> Reported-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

John, can you take this directly so that we can fix the build warnings
on your tree?

-- 
Kalle Valo

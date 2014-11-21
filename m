Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56184 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbaKUKzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 05:55:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21615.6810.716982.963365@gargle.gargle.HOWL> (sfid-20141121_115554_809687_FF9A84A1)
Date: Fri, 21 Nov 2014 16:27:30 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: Fix shared WEP
In-Reply-To: <CA+BoTQk2fy024b5E=khSrzpUGzCL=jU_4wpxJ0AAyxmsFZuWhA@mail.gmail.com>
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
	<CA+BoTQnyf0tvg8ngLqsoux-A9-3J46cDuJdd-V=kS24wWS4Y1A@mail.gmail.com>
	<21615.3019.437408.992893@gargle.gargle.HOWL>
	<CA+BoTQm_X3-kpJanZu=dJ3LDPqjAfnUoyBwqzgYGX3bK+H1f2g@mail.gmail.com>
	<21615.5541.120044.376524@gargle.gargle.HOWL>
	<CA+BoTQk2fy024b5E=khSrzpUGzCL=jU_4wpxJ0AAyxmsFZuWhA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> Yes. Basically peer->keys[] should be protected by both conf_mutex and
> data_lock if you want to modify it. If you want to read it you need
> either one.

Ok.

> Thanks! Looks like the `cancel_work_sync(&arvif->wep_key_work);`
> should go _before_ `mutex_lock(&ar->conf_mutex);`.
> 
> I'm busy with some stuff so feel free to send a patch :-)

I'll send a fix after this one. Thanks for the review !

Sujith

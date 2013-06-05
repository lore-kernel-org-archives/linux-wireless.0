Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36712 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3FEQQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 12:16:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20911.25503.889346.781590@gargle.gargle.HOWL> (sfid-20130605_181619_780001_3FC78D79)
Date: Wed, 5 Jun 2013 21:43:19 +0530
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] ath9k: Enable WoW only for AR9462
In-Reply-To: <CAD2nsn0=W+KU4S7cOzAQ1C5mt_GUzAYDNjtwhjvw-C7NM_4eQQ@mail.gmail.com>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
	<1370231369-16241-2-git-send-email-sujith@msujith.org>
	<20130603150846.GB2146@redhat.com>
	<20908.45989.889590.158302@gargle.gargle.HOWL>
	<CAD2nsn0=W+KU4S7cOzAQ1C5mt_GUzAYDNjtwhjvw-C7NM_4eQQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> i remember i tested wow with AR9462, AR9485, AR9280, AR9287, though quirky
> with AR9002 families. Does it really makes sense to remove them ? Its bit
> painful to find the bugs in HAL code when we do it later, thoughts ?

WoW has to be tested quite a bit for it to be fully operational and it's largely
affected by the platform/chip quirks. Our internal test cycles cover various aspects
of WoW to make sure it doesn't affect normal usage and we never covered
the AR9002 family. Keeping untested, possibly incomplete code is not really useful...

Stanislaw raised a concern about a potential RH customer - if that happens, the patch
can be reverted (though, AR9462 would be a much better choice).

Sujith

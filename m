Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33201 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbYGAK30 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:29:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH/RFC v3] b43: remove input device usage for rfkill
Date: Tue, 1 Jul 2008 12:29:04 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <1214906908.7763.36.camel@johannes.berg> <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
In-Reply-To: <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807011229.04900.mb@bu3sch.de> (sfid-20080701_122928_711892_8E9230C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008 12:19:35 Adel Gadllah wrote:

> +out:
> +	rfk->poll_timer->expires += round_jiffies(B43_RFKILL_POLL_DELAY);

round_jiffies does only make sense for absolute times.
So this needs to be 
	rfk->poll_timer->expires = round_jiffies(jiffies + B43_RFKILL_POLL_DELAY);
However, timer is broken. Use a workqueue.



-- 
Greetings Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:42709 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYGAKe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:34:29 -0400
Received: by ik-out-1112.google.com with SMTP id c28so878959ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:34:27 -0700 (PDT)
Message-ID: <f6ca9fed0807010334w4ea6a65fm238a8d1b1eb62aa@mail.gmail.com> (sfid-20080701_123431_746030_0C298C82)
Date: Tue, 1 Jul 2008 12:34:27 +0200
From: drago01 <drago01@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH/RFC v3] b43: remove input device usage for rfkill
Cc: "Adel Gadllah" <adel.gadllah@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200807011229.04900.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <1214906908.7763.36.camel@johannes.berg>
	 <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
	 <200807011229.04900.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2008 at 12:29 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 01 July 2008 12:19:35 Adel Gadllah wrote:
>
>> +out:
>> +     rfk->poll_timer->expires += round_jiffies(B43_RFKILL_POLL_DELAY);
>
> round_jiffies does only make sense for absolute times.
> So this needs to be
>        rfk->poll_timer->expires = round_jiffies(jiffies + B43_RFKILL_POLL_DELAY);
> However, timer is broken. Use a workqueue.

OK, will submit a new patch if we still want to remove the input device.

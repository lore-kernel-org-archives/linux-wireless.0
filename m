Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33625 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2ABMjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 07:39:04 -0500
Received: by wibhm6 with SMTP id hm6so8355605wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 04:39:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120102122018.30057.qmail@stuge.se>
References: <1325490085-3806-1-git-send-email-zajec5@gmail.com>
	<1325490085-3806-2-git-send-email-zajec5@gmail.com>
	<20120102122018.30057.qmail@stuge.se>
Date: Mon, 2 Jan 2012 13:39:02 +0100
Message-ID: <CACna6rxjZ655nnDZjGWbNcaA8PD6BRMpdhqfBZ-StX9nECrScA@mail.gmail.com> (sfid-20120102_133927_386922_3AA791A7)
Subject: Re: [PATCH 2/3] bcma: SPROM: add macro for easier extraction
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2012 13:20 użytkownik Peter Stuge <peter@stuge.se> napisał:
> Rafał Miłecki wrote:
>> +#define SPEX(_field, _offset, _mask, _shift) \
>> +     bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))
>
> Maybe this should take at least bus as parameter too?

I don't think we will ever want to extract SPROM info to something
else. Can't imageine such a situation right now.

Of course it may happen some new requirement will appear in the
future. But it's hard to predict it right now. And we never know what
macro will handle that future requirement. Oh, and we always can
modify existing macro or add new one :) Fortunately it's not any kind
of API :)

-- 
Rafał

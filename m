Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648CAC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 380DF2075B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfDOKT7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:19:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52240 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbfDOKTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:19:55 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-144-yjSabL5nPTGzMfo5zyKITA-1; Mon, 15 Apr 2019 11:19:47 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 15 Apr 2019 11:20:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 15 Apr 2019 11:20:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alastair D'Silva' <alastair@d-silva.org>,
        'Petr Mladek' <pmladek@suse.com>
CC:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        'Jani Nikula' <jani.nikula@linux.intel.com>,
        'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>,
        'Rodrigo Vivi' <rodrigo.vivi@intel.com>,
        'David Airlie' <airlied@linux.ie>,
        'Daniel Vetter' <daniel@ffwll.ch>,
        'Karsten Keil' <isdn@linux-pingi.de>,
        'Jassi Brar' <jassisinghbrar@gmail.com>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Stanislaw Gruszka' <sgruszka@redhat.com>,
        'Benson Leung' <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        'Alexander Viro' <viro@zeniv.linux.org.uk>,
        'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Topic: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAgCCza9VAHVj+h+o2yMYSCAAAOL8A==
Date:   Mon, 15 Apr 2019 10:20:56 +0000
Message-ID: <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
 <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
 <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
 <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
 <0da301d4f373$01d5bb80$05813280$@d-silva.org>
In-Reply-To: <0da301d4f373$01d5bb80$05813280$@d-silva.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: yjSabL5nPTGzMfo5zyKITA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alastair D'Silva
> Sent: 15 April 2019 11:07
...
> In the above example the author only wants the hex output, while in other
> situations, both hex & ASCII output is desirable. If you just want ASCII
> output, the caller should just use a printk or one of it's wrappers.

Hexdump will 'sanitise' the ASCII.

Although I think you'd want a 'no hex' flag to suppress the hex.

Probably more useful flags are ones to suppress the address column.
I've also used flags to enable (or disable) suppression of multiple
lines of zeros of constant bytes.
In that case you may want hexdump to return the flags for the
next call when a large buffer is being dumped in fragments.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


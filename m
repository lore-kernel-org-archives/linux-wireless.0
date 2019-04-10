Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55265C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBE120818
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfDJIoW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 04:44:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:58054 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728641AbfDJIoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 04:44:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-139-fjmoDOY7OryNuGiZcxGCOA-1; Wed, 10 Apr 2019 09:44:16 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 10 Apr 2019 09:45:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 10 Apr 2019 09:45:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        "alastair@d-silva.org" <alastair@d-silva.org>
CC:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Karsten Keil" <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
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
Subject: RE: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated
 by lines '|'
Thread-Topic: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated
 by lines '|'
Thread-Index: AQHU70w0rkaVHIS5K0aGNoZBJJ6fAqY1Ew8A
Date:   Wed, 10 Apr 2019 08:45:25 +0000
Message-ID: <1cd09186c67b4fa4bceb84faf835ff10@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-5-alastair@au1.ibm.com>
In-Reply-To: <20190410031720.11067-5-alastair@au1.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: fjmoDOY7OryNuGiZcxGCOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alastair D'Silva
> Sent: 10 April 2019 04:17
> With the wider display format, it can become hard to identify how many
> bytes into the line you are looking at.
> 
> The patch adds new flags to hex_dump_to_buffer() and print_hex_dump() to
> print vertical lines to separate every N groups of bytes.
> 
> eg.
> buf:00000000: 454d414e 43415053|4e495f45 00584544  NAMESPAC|E_INDEX.
> buf:00000010: 00000000 00000002|00000000 00000000  ........|........

Ugg, that is just horrid.
It is enough to add an extra space if you really need the columns
to be more easily counted.

I'm not even sure that is needed if you are printing 32bit words.
OTOH 32bit words makes 64bit values really stupid on LE systems.
Bytes with extra spaces every 4 bytes is the format I prefer
even for long lines.

Oh, and if you are using hexdump() a lot you want a version
that never uses snprintf().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


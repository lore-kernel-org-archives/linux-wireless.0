Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A517CC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79818206B6
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfDOKzd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:55:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:21152 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbfDOKzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:55:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-163-7kMGV5O_PDmlrIf3f2xIYw-1; Mon, 15 Apr 2019 11:55:29 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 15 Apr 2019 11:56:39 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 15 Apr 2019 11:56:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alastair D'Silva' <alastair@d-silva.org>,
        'Petr Mladek' <pmladek@suse.com>
CC:     'Jani Nikula' <jani.nikula@linux.intel.com>,
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
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Thread-Topic: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AHAzoGyAvGIFSMBrjp8bwNRRzUuo2RTc0CAAAzpEA==
Date:   Mon, 15 Apr 2019 10:56:39 +0000
Message-ID: <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-2-alastair@au1.ibm.com>
 <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
 <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org>
 <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
 <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
In-Reply-To: <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 7kMGV5O_PDmlrIf3f2xIYw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alastair D'Silva
> Sent: 15 April 2019 11:29
...
> I do, and I believe the choice of the output length should be in the hands
> of the caller.
> 
> On further thought, it would make more sense to remove the hardcoded list of
> sizes and just enforce a power of 2. The function shouldn't dictate what the
> caller can and can't do beyond the technical limits of it's implementation.

Why powers of two?
You may want the length to match sizeof (struct foo).
You might even want the address increment to be larger
that the number of lines dumped.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


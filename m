Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743F8C10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44AA620684
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="WHu+KTZy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfDOKov (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:44:51 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:48702 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfDOKov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:44:51 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id BA4442F28FBB;
        Mon, 15 Apr 2019 06:44:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555325090;
        bh=HuPaY1jTKMqMghnD8FnwoCRKDZ3v7xanfe1QMzwaou4=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=WHu+KTZyqfxQTeThrxJekeyaf3OMzDdprmPkpEWPEmpv5nMYM3uN7jsG3CkrkOkjZ
         Nq340tAKCdRug+7CHZMmow4NDp86wM9atvR5Q5ELHqe18uG6m7Vt4fgUnIhx/Ar9dO
         kYixS4/B0GUXe2kyYnCYRUacwcpS6xGEHs65tM1ZmRI9xmqLYgGeVCh6nJwLjIC5hk
         B1EoCpEsyaPrIoTkQkvzY+esx/37HgsK88CVeMVRNPP76XwdPP5FDJ8W0bVFtj7WL8
         SlsJWlUd0CJ+6jRvuG3/Z6RcCGje648f5HeRsScmmIkGbYyua7vuKaXEe+MReLFWTa
         k5HN86fPaZ+kSodUU+74lqceLIuXDc0uZJPNMURoBw+fqiBrOUncmGtytvTs2GEDlt
         lPgQhp/l+Lb+7TFuFATfSQgZTD7ETg9qw2l/66oT6UYS0xG7JVZAFFqUM71YK/3sV9
         x4iBFr3SbFC+zO3UU3q8L8EB51PNLtWTuPzlnlmFIgfvcjZuWbOhz+04+48FjqNy5e
         syyuKvLc9bZNlZgAZCJwYpK/8m/UhdoZd4nTYUy0S1zw/u/7oaw4SMJWklhnuek/fR
         tkPSUB6NJ09+WoSMTnUjScXaR/1CWJT8Hd/7eUFmEq8jVriI/cU6XMV4sg8LiSDahN
         LqjsAS9CTq/Si3isZUrn+tzU=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FAifoE038671
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 20:44:41 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'David Laight'" <David.Laight@ACULAB.COM>,
        "'Petr Mladek'" <pmladek@suse.com>
Cc:     "'Alastair D'Silva'" <alastair@au1.ibm.com>,
        "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        "'Joonas Lahtinen'" <joonas.lahtinen@linux.intel.com>,
        "'Rodrigo Vivi'" <rodrigo.vivi@intel.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Karsten Keil'" <isdn@linux-pingi.de>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        "'Tom Lendacky'" <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'Benson Leung'" <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz> <093301d4f187$da0756a0$8e1603e0$@d-silva.org> <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz> <0da301d4f373$01d5bb80$05813280$@d-silva.org> <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
In-Reply-To: <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Mon, 15 Apr 2019 20:44:39 +1000
Message-ID: <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAgCCza9VAHVj+h+AtHj3ewBiV+EcKNJu02w
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 20:44:44 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Monday, 15 April 2019 8:21 PM
> To: 'Alastair D'Silva' <alastair@d-silva.org>; 'Petr Mladek'
> <pmladek@suse.com>
> Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>; 'Jani Nikula'
> <jani.nikula@linux.intel.com>; 'Joonas Lahtinen'
> <joonas.lahtinen@linux.intel.com>; 'Rodrigo Vivi' =
<rodrigo.vivi@intel.com>;
> 'David Airlie' <airlied@linux.ie>; 'Daniel Vetter' <daniel@ffwll.ch>; =
'Karsten
> Keil' <isdn@linux-pingi.de>; 'Jassi Brar' <jassisinghbrar@gmail.com>; =
'Tom
> Lendacky' <thomas.lendacky@amd.com>; 'David S. Miller'
> <davem@davemloft.net>; 'Jose Abreu' <Jose.Abreu@synopsys.com>; 'Kalle
> Valo' <kvalo@codeaurora.org>; 'Stanislaw Gruszka' =
<sgruszka@redhat.com>;
> 'Benson Leung' <bleung@chromium.org>; 'Enric Balletbo i Serra'
> <enric.balletbo@collabora.com>; 'James E.J. Bottomley'
> <jejb@linux.ibm.com>; 'Martin K. Petersen' =
<martin.petersen@oracle.com>;
> 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>; 'Alexander Viro'
> <viro@zeniv.linux.org.uk>; 'Sergey Senozhatsky'
> <sergey.senozhatsky@gmail.com>; 'Steven Rostedt'
> <rostedt@goodmis.org>; 'Andrew Morton' <akpm@linux-foundation.org>;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; =
linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> hex_dump_to_buffer with flags
>=20
> From: Alastair D'Silva
> > Sent: 15 April 2019 11:07
> ...
> > In the above example the author only wants the hex output, while in
> > other situations, both hex & ASCII output is desirable. If you just
> > want ASCII output, the caller should just use a printk or one of =
it's
> wrappers.
>=20
> Hexdump will 'sanitise' the ASCII.
>=20

This is functionality that doesn't exist in the current hexdump =
implementation (you always get the hex version).

I think a better option would be to factor out the sanitisation and =
expose that as a separate function.

> Although I think you'd want a 'no hex' flag to suppress the hex.
>=20
> Probably more useful flags are ones to suppress the address column.

This is already supported by the prefix_type parameter - are you =
proposing that we eliminate the parameter & combine it with flags?

> I've also used flags to enable (or disable) suppression of multiple =
lines of
> zeros of constant bytes.
> In that case you may want hexdump to return the flags for the next =
call when
> a large buffer is being dumped in fragments.
=20
I'm afraid I don't quite follow here, hex_dump_to_buffer doesn't alter =
the flags, so the caller already knows it.=20

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece





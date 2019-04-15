Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E3C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 897552064A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:12:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="bu4LN6BX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfDOLMb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:12:31 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:52756 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfDOLMb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 07:12:31 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id B516F2F28FBB;
        Mon, 15 Apr 2019 07:12:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555326747;
        bh=pxHNsAg7SxpGj3csbFKxz6IpHouP15X+N2zxz8nYFr0=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=bu4LN6BXYnOK96pfhAiJT7p9sabHfQPnof/WoBf6YOLvwQ0ex8liOKH5DYx5pgVSd
         BaMFL3KS2j7DcTKl+/yJGm9ek6q36PxkTTkJvQbPFU4gUaHtTYh9T/VYnzwKKNEXI/
         WC2pWIcNZskjCX+E4T/4/fAHEUmQYhklT0O5HtLgwZ69OaU//z73msNJRF8dUUslAL
         /K3QIuBPNw24vk/z83DOssjqhm+h7RQsdQ1gagDDyPlZpOwxKQi+l4+FUK4hZu6Ood
         1837DQkuCOdIgA3UC8VdaEM42fMQwWMMmJq4HgotdSKWXiqZ+xY+3gEoOt4RrJFEXK
         JAjO0QM+2eFuCn33r5LmhRW69yOVdDOGtOrciBf1vIgIW987FuU5pWJlqS1SkFqG5r
         DgaaS1Qcn+aTeh/ZjmNKh6SkM9+oxUh8L4eaUJgC/v6TQ8ybBzLCkCktyUBhyqfuvR
         V+e6NBR81FPe2jNqR80z/ko9KeLzTzj0cr1EognpJJdG/loKiMeyjgMwtgpTHdNBA5
         023OIhFeMhIuqryfXFld9VO6Q4dUItUqsKP096XNrJ60TdsKJQRlCb3OtTdstWmTSj
         q0a22vO/sjRBWEmk6rDYtathLCdmI63yv2HHGgcHcwtla6prE/ANw8MZJvGzL2tODV
         8Fa18rPT//scJtxx7+QjzOL4=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FBCHoT038851
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 21:12:18 +1000 (AEST)
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz> <093301d4f187$da0756a0$8e1603e0$@d-silva.org> <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz> <0da301d4f373$01d5bb80$05813280$@d-silva.org> <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com> <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org> <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
In-Reply-To: <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Mon, 15 Apr 2019 21:12:15 +1000
Message-ID: <0dcb01d4f37c$17b948a0$472bd9e0$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAgCCza9VAHVj+h+AtHj3ewBiV+EcAHzvSSDAcOaqPmjLAoDcA==
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 21:12:21 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Monday, 15 April 2019 9:04 PM
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
> > Sent: 15 April 2019 11:45
> ...
> > > Although I think you'd want a 'no hex' flag to suppress the hex.
> > >
> > > Probably more useful flags are ones to suppress the address =
column.
> >
> > This is already supported by the prefix_type parameter - are you
> > proposing that we eliminate the parameter & combine it with flags?
>=20
> I was looking at the flags on one of my hexdump() functions...
>=20
> > > I've also used flags to enable (or disable) suppression of =
multiple
> > > lines of zeros of constant bytes.
> > > In that case you may want hexdump to return the flags for the next
> > > call when a large buffer is being dumped in fragments.
> >
> > I'm afraid I don't quite follow here, hex_dump_to_buffer doesn't =
alter
> > the flags, so the caller already knows it.
>=20
> If you are suppressing lines of zeros and dumping a buffer in several =
blocks
> then subsequent calls need to know that the last line of the previous =
call was
> suppressed zeros - and carry on with the same suppressed block.

Why wouldn't you do this with a single call to print_hex_dump? (that is =
where the repeated lines are suppressed)

That will already take chunks of the buffer until the whole thing is =
output, in what situation do you see a caller chunking the access =
themselves?

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece




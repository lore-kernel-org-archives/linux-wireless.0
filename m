Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3704BC10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D74962084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 23:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="iEZNn4kR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfDLXWX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 19:22:23 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:51956 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbfDLXWW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 19:22:22 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 17C3B2F28FBB;
        Fri, 12 Apr 2019 19:22:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555111337;
        bh=C/7DEoX+0dM2fBJEvDkBmqJTxKMw1A5TTNNG1efLpXk=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=iEZNn4kRjBwcGYwsoTcmeSXFn73PNLUud7QhtmvuwgtsgfvlhqagT9OdctWgBo71G
         jPgDD/CFQTbbUPPuyL56Ih+Zezuem++Ov3MP4OPmSof5JW7E/E3FMT24T1v+QyxM33
         0VJdcn9JrElQ+vrx6NaSY2c6XEpn5iPuVrWqvLACFNwmWIX8br4Li7cNZKuJ1QMXis
         Pq4/7lrAd/jPTvQJ4HreuYlbUmLtKIVcLZ5v5eLam2nZpzB4PuP6DjdvS3njAqr3cf
         KmsmK/QcpFyVZ/W6NlbagwWIGB+Y6ItPv9LXcE/s7Y1CCPA3GJ5CkJ5vvjpY9e03yL
         CfBSjh25mWXNYbgGfXHubhCiQXRm5o3HbvS2m+MoBgkpQMoD2yJe0DKrFEyzTeXAJ2
         EwzTGZRoPa/M+6JsvTJQv6MnCWtUTIEvJxvIX2ck7bi1UIsZEO5zygTYdRpzuIRlx5
         mlYyqr/OKm58DopDQrBYLdavWiimGK2B2BoYowL41Ebw1APYhvoPhhbAftO0rHbydF
         fuy0TkV4HVIIoJ0vhEhCPHaxKLmuXotppHxH1OXl88IL+E0k279HUrAO0fouyNM2mG
         Z/7kL13pSPDK7ShAyUvDIOV7A4U+BCEhGI+R/HRqJddJMhvUlOB23NjxShVYeOP8ks
         mJc86FcoP7OdWrfstV4ZHcAo=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3CNM6AG018805
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 13 Apr 2019 09:22:06 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Petr Mladek'" <pmladek@suse.com>
Cc:     "'Jani Nikula'" <jani.nikula@linux.intel.com>,
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-2-alastair@au1.ibm.com> <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
In-Reply-To: <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date:   Sat, 13 Apr 2019 09:22:05 +1000
Message-ID: <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AHAzoGyAvGIFSOjiHU+kA==
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Sat, 13 Apr 2019 09:22:12 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Friday, 12 April 2019 11:48 PM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> David S. Miller <davem@davemloft.net>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> Andrew Morton <akpm@linux-foundation.org>; intel-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
> 
> On Wed 2019-04-10 13:17:17, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > With modern high resolution screens, we can display more data, which
> > makes life a bit easier when debugging.
> 
> I have quite some doubts about this feature.
> 
> We are talking about more than 256 characters per-line. I wonder if such a
> long line is really easier to read for a human.

It's basically 2 separate panes of information side by side, the hexdump and
the ASCII version.

I'm using this myself when dealing with the pmem labels, and it works quite
nicely.

> 
> I am not expert but there is a reason why the standard is 80 characters
per-
> line. I guess that anything above 100 characters is questionable.
> https://en.wikipedia.org/wiki/Line_length
> somehow confirms that.
> 
> Second, if we take 8 pixels per-character. Then we need
> 2048 to show the 256 characters. It is more than HD.
> IMHO, there is still huge number of people that even do not have HD
display,
> especially on a notebook.

The intent is to make debugging easier when dealing with large chunks of
binary data. I don't expect end users to see this output.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece




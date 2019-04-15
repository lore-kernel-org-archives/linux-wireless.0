Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2CBC282DA
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867F920883
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="KkL27iQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfDOK7t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:59:49 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:50864 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfDOK7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:59:49 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 581642F28FBB;
        Mon, 15 Apr 2019 06:59:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555325987;
        bh=Hj2IQPvdDGzJX+B33dbo6nLvx+Ul3Jhn6Oo0Q3DFevg=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=KkL27iQnJr8BJX2CujI1GmwEI8UGY9dDBN1E12bQ65o01YMr7c74u4Huds/staXZT
         9HJtnke0y6MjvrxtHPlTf3kGs572gEl3r+LOzVD5nku/Ep356iBxDKOgDhE/TQdO/S
         b5/18ZFSCMKUU6cpfhoZ0Pc2XdgFJ87WejRZEpOHN4ZBJ7ZhRuVbpZWppzxUNFPSTh
         ZuFuKRTSxbLMHbZ4AaaQq8pWTCh4UCBbyfh98vfjknxwIJTJZRHVcXQcu2yzuljiHL
         ObLiQmOHVmzdwdBPRZHd/uzCMi13AF+zHNun4U459NzqME+FAn0zTqSKMpnztkvh/f
         k1WXFnyjNF+ykhp+nrtHBV5JZIXx3tf2TlomIULmk05TEWbUBLUomzjcScVmjTAfP6
         173WfCAkLJ/A2hZEiZ4seKvAOfXES2AVCrGyqwUxkcPuF1KKM8ibSl5RBv667VrHQK
         RD43VGFTRUNzG4orDqBtFq0639A7hejo/3rA+/FbVXi0PDdjmn5KJvmhp4PdlGjsW/
         z2zXObYxsDjmjdXE9otrL0HOJrOIBYUsTK5uFn4MaSzzGfQODKD5ZODyjMZfHd+t34
         nGTrm7FTsZT6WNbafICnGPckpWZ+UWnETMcwORoWy8LIC52u8n4QqKSBX3Mt5Bkjxy
         KvY7jICWbLHV9mDT4eZX8E/c=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FAxcgr038744
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 20:59:39 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'David Laight'" <David.Laight@ACULAB.COM>,
        "'Petr Mladek'" <pmladek@suse.com>
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-2-alastair@au1.ibm.com> <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz> <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org> <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz> <0dad01d4f376$113df2b0$33b9d810$@d-silva.org> <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
In-Reply-To: <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date:   Mon, 15 Apr 2019 20:59:36 +1000
Message-ID: <0dc901d4f37a$52733a70$f759af50$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AHAzoGyAvGIFSMBrjp8bwNRRzUuAZMFtXgCfZ9RIKND3FKg
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 20:59:41 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> From: Alastair D'Silva
> > Sent: 15 April 2019 11:29
> ...
> > I do, and I believe the choice of the output length should be in the
> > hands of the caller.
> >
> > On further thought, it would make more sense to remove the hardcoded
> > list of sizes and just enforce a power of 2. The function shouldn't
> > dictate what the caller can and can't do beyond the technical limits =
of it's
> implementation.
>=20
> Why powers of two?
> You may want the length to match sizeof (struct foo).
> You might even want the address increment to be larger that the number =
of
> lines dumped.

Good point, the base requirement is that it should be a multiple of =
groupsize.

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece




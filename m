Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA5AC282DA
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F18F2070D
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="C88r+lm9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfDOK3Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:29:24 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:46528 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfDOK3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:29:24 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 208BF2F28FBD;
        Mon, 15 Apr 2019 06:29:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1555324159;
        bh=bGWnxigOnlzm5DxlxFSHAklaezuMsLcv8acBfqQaCT0=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=C88r+lm9zWe+RP9ergWnDRBcrbCsFZSl9g2/tncr4blc1yTM/mNdTNB+MOEK3cUT5
         xT4qEGgIwrzOVzWPanC6pSz9hziaUJa8BMLux7N8eGMtuufQwihwDy3MF8f6aWSjpC
         VobdBxTH9YPULQCcuoNsOWdIdMxCt+bOe6sZzT1vgS06Dpeqr+BjkuiBtGwdQ0obFG
         8M9fy1xxrQzG22PZJXPrw+baK/19CrDzp/+ZBe6HLbuI2+3g9r73b/xtB2ZJWih3qY
         tilyBzCQQwKkZsldcReXfrGM54k5DhYZSdMRp0GJzmt7ATdKbWEW5KUNCBq9wiW4cY
         X+mnRbJdUJAfhvjh6MNHAW+PtU8K1+c8WXVcP/JbzB6O3RL6CyYgcf9U79N9R8VY83
         GJ9wgzlNqJBUA3Q4jWYOxZ/utNoTiz9bPYtEbyaQWIEO4UYeyUbywZmEmGLf1qsfUn
         vlBpetHcErvmE0P2VqiTubBFh7rW1sTgsVAYmvgZU+nclVq8c61imtafS+OUlA/rIg
         DkC9QJZ/5kniuSUCoNMVSn1IH0+LRiwT0tV+8T8Ve5G4jy7ZF+gazF9MoOzN7GyXvr
         xKJle1POew7TrjG3nJ7c1Yet2VVfI1OFCSV6KT7yHOaAihhAuVrp4X6HpW98mnhIGy
         MYGmPLHWAz0kOKOqCK3kL0lo=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3FATAQm038571
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Apr 2019 20:29:11 +1000 (AEST)
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
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-2-alastair@au1.ibm.com> <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz> <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org> <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
In-Reply-To: <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date:   Mon, 15 Apr 2019 20:29:08 +1000
Message-ID: <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1AHAzoGyAvGIFSMBrjp8bwNRRzUuo2RTc0A=
Content-Language: en-au
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 15 Apr 2019 20:29:14 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<snip>
> > > On Wed 2019-04-10 13:17:17, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > >
> > > > With modern high resolution screens, we can display more data,
> > > > which makes life a bit easier when debugging.
> > >
> > > I have quite some doubts about this feature.
> > >
> > > We are talking about more than 256 characters per-line. I wonder if
> > > such a long line is really easier to read for a human.
> >
> > It's basically 2 separate panes of information side by side, the
> > hexdump and the ASCII version.
> >
> > I'm using this myself when dealing with the pmem labels, and it works
> > quite nicely.
> 
> I am sure that it works for you. But I do not believe that it would be
useful in
> general.

I do, and I believe the choice of the output length should be in the hands
of the caller.

On further thought, it would make more sense to remove the hardcoded list of
sizes and just enforce a power of 2. The function shouldn't dictate what the
caller can and can't do beyond the technical limits of it's implementation.

Other print/debug functions don't restrict the output size, and I can't see
a good justification why hexdump should either.

> > > I am not expert but there is a reason why the standard is 80
> > > characters
> > per-
> > > line. I guess that anything above 100 characters is questionable.
> > > https://en.wikipedia.org/wiki/Line_length
> > > somehow confirms that.
> > >
> > > Second, if we take 8 pixels per-character. Then we need
> > > 2048 to show the 256 characters. It is more than HD.
> > > IMHO, there is still huge number of people that even do not have HD
> > display,
> > > especially on a notebook.
> >
> > The intent is to make debugging easier when dealing with large chunks
> > of binary data. I don't expect end users to see this output.
> 
> How is it supposed to be used then? Only by your temporary patches?

Let me rephrase that, I don't expect end users to *use* this data.

Current usage of the hexdump functions are predominantly centred around
logging and debugging, and clearly targeted at someone intimately familiar
with the relevant subsystem. I expect future use would be similar.

Debugging may be as part of active development, or from a log supplied from
an end user. In either case, it should be up to the author (as a
representative for the consumers of the data) to decide how it should be
formatted.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece






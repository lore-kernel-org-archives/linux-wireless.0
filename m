Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA737C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7981521773
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549700708;
	bh=Mv7XHfT8ML2lpf3Ex1KfdHQwnggZV1ynLtc+yb+GBj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GOv8PgbwZuAeXHPMMCafi6skyczRuIysoBQGLeRpMukO4AEjbEHMICHv5uRcTcGjq
	 +DnnpTL1QOBkofYPGySh0tg4bhYQV1ymEqbO48koqFl2n2VbdxbSQ2BLE7S5/eZruw
	 ZnGT3fjNrznWtAZOBe3heVqulpIUEy8DgafA/rhk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfBIIZE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 03:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfBIIZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 03:25:04 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB08120818;
        Sat,  9 Feb 2019 08:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549700703;
        bh=Mv7XHfT8ML2lpf3Ex1KfdHQwnggZV1ynLtc+yb+GBj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQw87GjVYAsY8BQN/uC5g2jb17m3RYDQz8EvPrAfuW9OAvTRRhgyRt0wxLOvWnh4w
         aJNo64m4mN+Yf5/pErCuRyQKeamjfbYI+aaYb4pti8mzgIuSH9SVz+bJwdeF2FXBRd
         mxlP/HcomGBOqHIOZ+hA0EvVYyNSaCozYwgwz91g=
Date:   Sat, 9 Feb 2019 09:25:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     "Luis R. Rodriguez" <mcgrof@kernel.org>, akpm@linux-foundation.org,
        josh@joshtriplett.org, rishabhb@codeaurora.org, kubakici@wp.pl,
        maco@android.com, andy.gross@linaro.org, david.brown@linaro.org,
        bjorn.andersson@linaro.org, linux-wireless@vger.kernel.org,
        keescook@chromium.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, cantabile.desu@gmail.com, ast@fb.com,
        andresx7@gmail.com, dan.rue@linaro.org, brendanhiggins@google.com,
        yzaikin@google.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] firmware_loader: few selftest fixes
Message-ID: <20190209082500.GA30193@kroah.com>
References: <20190207190602.502-1-mcgrof@kernel.org>
 <18f2e46e-8171-58e2-41d0-c4272fb9b00d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18f2e46e-8171-58e2-41d0-c4272fb9b00d@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 08, 2019 at 10:57:35AM -0700, shuah wrote:
> On 2/7/19 12:05 PM, Luis R. Rodriguez wrote:
> > From: Luis Chamberlain <mcgrof@kernel.org>
> > 
> > Greg,
> > 
> > I've found that Dan's patches really broke firmware testing. I've
> > identified a proper fix for the issue he found, its the last patch. This
> > series reverts his two patches which break testing, and fixes the issue
> > he was running into. I leave it to him as exercise to add a busybox bash
> > quirk for the bash issue he found with diff.
> > 
> > His patches are merged on v5.0-rc1 as such these should go to Linus
> > tree as well. They are regressions on v5.0-rc1. Please let me know if
> > there are any questions.
> > 
> >    Luis
> > 
> > Luis Chamberlain (3):
> >    Revert "selftests: firmware: add CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> >      to config"
> >    Revert "selftests: firmware: remove use of non-standard diff -Z
> >      option"
> >    selftests: firmware: fix verify_reqs() return value
> > 
> >   tools/testing/selftests/firmware/config           | 1 -
> >   tools/testing/selftests/firmware/fw_filesystem.sh | 9 ++++++---
> >   tools/testing/selftests/firmware/fw_lib.sh        | 2 +-
> >   3 files changed, 7 insertions(+), 5 deletions(-)
> > 
> 
> Luis: Thanks for finding and fixing the problems. My apologies
> for pulling the problem patch in by mistake in the first place. :(
> 
> Greg! Do you plan to take these through firmware or do you want
> me to get these in through kselftest tree. Either way is fine.
> 
> Acked-by: Shuah Khan <shuah@kernel.org>

I already queued these up in my tree yesterday, so no need to add them
to yours.

thanks,

greg k-h

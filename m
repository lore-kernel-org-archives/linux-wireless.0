Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185C4C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 01:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7374620850
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 01:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=stackinside.com header.i=@stackinside.com header.b="2h49Qaqk";
	dkim=pass (2048-bit key) header.d=stackinside.com header.i=@stackinside.com header.b="W1JyHdJF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7374620850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stackinside.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbeLGBQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 20:16:24 -0500
Received: from 138.128.218.174.16clouds.com ([138.128.218.174]:33934 "EHLO
        mail.stackinside.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeLGBQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 20:16:24 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2018 20:16:23 EST
Received: by mail.stackinside.com (Postfix, from userid 112)
        id 76D3531F2B; Fri,  7 Dec 2018 02:10:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stackinside.com;
        s=mail; t=1544145020;
        bh=K1pPk9Zo3w4JJYV2QJnpDQbsxxg1gJUlAlCSwes+Nvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2h49QaqkOBBBIXxpXGaio3c8JWnzeQuRXaj0bAjzfHxM3dcBxH2q+mT368L/7VW6Z
         oPpsu4LbBEMRu+hAe7f0+pc9ZI9JftPcGg/afU+odrqJs2d7aORJyqBl2MpvMDQqRM
         5dEnVOYJVR27lkY1rhKacrdXOeA55S0Pi7+li6HATUlvdLbtRVgL1ZmhCj4Jv3n0gq
         uTgSZxaEV4UczPvJpFdyvjY3Iycw+awGsjss13nUsMGxKziIglib69S0qD3Gw8vTkK
         xR4H1K2bJaXjkavrnbuM4Ozaz1Neh0qNHET7sIWbFo5GLnmLCA75+Fzaoi34caeM5k
         NBhPUK9T3jbQw==
Received: from vermont (95-54-31-175.dynamic.lenobl.dslavangard.ru [95.54.31.175])
        by mail.stackinside.com (Postfix) with ESMTPSA id 1853031BD6;
        Fri,  7 Dec 2018 02:10:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stackinside.com;
        s=mail; t=1544145018;
        bh=K1pPk9Zo3w4JJYV2QJnpDQbsxxg1gJUlAlCSwes+Nvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W1JyHdJFo2nJ7dRqxJ3Jn/jx1v5yWGoLMchCgDc+/EFoZuN2CRWOO7heUTS1LWkY0
         1yJUEs51OZfHwx8CQyVSIcgf7bHSenCqvhExMBn3TZhIX21VI4nfuSlgEjL8i6fo/U
         691GZxd32DFShbNOJj1Vdt5TNZOoqiOJNGnQbvNLjnOr2Yj5BLGTzoRng3ENGmiv+1
         h7acTxMjBFhws02mtYANZ0TJvcooG7NUKGUdhHX2FwmMDaXu6iT/8r8SspR3mgUbgZ
         o+O3UUu9iiZEc915IOIFweDRKRdUeTAUZw/m9ua2PmrOzFDx7o2DJrzNpA5mzMsHQ+
         cl+5Nz7XmxlGQ==
Date:   Fri, 7 Dec 2018 04:10:12 +0300
From:   Hubert Wiedeke <info@stackinside.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Request for brcmfmac4366c-pcie.bin
Message-Id: <20181207041012.efa325a117416ac0329e51a9@stackinside.com>
In-Reply-To: <5AC480F8.7060001@broadcom.com>
References: <20180217111959.9548246f2ee99918857b44f8@stackinside.com>
        <5A8ABA2B.70500@broadcom.com>
        <20180404051229.f31c6913c9d4d26ae4fb0c1e@stackinside.com>
        <5AC480F8.7060001@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 4 Apr 2018 09:38:32 +0200
Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> On 4/4/2018 4:12 AM, Hubert Wiedeke wrote:
> > On Mon, 19 Feb 2018 12:51:07 +0100
> > Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> >
> >> On 2/17/2018 9:19 AM, Hubert Wiedeke wrote:
> >>> Hi,
> >>>
> >>> I'd like to ask about the current status of 4366c firmware preparation for linux-firmware.git . Is it close to finish? What about DFS? Nothing critical, just a question.
> >>
> >> I have prepared some firmware changes for 4366, but did not manage to
> >> get any test-cycles for it.
> >>
> >> Regards,
> >> Arend
> >>
> >
> > Could you please estimate any possible dates for the tested FW to be released?
> 
> Not really. Linux open-source work is getting rather low prio when it 
> comes to claiming test lab resources. Best I can say is somewhere this year.
> 
> Regards,
> Arend
> 

Hi Arend,

It seems like the year is almost over, and I guess it would be nice to reconsider the estimation (no rush, of course).
If you had a spare minute, could you please review the current status/priority for this FW?
Linux-powered consumers of 4366c would probably appreciate this information.

-- 
Best regards,
Hubert Wiedeke

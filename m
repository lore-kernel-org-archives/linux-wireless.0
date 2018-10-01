Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B699C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C8520C0A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hkGeM20Q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hkGeM20Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00C8520C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbeJAWaP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:30:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeJAWaP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:30:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 734EC601A0; Mon,  1 Oct 2018 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538409108;
        bh=Z8JYLFZnXECOjPlzdncH3YGA5/AdwwG5HU3mLi1KCak=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hkGeM20QYKzYKjZzG43siw3jsaSzJepVX663H+TTyi9KMRzuOQbzQ6NPKwZNqizW2
         0Q1hK3OcFTmJgRZXr7eZrHb4ixoKm58mDAMorEKr/AFILCRRXVe8YrNGhZdl5P4PZL
         8SRXL1Lz0cIZT/e0THoq2cRxNJLg4lgUDRdrHcEA=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D6BF607DC;
        Mon,  1 Oct 2018 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538409108;
        bh=Z8JYLFZnXECOjPlzdncH3YGA5/AdwwG5HU3mLi1KCak=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hkGeM20QYKzYKjZzG43siw3jsaSzJepVX663H+TTyi9KMRzuOQbzQ6NPKwZNqizW2
         0Q1hK3OcFTmJgRZXr7eZrHb4ixoKm58mDAMorEKr/AFILCRRXVe8YrNGhZdl5P4PZL
         8SRXL1Lz0cIZT/e0THoq2cRxNJLg4lgUDRdrHcEA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3D6BF607DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-09-28
References: <42ab6bb469c859dda2b185b6b2c9ec032ed8d556.camel@coelho.fi>
Date:   Mon, 01 Oct 2018 18:51:43 +0300
In-Reply-To: <42ab6bb469c859dda2b185b6b2c9ec032ed8d556.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 28 Sep 2018 09:53:21 +0300")
Message-ID: <87o9cdk6ls.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the second batch of patches intended for v4.20.  This includes
> the last 2 patchsets I sent.  Usual development work, with some
> improvements on HE, HW support, bugfixes, and some other small
> improvements.  More details about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 93ed990e3a6e722b7b1e1d59b3ceb8d91e36e682:
>
>   qtnfmac: remove set but not used variable 'vif' (2018-09-20 15:12:13 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-09-28
>
> for you to fetch changes up to 6f3df8c1192c873a6ad9a76328920f6f85af90a8:
>
>   iwlwifi: mvm: Allow TKIP for AP mode (2018-09-28 08:57:30 +0300)
>
> ----------------------------------------------------------------
> Second set of iwlwifi patches for 4.20
>
> * TKIP implementation in new devices;
> * Fix for the shared antenna setting in 22000 series;
> * Report that we set the RU offset in HE code;
> * Fix some register addresses in 22000 series;
> * Fix one FW feature TLV that had a conflict with another value;
> * A couple of fixes for SoftAP mode;
> * Work continues for new 22560 hardware;
> * Some fixes in the datapath;
> * Some debugging and other general fixes;
> * Some cleanups, small improvements and other general fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo

Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D24C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 07:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23F920872
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 07:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TVxoO7G3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dT6y9Fax"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A23F920872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbeKKRBk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 12:01:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbeKKRBk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 12:01:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 48F1A6081E; Sun, 11 Nov 2018 07:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541920435;
        bh=xVERuKtB9sBlygwXNCNIFMQMGPbyBqogxC/wZ4ayJd0=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=TVxoO7G3WSG/p6cDHIVKGky0Rfp+NeBNVrsRw/I0W3kgyJqDCPf+1s3A0qxsGRTTQ
         DYiOoU7F01VJzL5ZL+pbgg8yEaIpbxslAKsS7iabo4DSG7X4qO5JN8eRPY75PVbEkz
         RYKI6ki84tuGJ/BH0QMbHsBC3F+vkJRoxZmrDydo=
Received: from MURUGANA (unknown [49.204.222.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: murugana@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0ABB0601D7;
        Sun, 11 Nov 2018 07:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541920434;
        bh=xVERuKtB9sBlygwXNCNIFMQMGPbyBqogxC/wZ4ayJd0=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=dT6y9FaxqoUOeVbQuxme4kkoAADePhhLDlWtALmRC7cHpVX/IFAYv8I5x47jzp3rf
         3QxVH04F4BA3sTzU1In0RcNx2dfdpe5oxrqHLusslwYKcz8t7bmDoyUJPnWARjZl/z
         drCYEA2OmerypR9B8N/MN2/T8CdEL/DjgVWoHFtQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0ABB0601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=murugana@codeaurora.org
From:   <murugana@codeaurora.org>
To:     "'Sebastian Gottschall'" <s.gottschall@newmedia-net.de>,
        "'Sathishkumar Muruganandam'" <murugana@codeaurora.org>,
        <ath10k@lists.infradead.org>
Cc:     <linux-wireless@vger.kernel.org>
References: <20181109061121.4184-1-murugana@codeaurora.org> <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
In-Reply-To: <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
Subject: RE: [EXTERNAL] Re: [PATCH] ath10k: Disable 4addr source port learning in 10.4 FW by default
Date:   Sun, 11 Nov 2018 12:43:51 +0530
Message-ID: <00fd01d4798e$1c0d2f10$54278d30$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQHUeP7B/9B/1NCYoEyKFi2aLrWyJ6VKKEhw
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sebastian,

> after tested 2 WDS devices (one WDS AP, one WDS STA) with 9984 =
(netgear
> r7800) i found out that the issue persists. gtk rekeying fails, so =
disconnect and
> reconnect after 60 minutes.

Are you using the latest FW 10.4-3.6.0.1-00003 for 9984 ( mainly on the =
AP side ) ?

(https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.=
git/commit/?id=3Da00e61b9203186561dc90de1ff7ed4d5f5e920d5)

Thanks,
Sathishkumar



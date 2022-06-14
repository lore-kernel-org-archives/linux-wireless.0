Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C4FCCA481
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jun 2022 10:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbiFNK7P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Jun 2022 06:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiFNK64 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Jun 2022 06:58:56 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46421286C1;
        Tue, 14 Jun 2022 03:58:55 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655204333; bh=3J3mVf8fkTb1aWQ9iHVwbsZZInuzpCUmrtDUqRR2EY4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gw0X/ikrjQzYjbApomAYSEz95DpMIHqaWENnafSB7pvMqyjIfcvaxBADDEnJ3awHn
         qWPfr+QmNnV2xnPl8Z+MdBji4YMIWBp0MfERPWuEwRtNVPwoHKtflRnW5/Jas71YzJ
         6Q1feIeHHJYMd9LeppeZoVrIhCXlCcKZfDRGyNqxtreBiVOCelaNM/tz6fv/IVT/7p
         jPSO0L10RIAi0W4FXc2jMzqPX/zEBDI4sRmEQd/hBAZ7DqMQwxiDTpm5nDkv4o3VJF
         OFFT8j4PdNF3TLTsAG0yIs0uOMhAvQRatyeinVFrEvPi4woIdu0d0fwwuYQrQCoetv
         egjgHPtv86wTg==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v6 2/2] ath9k: htc: clean up statistics macros
In-Reply-To: <ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
 <ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com>
Date:   Tue, 14 Jun 2022 12:58:53 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87letzzf2q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> I've changed *STAT_* macros a bit in previous patch and I seems like
> they become really unreadable. Align these macros definitions to make
> code cleaner and fix folllowing checkpatch warning
>
> ERROR: Macros with complex values should be enclosed in parentheses
>
> Also, statistics macros now accept an hif_dev as argument, since
> macros that depend on having a local variable with a magic name
> don't abide by the coding style.
>
> No functional change
>
> Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

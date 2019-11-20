Return-Path: <SRS0=CMgv=ZM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6DC432C3
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 18:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B437A20878
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 18:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="etIe6isw";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="g1CVqzDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfKTSNO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:13:14 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:59316
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbfKTSNO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Nov 2019 13:13:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574273593;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=xmPoWJedJrCKD61KfRvoRSiceCiO/LCBFJ7gw4x8USI=;
        b=etIe6isw01v3n1lF3HaHFEO2PJm+WBPTDnASFRNqBasLnmgNQdZHfFHvV+692aIV
        3OYFsx+TOduP/dRl5Z6eq0YdPkz9BQCk1zUfJkoH1bluV2L2r/qZvgtWs6ijChNUU02
        6saGJiq47ScPPfLAMb0YDO5H8hbDjPVCsoUrGSaA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574273593;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=xmPoWJedJrCKD61KfRvoRSiceCiO/LCBFJ7gw4x8USI=;
        b=g1CVqzDpFdPYQFSopEd73mmtXIr2T/fFynz6Mz/Tx5CG/n5jq0sqszrrbdOO8cVI
        YfW7IzDFBB2CJ4Tx2oPzLLxfQ7pz06p4tjr6GnOpI2Di7qEOimvqxqR0YEtUFH0yNqF
        AzA0CuZF0VYFa67NjKX/elpST4JFFd4HpL4JCdtg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF079C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2019-11-20
References: <0a95938f-78d4-03a5-9d38-0e3502b7a965@nbd.name>
Date:   Wed, 20 Nov 2019 18:13:13 +0000
In-Reply-To: <0a95938f-78d4-03a5-9d38-0e3502b7a965@nbd.name> (Felix Fietkau's
        message of "Wed, 20 Nov 2019 13:31:54 +0100")
Message-ID: <0101016e8a04af3b-2c73450e-97e8-4872-a05c-43720f51e506-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.20-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's my first pull request for 5.5
>
> - Felix
>
> The following changes since commit eac08515d7bd665d306cefa2ae9f3de56e875d6d:
>
>   rtl8xxxu: Remove set but not used variable 'vif','dev','len' (2019-11-20 09:47:19 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-11-20
>
> for you to fetch changes up to 23cb16d2ccb5f819d7acff602e5a153157bf2884:
>
>   mt76: mt76u: fix endpoint definition order (2019-11-20 13:23:51 +0100)
>
> ----------------------------------------------------------------
> mt76 patches for 5.5
>
> * monitor mode fix for mt7615
> * fixes for rx aggregation race conditions
> * cleanups
> * mt7615 smart carrier sense support
> * code unification / deduplication
> * mt7615 debugfs improvements
> * debugfs aggregation statistics
> * airtime fairness support
> * mt76x0 OF mac address support
> * locking fixes
> * usb support improvements
> * rate control fixes
>
> ----------------------------------------------------------------

Pulled, thanks Felix.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

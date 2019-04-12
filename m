Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817E5C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B741218C3
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o80O7T/5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D6klLzkR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfDLScI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:32:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfDLSb7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 14:31:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D98C61788; Fri, 12 Apr 2019 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555093918;
        bh=FoZc+pCuaLV+Uq40sSsFhJQjy/CeyouWNY8uMKKWa20=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o80O7T/54FZWb5csy9bFA2g4OwWyo9UAuNRzGP7BhdBmMfg3J42zsdIxsFhDzXDWb
         2jN5oeaF6juHrIApgUmXQCucIwEZnbeVsiZref5RuXgZSMK6DtBduzgE4XW8CMOezV
         bzCh5x7QnI5NHDWRoEhVYqrvOeCy2YrBsMWid4fk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B87C616D3;
        Fri, 12 Apr 2019 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555093914;
        bh=FoZc+pCuaLV+Uq40sSsFhJQjy/CeyouWNY8uMKKWa20=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=D6klLzkR0gfg9vsDnNKbcMzToUKVIvgykZq8JHuOSKCNyH+Yw1u1JwAmSgKknEzYj
         lC7glMiuee9OZfe/+pEaBs3t2otivQHyhBHb2wuy6h8fhFvGnIALOraxSrQdUsPp4B
         N6vBwQ5N3DwJFvWt7+dAq8XUPp2xacAjkChGULaQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B87C616D3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.1] rt2x00: do not increment sequence number while
 re-transmitting
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1553680997-19511-1-git-send-email-sgruszka@redhat.com>
References: <1553680997-19511-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Vijayakumar Durai <vijayakumar.durai1@vivint.com>,
        stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190412183158.6D98C61788@smtp.codeaurora.org>
Date:   Fri, 12 Apr 2019 18:31:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> From: Vijayakumar Durai <vijayakumar.durai1@vivint.com>
> 
> Currently rt2x00 devices retransmit the management frames with
> incremented sequence number if hardware is assigning the sequence.
> 
> This is HW bug fixed already for non-QOS data frames, but it should
> be fixed for management frames except beacon.
> 
> Without fix retransmitted frames have wrong SN:
> 
>  AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1648, FN=0, Flags=........C Frame is not being retransmitted 1648 1
>  AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1649, FN=0, Flags=....R...C Frame is being retransmitted 1649 1
>  AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1650, FN=0, Flags=....R...C Frame is being retransmitted 1650 1
> 
> With the fix SN stays correctly the same:
> 
>  88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=........C
>  88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C
>  88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Vijayakumar Durai <vijayakumar.durai1@vivint.com>
> [sgruszka: simplify code, change comments and changelog]
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

746ba11f1706 rt2x00: do not increment sequence number while re-transmitting

-- 
https://patchwork.kernel.org/patch/10873171/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


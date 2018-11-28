Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179C1C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 10:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF23020660
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 10:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nwfrxBDu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MdKyXRha"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF23020660
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbeK1VQn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 16:16:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeK1VQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 16:16:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BF5E660C4C; Wed, 28 Nov 2018 10:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543400134;
        bh=HHI/tec+aXbDONvF8QmDC1/5011vlqmgXDNd3M6vJ8E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nwfrxBDuyJFhwkXF3W1JPplt9SVE/4L51MxqabI3w4eHTD9S2Eii9JtXn6HERsPK+
         NRam8h9JvGrZOY9uOQMBdTXzd8wmvvjTXjOpAJgJSSWxEjiRDwRJx1Sn6pmCx0w8oz
         RiY3AqYRaA5qsJKk6EAFoceVXyPjqbBy28nlK6Sg=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7A8E61341;
        Wed, 28 Nov 2018 10:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543400130;
        bh=HHI/tec+aXbDONvF8QmDC1/5011vlqmgXDNd3M6vJ8E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MdKyXRhaBnTDdDr+1pMYs1R+ql7IuXot+MHrSU9ckHp1xKSkjfRHrTsEn9KopzSUq
         FeE7aSCzM3XV9buo7rbggWidLljNw7rQtWS7Br46ysw0R2YVmwikNqhJ1TtOjCDn3o
         5NZLNy832zgkGdOenvcUIj5RKJ0H9ahyETjZXrws=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A7A8E61341
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
Date:   Wed, 28 Nov 2018 12:15:27 +0200
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com> (Lorenzo
        Bianconi's message of "Tue, 27 Nov 2018 23:21:07 +0100")
Message-ID: <8736rla4ow.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> This series is intended as a playground to start experimenting/developing
> with XDP/eBPF over WiFi and collect ideas/concerns about it.
> Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> actions are:
> - XDP_PASS
> - XDP_ABORTED
> - XDP_DROP
> Introduce ndo_bpf mac80211 callback in order to to load a bpf
> program into low level driver XDP rx hook.
> This series has been tested through a simple bpf program (available here:
> https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> used to count frame types received by the device.
> Possible eBPF use cases could be:
> - implement new statistics through bpf maps
> - implement fast packet filtering (e.g in monitor mode)
> - ...

This is most likely a stupid question, but why do this in the driver and
not in mac80211 so that all drivers could benefit from it? I guess there
are reasons for that, I just can't figure that out.

-- 
Kalle Valo

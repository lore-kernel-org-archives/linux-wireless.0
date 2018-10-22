Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481C8C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 14:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E05920663
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 14:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qce9fAA5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E05920663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbeJVWzM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 18:55:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35765 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbeJVWzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 18:55:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id a10-v6so2157356qtp.2;
        Mon, 22 Oct 2018 07:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zMCfFZVD8jn3qeNBBGupLqso7s63gETnkwsrBrjLmJ4=;
        b=qce9fAA5XUzJ/dmLtJ9OLyRnaAVdkMGofj/WO2KlkkbwCAQ/nk5eL98vWVnJXFKy8p
         a/i3VjI5hCC+y2QiW+wy1LSNkMeVjBJnW0mT3mTQyTiNnB94CXGQAUA6dsouFKDTPdd5
         pnHbQbVMo2LY9eNABeMvuEP/z6ixmRMSKeQCXqMGeLsWkaz61wbaVsJZ2vR8BrQSvrm6
         hszr3ChnRWoLnrJlIdFkiKfZyrZuta5ahyL+1W+SKTZNKNs/68OVz0fSXgOXbJUUutUK
         eoJuuvZLn7SzvpKZYhifoxgn5pimo55P2NOck85brdcdrNtUqtp5N3/+w+DVEe04b2RL
         319A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zMCfFZVD8jn3qeNBBGupLqso7s63gETnkwsrBrjLmJ4=;
        b=Om0tqQzJBR9dwdj1p6lHLxGCermggecZUbSbvl+HNQXyf8RZdBqJzjBZXMrZKVEId/
         2zHG/TQuXz6drolqLZVUZtUxjsJQJ0nDT/VaqFduutJHkiukLXyPb9fhOn8h1NrKa89M
         /nXMJ5GrQ3HCAsJ8tkVW8XvnMFrdsRamCE6Tk9EZ+Z64iH5Dx4hXGDk/QmGIemv0LbOF
         aJrBGIW9SlV/Y9nrYm42Oxx+ZPZCdUFHSFEDP1O9wUqj/t4Ft2VicNeajh0oI2ggPt/6
         jEumVKVSP8WR4x4wKYev+Iozo9LmXcs/+xxxfWBReIrmhOyZM7dWM4rzUhtgUXedx+r6
         4exg==
X-Gm-Message-State: ABuFfoiV+ph/DSyVfUOUgy3lgs1BrBEnWquu1+GpSsAe6uMMOpRe2vP0
        D7HVXr6jWwi00FWn1IQhdq+VZzef
X-Google-Smtp-Source: ACcGV61Hb0BjvO5Xzp32Bt90ixy4BSoRX21xQTJekSTu2zyZ8h2eDClyGwQDzPHEw1/RaO5QNR7lCA==
X-Received: by 2002:a0c:b257:: with SMTP id k23mr39827830qve.87.1540218981795;
        Mon, 22 Oct 2018 07:36:21 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10e0::2ed7? ([2620:10d:c091:200::5:dfe9])
        by smtp.gmail.com with ESMTPSA id r26-v6sm8366255qtr.49.2018.10.22.07.36.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 07:36:20 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/2] Mark expected switch fall-throughs and fix missing
 break
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <cover.1540208577.git.gustavo@embeddedor.com>
Message-ID: <a1b9b68a-ca94-f02f-4a87-bbd46782c41c@gmail.com>
Date:   Mon, 22 Oct 2018 10:36:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <cover.1540208577.git.gustavo@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/22/18 7:49 AM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, this patchset aims
> to mark multiple switch cases where we are expecting to fall through.
> 
> Also, the second patch in this series fixes a missing break in switch.

Enabling that sounds like a great way to inflict pain and suffering.

Not a big deal to put that in the code, the second patch looks fine though.

Jes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50455 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaERKSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 06:18:35 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so4985114oag.9
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2014 03:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <537880A4.1040102@hauke-m.de>
References: <1400365358-19604-1-git-send-email-zajec5@gmail.com>
	<537880A4.1040102@hauke-m.de>
Date: Sun, 18 May 2014 12:18:34 +0200
Message-ID: <CACna6ryoHtc7tLNUwynJKP70VyqGtKk0PsMqw83cfDzsRnOg3A@mail.gmail.com> (sfid-20140518_121850_209060_DD1C56CD)
Subject: Re: [PATCH] ssb: sprom: add dev_id field for value overriding
 standard ID
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 May 2014 11:43, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> There is also a vendid var which should be used. See this code from
> brcmsmac:
> http://lxr.free-electrons.com/source/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c?v=3.0#L660

You're right, but is this used anywhere?

I can't reliably follow brcmsmac code, it copies the same data over
and over. Simple grepping for "vendorid" shows copying from "vendorid"
to "vendorid" of various structs, no real usage.
The one exception is "sha_params.vid = wlc_hw->vendorid;. However grepping with:
grep -R "\.vid" ./*
grep -R "\->vid" ./*
doesn't reveal any usage neither.

Seems like a dead code.

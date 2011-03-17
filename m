Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64239 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1CQSii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:38:38 -0400
Received: by iyb26 with SMTP id 26so3106408iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:38:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=GPbB6EbWCGGjRupwsBLMaVt=ymO5hb9eU-Q+r@mail.gmail.com>
References: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com> <AANLkTi=GPbB6EbWCGGjRupwsBLMaVt=ymO5hb9eU-Q+r@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 17 Mar 2011 11:38:18 -0700
Message-ID: <AANLkTinVaFcD8L9kOjPW-y7pVxR0ReHsLBy6=SG=8OJC@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k_hw: Fix pcie_serdes setting for AR9485 1.1 version.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 5:04 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Feb 25, 2011 at 4:01 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>
> Was this a stable fix? If not why not?

This certainly smells like a stable fix, this seems similar to this other fix:

commit 58c5296991d233f2e492aa7a884635bba478cf12
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Thu Jan 13 18:19:29 2011 -0800

    ath9k_hw: ASPM interoperability fix for AR9380/AR9382

    There is an interoperability with AR9382/AR9380 in L1 state with a
    few root complexes which can cause a hang. This is fixed by
    setting some work around bits on the PCIE PHY. We fix by using
    a new ini array to modify these bits when the radio is idle.

    Cc: stable@kernel.org
    Cc: Jack Lee <jack.lee@atheros.com>
    Cc: Carl Huang <carl.huang@atheros.com>
    Cc: David Quan <david.quan@atheros.com>
    Cc: Nael Atallah <nael.atallah@atheros.com>
    Cc: Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Without this patch I believe we will get AR9485 hanging in L1 state
with some root complexes. Can someone confirm?

Vivek, in the future can you please elaborate a little more on the
commit log entries and if its a "fix" of some sort elaborate on the
impact of not applying th patch.

Thanks,

  Luis

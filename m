Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53492 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1HYMSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 08:18:55 -0400
Received: by gya6 with SMTP id 6so1685271gya.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 05:18:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314265865-20208-1-git-send-email-arik@wizery.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
Date: Thu, 25 Aug 2011 14:18:54 +0200
Message-ID: <CAGXE3d9mB_jjg38Mmf+B-1RYXjFp0h2hJDkRa+c2wO_OG+BDSw@mail.gmail.com> (sfid-20110825_141858_790676_3C446C3D)
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Aug 25, 2011 at 11:51 AM, Arik Nemtsov <arik@wizery.com> wrote:
> When this flag is set, Tx aggregations will not be initiated even
> if the hardware supports A-MPDU aggregation in general. This flag
> is required for devices supporting (partial) software Rx-aggregation.

Is the hardware unable to do TX aggregation?
Or is it just not implemented?
Or is it entirely done in hw?

Instead of cluttering mac80211 with hw flags you could also just disallow tx
aggregation sessions in the ampdu_action callback in the driver.

Helmut

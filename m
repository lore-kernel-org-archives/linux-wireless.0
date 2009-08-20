Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:52994 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZHTO4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 10:56:34 -0400
Received: by iwn42 with SMTP id 42so422088iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 07:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250755874-32652-1-git-send-email-vasanth@atheros.com>
References: <1250755874-32652-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 20 Aug 2009 07:56:13 -0700
Message-ID: <43e72e890908200756m74be271cvea96932efb4be140@mail.gmail.com>
Subject: Re: [PATCH v2] ath9k: Fix bug in retrieving average beacon rssi
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 1:11 AM, Vasanthakumar
Thiagarajan<vasanth@atheros.com> wrote:
> Currently the beacon rssi that LPF gives is divided and rounded
> up by ATH_RSSI_EP_MULTIPLIER twice. This will leave the incorrect rssi
> in ANI. Having correct rssi in ANI fixes the connection stability at
> < 30dB rssi range. This patch removes the unncessary computation of average
> rssi over already valid average rssi. Also removes the redundant macros to
> find average rssi.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Thanks Vasanth, John, this has a better description, if its not too
much trouble can you revert 6b82e95960c858e6babf1def7276847e8da8cc25
in favor for this one?

  Luis

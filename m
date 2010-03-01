Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35744 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0CAXZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 18:25:05 -0500
Received: by pva4 with SMTP id 4so676404pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 15:25:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19339.35506.86567.739868@gargle.gargle.HOWL>
References: <19339.35506.86567.739868@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 15:24:45 -0800
Message-ID: <43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 1:36 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> All code to be shared between ath9k and ath9k_htc
> is part of a common library. This reduces module
> proliferation.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Interesting approach, instead of having two modules you linked lib.o
twice to two separate modules, ath9k.ko and ath9k_htc.ko. While this
does reduce module proliferation is there any advantage to that over
the approach of stuffing these into one common module shared between
both?

The benefit of doing it as a module is if both are built-in you reduce
the final kernel size. On my box with debugging this is 256 KB.

  Luis

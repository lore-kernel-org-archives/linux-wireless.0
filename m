Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35764 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1KPXIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:08:07 -0500
Received: by bke11 with SMTP id 11so1223193bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 15:08:04 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: [PATCH] p54spi: Fix workqueue deadlock
Date: Thu, 17 Nov 2011 00:07:58 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20111116235546.096975f6@milhouse>
In-Reply-To: <20111116235546.096975f6@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111170007.58457.chunkeey@googlemail.com> (sfid-20111117_000811_223623_16472463)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, November 16, 2011 11:55:46 PM Michael Büsch wrote:
> priv->work must not be synced while priv->mutex is locked, because
> the mutex is taken in the work handler.
> Move cancel_work_sync down to after the device shutdown code.
> This is safe, because the work handler checks fw_state and bails out
> early in case of a race.
> 
> Signed-off-by: Michael Buesch <m@bues.ch>
Cc: <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

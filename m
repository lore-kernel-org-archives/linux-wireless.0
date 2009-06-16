Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f185.google.com ([209.85.210.185]:64198 "EHLO
	mail-yx0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFPOyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 10:54:33 -0400
Received: by yxe15 with SMTP id 15so101604yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 07:54:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090616085922.GA10176@jm.kir.nu>
References: <20090616085922.GA10176@jm.kir.nu>
Date: Tue, 16 Jun 2009 10:33:29 -0400
Message-ID: <b6c5339f0906160733l2ec28563h60145254855c3472@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix PCI FATAL interrupts by restoring
	RETRY_TIMEOUT disabling
From: Bob Copeland <me@bobcopeland.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 4:59 AM, Jouni Malinen<jouni.malinen@atheros.com> wrote:
> An earlier commit, b572b24c578ab1be9d1fcb11d2d8244878757a66, removed
> code that was documented to disable RETRY_TIMEOUT register (PCI reg
> 0x41) since it was claimed to be a no-op.

Jouni, can you confirm that e23a9014... also needs reverting?
(In this case only affects resume path).

I seem to remember the provenance of this code was copy-paste from
an intel driver, so while it does "something," the comment may not
match the code, 0x41 being vendor-defined.

-- 
Bob Copeland %% www.bobcopeland.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:64891 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0DXKwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 06:52:03 -0400
Received: by qyk9 with SMTP id 9so14510266qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Apr 2010 03:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <w2x55d522f11004232132ze7fcf8fdk54c2c8bfae72c64@mail.gmail.com>
References: <w2x55d522f11004232132ze7fcf8fdk54c2c8bfae72c64@mail.gmail.com>
Date: Sat, 24 Apr 2010 18:52:01 +0800
Message-ID: <l2id82e647a1004240352vd82f1631t6391832b04f74978@mail.gmail.com>
Subject: Re: [PATCH] ath9k: use spin_lock_bh() instead of spin_lock() in
	ath_tid_drain()
From: Ming Lei <tom.leiming@gmail.com>
To: Jongman Heo <jongman.heo@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/24 Jongman Heo <jongman.heo@gmail.com>:
> commit a9f042cb ("ath9k: fix lockdep warning when unloading module")
> changed spin_[un]lock() to
> spin_[un]lock_bh() in ath_tx_node_cleanup(), but didn't change those
> in ath_tid_drain().

Did you see any lockdep warning due to ath_tid_drain?

It is not necessary since bh has been disabled before calling
ath_tid_drain.


-- 
Lei Ming

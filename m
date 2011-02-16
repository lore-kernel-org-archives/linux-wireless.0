Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33324 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab1BPK04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 05:26:56 -0500
Received: by qwa26 with SMTP id 26so1109473qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 02:26:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110216011203.GA5773@linux-mips.org>
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
	<4D5AD6A6.8090505@gmail.com>
	<AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>
	<4D5AE52B.80002@gmail.com>
	<AANLkTinnCOEXF835yhNeJDfBdKjx_dss6TFeUmjL-Yk2@mail.gmail.com>
	<4D5AFB3B.6080407@gmail.com>
	<4D5AFBCB.1090907@gmail.com>
	<20110216011203.GA5773@linux-mips.org>
Date: Wed, 16 Feb 2011 10:26:55 +0000
Message-ID: <AANLkTimP1r1A6nzcfh7kP=Hmcq9Cgha5Du28hE3zOs0x@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, the problems are in openwrt platform patches that should be rewriten:
1. Changes needed to avoid using code like "mem=res->start" without ioremap.
2. Changes needed to avoid using NULL in first argument of
dma_alloc_coherent and others.

Without these changes ahb patch won't get into the kernel and we'll be
lack of wisoc devices support?
Is there any chance for the patch to get into the kernel and what
should be done for it?

(PS: Sorry for my english.)

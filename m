Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39896 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1HNRLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 13:11:03 -0400
Date: Sun, 14 Aug 2011 19:10:37 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH V2 3.2 2/2] b43: fix DMA on some bugged hardware
Message-ID: <20110814191037.043b0839@milhouse> (sfid-20110814_191110_031784_4852384D)
In-Reply-To: <1313343581-4395-2-git-send-email-zajec5@gmail.com>
References: <1313343581-4395-1-git-send-email-zajec5@gmail.com>
	<1313343581-4395-2-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 14 Aug 2011 19:39:41 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> Some hardware with 64-bit DMA uses lower address word for setting
> routing (translation) bit. Add workaround for such boards.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: use (u64) to fix compilation on 32-bit systems

Note that there are the upper_32_bits() and lower_32_bits()
macros in kernel.h to address this problem.

-- 
Greetings, Michael.

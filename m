Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48608 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0E1U17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 16:27:59 -0400
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
From: Pavel Roskin <proski@gnu.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <20100528212523.213125g8t0an4mn4@hayate.sektori.org>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1275063576.15168.14.camel@mj>
	 <20100528212523.213125g8t0an4mn4@hayate.sektori.org>
Content-Type: text/plain
Date: Fri, 28 May 2010 16:27:56 -0400
Message-Id: <1275078476.18152.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 21:25 +0300, Jussi Kivilinna wrote:
> I used code from e1000e which does this same way, which now suddenly  
> reminds me of that ath5k is dual lisenced, right? Can I even reuse  
> code from GPL driver in ath5k?

That's another reason why we don't want this code to be all over the
place.

If you could generalize the code sufficiently, it could be an inline
function in pci.h or some other GPL licensed header.

If we need to add GPL code to ath5k, it could go to a separate file.
But if that separation becomes inconvenient, we could drop BSD
compatibility from ath5k.  I don't see any benefit from dual licensing,
unless some existing ath5k contributors are BSD developers who would
stop working on the code in case of relicensing, but I don't think it's
the case.

-- 
Regards,
Pavel Roskin

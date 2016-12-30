Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49072 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbcL3Lex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:34:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: orinoco: Use shash instead of ahash for MIC calculations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
References: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
To: Andrew Lutomirski <luto@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
Message-Id: <20161230113451.C10ED614E4@smtp.codeaurora.org> (sfid-20161230_123521_657078_35C1024F)
Date: Fri, 30 Dec 2016 11:34:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Lutomirski <luto@kernel.org> wrote:
> Eric Biggers pointed out that the orinoco driver pointed scatterlists
> at the stack.
> 
> Fix it by switching from ahash to shash.  The result should be
> simpler, faster, and more correct.
> 
> Cc: stable@vger.kernel.org # 4.9 only
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

11 patches applied to wireless-drivers-next.git, thanks.

1fef293b8a98 orinoco: Use shash instead of ahash for MIC calculations
a08b98196a36 rt2800: make rx ampdu_factor depend on number of rx chains
e49abb19d1bf rt2800: don't set ht parameters for non-aggregated frames
a51b89698ccc rt2800: set minimum MPDU and PSDU lengths to sane values
8f03a7c6e7f9 rt2800: set MAX_PSDU len according to remote STAs capabilities
8845254112ac rt2800: rename adjust_freq_offset function
bc0077053948 rt2800: warn if doing VCO recalibration for unknow RF chip
24d42ef3b152 rt2800: perform VCO recalibration for RF5592 chip
d96324703ffa rt2x00: merge agc and vco works with link tuner
eb79a8fe94c8 rt2800: replace mdelay by usleep on vco calibration.
31369c323ba0 rt2800: replace msleep() with usleep_range() on channel switch

-- 
https://patchwork.kernel.org/patch/9471353/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

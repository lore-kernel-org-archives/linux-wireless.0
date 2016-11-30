Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:43877 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161161AbcK3KyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 05:54:15 -0500
Subject: Re: Atheros ETSI DFS pattern
To: voncken <cedric.voncken@acksys.fr>, linux-wireless@vger.kernel.org
References: <012101d24af3$40bb97f0$c232c7d0$@acksys.fr>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <2fe8be5d-9f34-7a2f-d825-ca39e5facaae@neratec.com> (sfid-20161130_115450_568638_67D0478E)
Date: Wed, 30 Nov 2016 11:54:11 +0100
MIME-Version: 1.0
In-Reply-To: <012101d24af3$40bb97f0$c232c7d0$@acksys.fr>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2016 11:19 AM, voncken wrote:
> In the file drivers/net/wireless/ath/dfs_pattern_detector.c we can found the
> ETSI pattern definition.
> 
> In this definition we can found 7 patterns (0 to 6).
> 
> The ETSI standard EN 301893 Annex D only specifies 6 patterns. Only the
> pattern 1 to 6 defined in the ath dfs pattern match with the ETSI standard.
> 
> Why the pattern 0 is defined?
> 
> Is it possible to remove this pattern and keep compliant with the ETSI
> standard?
> 
> Thanks for your help.
> 
> Cedric.
> 
Hi,

pattern 0 is the 'reference DFS test signal', the 700Hz pattern with 18 pulses
each 1us wide.

At implementation time, EN301893 v1.5 was the current revision and the reference
pattern is defined in Table D.3. I double checked that v1.8.1 has this one still
defined, so it remains required.

Given that most basic DFS features in certification labs are tested with this
pattern, I don't expect it to be obsoleted any time.

Out of curiosity: why would you like it removed? From the false-detection
probability, pattern 0 is uncritical (the tricky one is pattern 1).


Cheers,
Zefir

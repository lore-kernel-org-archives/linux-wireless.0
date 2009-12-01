Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZLASwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 13:52:19 -0500
Subject: Re: Panic in iwl3945 driver
From: reinette chatre <reinette.chatre@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259659724.12157.110.camel@debian>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop> <1259659724.12157.110.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 10:52:24 -0800
Message-Id: <1259693544.4653.126.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-12-01 at 01:28 -0800, Zhu, Yi wrote:
> On Tue, 2009-12-01 at 06:35 +0800, Maxim Levitsky wrote:
> > 0x000000000001668e <iwl3945_rx_reply_tx+302>:	lea    0x38(%r8),%rdi
> > 0x0000000000016692 <iwl3945_rx_reply_tx+306>:	lea    0x4f(%r8),%rax
> 
> When this happened, from your previous post, r8 is 0x0 and rdi is 0x38.
> Since "info" is %rdi (see below), this means
> txq->txb[txq->q.read_ptr].skb[0], aka. r8 is 0.

I agree with your conclusion here that r8 is 0 at this point. I am very
confused how this can be since the two lines above the ones you pasted
here are:

0x0000000000016683 <iwl3945_rx_reply_tx+291>:»­­mov    (%rdx,%rax,1),%r8
0x0000000000016687 <iwl3945_rx_reply_tx+295>:»­­mov    $0x0,%rdx

>From the information in the post you refer to we have rdx as
0xffffffffa0c85f40 and rax as 0x4f. Since r8 is initialized above from
these two registers ... how could it be that r8 ends up as zero?

Reinette



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40638 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbXIXRgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:36:20 -0400
Date: Mon, 24 Sep 2007 18:36:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and initvals
Message-ID: <20070924173607.GA652@infradead.org>
References: <3175698652466923884@pripojeni.net> <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com> <1190654876.18521.276.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190654876.18521.276.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2007 at 07:27:56PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-24 at 13:24 -0400, Luis R. Rodriguez wrote:
> 
> > * ath5k_hw_set_rfgain_opt() is defined once and used once, can we
> > instead make it inline? If we really are not going to re-use this
> > later why do we put it into a routine on its own?
> 
> Why mark it inline then? The compiler will inline it anyway if it's only
> used once. And I haven't looked at the code but making it an own routine
> could possibly make the code more readable, especially if lots of
> indentation is involved.`

Seconded.  Splitting things up into logically sound subroutines is
good programming style.

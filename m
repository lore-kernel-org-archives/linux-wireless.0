Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43317 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2IGTAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 15:00:17 -0400
Date: Fri, 7 Sep 2012 14:54:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"gwingerde@gmail.com" <gwingerde@gmail.com>,
	"heinold@inf.fu-berlin.de" <heinold@inf.fu-berlin.de>
Subject: Re: [PATCH v2] rt2x00: add MediaTek/RaLink Rt3352 WiSoC
Message-ID: <20120907185407.GB1854@tuxdriver.com> (sfid-20120907_210023_029955_30C82A9E)
References: <20120821235349.GA14648@earthship.home>
 <20120822105110.GC6082@redhat.com>
 <20120824152542.GA32145@earthship.home>
 <20120828124214.GA8426@redhat.com>
 <503CBEF8.7010505@allnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503CBEF8.7010505@allnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2012 at 03:52:08PM +0300, Daniel Golle wrote:
> Hi Stanislaw,
> 
> On 28/08/12 15:42, Stanislaw Gruszka wrote:
> > Thanks. Could you also provide information what was the source
> > (registers programming) you based when writing this patch?
> The vendor-driver Allnet got for that board (which is not publicly available and
> we can't release its source)
> 
> >> +	if (rt2x00_rt(rt2x00dev, RT3352)) {
> >> +		rt2800_bbp_write(rt2x00dev, 27, 0x0);
> >> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> >> +		rt2800_bbp_write(rt2x00dev, 27, 0x20);
> >> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> > 
> > Writes two times to the same registers are intended?
> Yes, as this is how it is done in the vendor driver, to me it looks like
> register 27 acts as a switch selecting the destination for the value written to
> register 62 or something like that.

Daniel,

Could you perhaps repost a new patch with a "finalized" commit message
that covers the original patch and addresses Stanislaw's concerns
in a single, neat message?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

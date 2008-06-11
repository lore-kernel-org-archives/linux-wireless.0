Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36680 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFKB2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 21:28:45 -0400
To: mb@bu3sch.de
Cc: vegard.nossum@gmail.com, miles.lane@gmail.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>]
 :b43:b43_dma_mapping_error+0x16/0x155
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200806101650.27180.mb@bu3sch.de>
References: <200806101637.11473.mb@bu3sch.de>
	<19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
	<200806101650.27180.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080611095844J.fujita.tomonori@lab.ntt.co.jp> (sfid-20080611_032910_377732_72148995)
Date: Wed, 11 Jun 2008 09:58:44 +0900
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jun 2008 16:50:26 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
> > This change comes from
> > 
> > commit 353c409463ecba63c3a41a992d3f5fba935eada9
> > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date:   Fri May 23 19:02:30 2008 +0000
> 
> 
> Ok, FUJITA Tomonori, please make sure a patch like the following goes
> into the same trees that you submitted commit 353c409 to.
> Also make sure to check b43legacy. I _guess_ you might have added
> the same bug there.

Ah, sorry about the bug.

>From a quick look, mainline needs the same fix too?

b43_dma_mapping_error calls unmap_descbuffer() on the failure, which
assumes that ring->dev is set up properly.

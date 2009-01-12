Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbZALTjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:39:06 -0500
Subject: Re: [PATCH v3] libertas: if_spi, driver for libertas GSPI devices
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Colin McCabe <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <45e8e6c40901121104r1f55894dy35d7528e8174f036@mail.gmail.com>
References: <1231541889-7999-1-git-send-email-colin@cozybit.com>
	 <1231772017.23907.3.camel@localhost.localdomain>
	 <45e8e6c40901121104r1f55894dy35d7528e8174f036@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:37:52 -0500
Message-Id: <1231789072.28887.11.camel@localhost.localdomain> (sfid-20090112_203913_227624_EF09E80A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-12 at 11:04 -0800, Andrey Yurovsky wrote:
> Hi Dan, Johannes was correct -- the explicit get_unaligned_ was not
> needed and using packed was required.  Unfortunately our patch got
> merged before we had a chance to send a version including just the
> packing, so I'm preparing a patch that reverts the calls to
> get_unaligned_* ...this is, however, independent of the actual
> if_spi.c driver patch.

Yes, they are independent.  Alternatively, you could just ask John to
revert the patch, and then provide a new patch with just the 'packed'
bits, which might be cleaner in the git history.

Dan



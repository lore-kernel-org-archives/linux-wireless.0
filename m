Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37458 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZALTEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:04:21 -0500
Received: by bwz14 with SMTP id 14so32677202bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 11:04:19 -0800 (PST)
Message-ID: <45e8e6c40901121104r1f55894dy35d7528e8174f036@mail.gmail.com> (sfid-20090112_200426_760874_A6CA6AF5)
Date: Mon, 12 Jan 2009 11:04:18 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH v3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Colin McCabe" <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1231772017.23907.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1231541889-7999-1-git-send-email-colin@cozybit.com>
	 <1231772017.23907.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan, Johannes was correct -- the explicit get_unaligned_ was not
needed and using packed was required.  Unfortunately our patch got
merged before we had a chance to send a version including just the
packing, so I'm preparing a patch that reverts the calls to
get_unaligned_* ...this is, however, independent of the actual
if_spi.c driver patch.

On Mon, Jan 12, 2009 at 6:53 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2009-01-09 at 14:58 -0800, Colin McCabe wrote:
>> Add initial support for libertas devices using a GSPI interface.  This has
>> been tested with the 8686.
>>
>> GSPI is intended to be used on embedded systems. Board-specific parameters are
>> required (see libertas_spi.h).
>
> Were you able to take a look at the alignment patches and see if just
> using 'packed' worked, rather than having everything use
> get_unaligned_*?
>
> Dan
>
>
>

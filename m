Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64833 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZALTmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:42:07 -0500
Received: by bwz14 with SMTP id 14so32736531bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 11:42:05 -0800 (PST)
Message-ID: <45e8e6c40901121142k1fc6869cl2d6bd058fbacf972@mail.gmail.com> (sfid-20090112_204210_824802_06D05671)
Date: Mon, 12 Jan 2009 11:42:05 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH v3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Colin McCabe" <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1231789072.28887.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1231541889-7999-1-git-send-email-colin@cozybit.com>
	 <1231772017.23907.3.camel@localhost.localdomain>
	 <45e8e6c40901121104r1f55894dy35d7528e8174f036@mail.gmail.com>
	 <1231789072.28887.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan, that sounds better: I've asked John to please go ahead and
revert it and we'll send a new version that just packs all of the
structs.  Thanks!

  -Andrey

On Mon, Jan 12, 2009 at 11:37 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2009-01-12 at 11:04 -0800, Andrey Yurovsky wrote:
>> Hi Dan, Johannes was correct -- the explicit get_unaligned_ was not
>> needed and using packed was required.  Unfortunately our patch got
>> merged before we had a chance to send a version including just the
>> packing, so I'm preparing a patch that reverts the calls to
>> get_unaligned_* ...this is, however, independent of the actual
>> if_spi.c driver patch.
>
> Yes, they are independent.  Alternatively, you could just ask John to
> revert the patch, and then provide a new patch with just the 'packed'
> bits, which might be cleaner in the git history.
>
> Dan
>
>
>

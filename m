Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:40325 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3GDOhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 10:37:16 -0400
Received: by mail-qe0-f48.google.com with SMTP id 2so765239qea.21
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 07:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com>
References: <20130703015653.82651FAAD5@dev.laptop.org>
	<477F20668A386D41ADCC57781B1F70430EA2E0674B@SC-VEXCH1.marvell.com>
	<CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com>
Date: Thu, 4 Jul 2013 08:37:15 -0600
Message-ID: <CAMLZHHRCJTx2EPZq0U_+kCVBh3vVRa3EivhnZstEPxadSE0uVw@mail.gmail.com> (sfid-20130704_163720_773374_68FE632E)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 4, 2013 at 8:32 AM, Daniel Drake <dsd@laptop.org> wrote:
> I cannot see how the driver behaviour matches the above description
> for when the card is removed as the system is suspended. For example I
> cannot see where the SHUTDOWN command gets sent in such cases.
>
> Also, at which point do we wait upon all async commands to complete
> before shutting down? I walked through all the driver code in the
> codepaths hit when the card is removed as the system is going into
> suspend, and I found no such point. (This is why interrupts then
> arrive later, because those commands are completing.)

Also, from a more general standpoint, I would say it is bad
practice/design to leave an interrupt handler running but in a state
where it does not ACK interrupts. You're just asking for trouble. If
you really don't expect interrupts beyond a certain point, and bad
things would happen if interrupts *were* to arrive for any valid or
invalid reason, disable the interrupt and remove the handler at that
point.

Daniel

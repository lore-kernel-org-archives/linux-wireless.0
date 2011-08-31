Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62012 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1HaR4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 13:56:06 -0400
Received: by qyk15 with SMTP id 15so2622367qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 10:56:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110830181452.GA24769@suse.de>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain> <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de> <20110830014257.GI15771@broadcom.com> <20110830181452.GA24769@suse.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 31 Aug 2011 10:55:45 -0700
Message-ID: <CAB=NE6WpuHdW000qdx4M1w21U8LjKYOX4nhc4kjjiZWwZpop6Q@mail.gmail.com> (sfid-20110831_195611_170673_7FD3BA49)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
To: Greg KH <gregkh@suse.de>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 11:14 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Aug 29, 2011 at 06:42:57PM -0700, Henry Ptasinski wrote:
>> The brcmsmac driver has architectural alignment with our drivers for other
>> operating systems, and we intend to to enhance and maintain this driver in
>> parallel with drivers for other operating systems.  Maintaining alignment
>> between our Linux driver and drivers for other operating systems allows us to
>> leverage feature and chip support across all platforms.
>
> Just curious, if you really are going to try to do this, how are you
> going to handle the issue when others change the in-kernel driver in
> ways that you are not going to be allowed to make to your "internal"
> copy of the driver?

What do you mean by this?

> Also, how are you going to handle any GPL-only changes that happen to
> the code as well?

For the broadcom drivers this may be hard if people want to move GPLv2
b43 code to a permissively licensed driver... but ...

> Do you have some process in place to ensure that all
> contributions will have the proper copyright releases on it to allow you
> to make the same changes to your internal versions?

To be clear *new* code going in to a permissively licensed driver
follows the Developer's Certificate of Origin which does state the
contributor follows the file's license. Back in the hay day we thought
this was not enough and introduced a Changes-licensed-under tag but a
few upstream maintainers were not fans of it given that they did
believe the Developer's Certificate of Origin with the Signed-off-by
was enough for it. This is in fact accurate, but only if you educate
your developers to ensure they do know what the Signed-off-by means
and that they have read the Developer's Certificate of Origin. We take
care to repeat this to new contributors to our permissively licensed
drivers and would gladly help Broadcom in doing this as well.

The issues with a large GPLv2 code from b43 and the fact that the
other driver is permissively licensed makes this a bit more
complicated though, but that is only a reflection of not addressing
supporting old hardware. Ouch.

> This all is a very difficult and time-consuming task, are you sure you
> are all up to it and have properly discussed it with your legal team,
> management team, and with the kernel community?

As I see it the only difficult aspect here is large GPLv2 codebase on
b43. The rest requires just education on the Developer's Certificate
or Origin, otherwise we could not share between Linux and the BSD
families, as we had done before with other subsystems, not only
wireless.

  Luis

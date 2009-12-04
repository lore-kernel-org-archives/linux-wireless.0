Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:59795 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbZLDUtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 15:49:19 -0500
Received: by ey-out-2122.google.com with SMTP id d26so692264eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 12:49:24 -0800 (PST)
To: Jason Young <a.young.jason@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mac80211: add U-APSD client support
References: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
	<87ocmf545m.fsf@purkki.valot.fi>
	<16a81f890912041102l7bcce84eg7a8f80ff5ff341f2@mail.gmail.com>
	<16a81f890912041105y40772ee0sc5854d6354a7e90b@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 04 Dec 2009 22:49:22 +0200
In-Reply-To: <16a81f890912041105y40772ee0sc5854d6354a7e90b@mail.gmail.com> (Jason Young's message of "Fri\, 4 Dec 2009 11\:05\:03 -0800")
Message-ID: <874oo65ust.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Young <a.young.jason@gmail.com> writes:

> On Fri, Dec 4, 2009 at 4:12 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> I decided to drop Admission Control for now because I didn't see any
>> real use case for it. And if we would like to utilise it properly, we
>> would need to have properly supported user space interface. I think we
>> are not ready for that quite yet.
>>
>
> There are real use cases for WMMAC, particularly in enterprise
> environments but I don't want to get into that discussion just yet,
> first things first :)

A very good idea, otherwise we will spending the new year's eve still
planning about this :)

Let's first get the basic functionality in and then start adding more
features.

> I just wanted it to be noted somewhere in the discussion of this
> proposal that U-APSD can, in theory at least, be configured as
> trigger or delivery only. Some hardware may be implemented to allow
> trigger/delivery only configuration. In such cases, the driver will
> need to update both the trigger and delivery state based on the
> uapsd boolean parameter.

Yes, we need to take this into account in the future.

>> Thanks, I wasn't aware of this. Yes, adding the debugfs interface back
>> makes sense now. But can you describe a bit more how you would like to
>> use the debugfs interface? I would like to understand about your needs
>> a bit more.
>>
>> I also need to find the certification test plan and read it myself.
>
> Section 2.8.1 of the "WMM Power Save Test Plan Version 1.5" describes
> the basic station requirements. Section 5 describes the station
> specific tests.

Thanks for the pointers, I'll read them next week.

> I would like to be able to set the uapsd configuration of each AC
> independently, as well as the Max SP length. Basically, the bits that
> get used in the qosinfo field during association. Because this should
> just be used for testing or until we add a real userspace API, I'm
> fine with requiring the user to manually reconnect to have new U-APSD
> configuration adopted.

Makes sense. I'll include this functionality in my next version of the
patches which I hope to send early next week.

Thank you again for good comments.

-- 
Kalle Valo

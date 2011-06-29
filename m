Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41833 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1F2XXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:23:50 -0400
Received: by iyb12 with SMTP id 12so1450249iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 16:23:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309370457.2208.48.camel@aeonflux>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
 <1309292325.29598.9.camel@Joe-Laptop> <1309311096.2208.33.camel@aeonflux>
 <1309312164.29598.53.camel@Joe-Laptop> <1309370457.2208.48.camel@aeonflux>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 29 Jun 2011 20:23:30 -0300
Message-ID: <BANLkTinospg_dhTC8Tcok3kqk9gOryG6eA@mail.gmail.com> (sfid-20110630_012359_919917_BFF44393)
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Joe Perches <joe@perches.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe and Marcel,

On Wed, Jun 29, 2011 at 3:00 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Joe,
>
>> > The pr_<level> ones are nice and I wished we had them all back in the
>> > days, but the NFC ones actually could take the controller as argument
>> > and then us the dev_* versions of these commands.
>>
>> I do think that if there's a controller struct that's always
>> or mostly used with nfc_<level>, then it should be added and
>> passed to the functions arguments, maybe with NULL used where
>> necessary.
>>
>> > At this stage of the project it is a bit too early to tell I guess.
>> > > I think emitting __func__ rarely adds useful information.
>> > Depends on how you are using your debug statements. I find it really
>> > helpful since then you can keep the text detail to a minimum.
>>
>> I don't disagree that while debugging function names
>> and tracing function entries/exits are useful.
>>
>> Today, dynamic_debug can add __func__ to the output as
>> desired so I think that it's not really necessary
>> to add to any <foo>_dbg callsite.
>
> I did not know that. Then we might should go ahead and also cleanup the
> Bluetooth subsystem.

That's true only for pr_debug() function. You cannot add __func__ info
on dev_dbg() calls dynamically.

So, for net/nfc/* I propose to use directly pr_*() functions.

For device drivers the following macros would be provided:

#define nfc_dev_info(dev, fmt, arg...) dev_info((dev), "NFC: " fmt, ## arg)
#define nfc_dev_err(dev, fmt, arg...) dev_err((dev), "%s: " fmt,
__func__, ## arg)
#define nfc_dev_dbg(dev, fmt, arg...) dev_dbg((dev), "%s: " fmt,
__func__, ## arg)

What do you think?

Aloisio

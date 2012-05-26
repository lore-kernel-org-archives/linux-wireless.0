Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46910 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EZHTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 03:19:41 -0400
Received: by obbtb18 with SMTP id tb18so2290598obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 May 2012 00:19:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC07A67.6010704@broadcom.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <4FC00848.9060901@broadcom.com> <CAB=NE6XsTtJvmJDVa2toJCsjn1fxH+5cqJ8xkaquNhHcHDgh2A@mail.gmail.com>
 <4FC07A67.6010704@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Sat, 26 May 2012 00:19:20 -0700
Message-ID: <CAB=NE6V4nBnujukg_VCx3gpajiQ0o6iDCuzNy-ZEmfayy5Lmmg@mail.gmail.com> (sfid-20120526_091944_686993_A19FA68F)
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2012 at 11:38 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/26/2012 12:51 AM, Luis R. Rodriguez wrote:
>>> It took a while. There were some discussions and we agreed that your
>>> > changes establish a better integration with the regulatory framework.
>>> > There are some concerns about the content of the crda database, but that
>>> > is another thing outside the scope of your patches.
>> BTW if you would like to address anything please let me know. If you'd like
>> to review things in private too that's fine, just let me know. I
>> should say that the staging area for the next generation regulatory
>> code is being done through the regulatory simulator:
>>
>> git://github.com/mcgrof/regsim.git
>
> Thanks, Luis. I mainly focused on the crda database and it has a
> relation freqs<->pwr_limit. In our regulatory code we make a distinction
> between 11n and abg as we believe that is necessary.

Atheros had similar poo. When I reviewed the architecture behind it,
it was simply a design consideration, it had nothing to with
regulatory. Nothing at all. In fact, all it did was add an overhead of
data.

> Another example
> would be 20MHz transmission in 40MHz channel.

Same thing here, turns out you can dynamically figure this out based
on the regulatory rules.

> Maybe that is taken into
> account in crda code, but I did not have a close look at it yet.

It is taken into account. In fact 802.11ac and 802.11ad are thing I've
already have considered as well.

> I will have a look at the regsim repository and follow up on that.

Great!

>> Arend, in the future please trim all hunks that are not relevant to
>> your replies, that makes review easier.
>
> Will do.

Thanks,

  Luis

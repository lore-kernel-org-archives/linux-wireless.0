Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52877 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1I0Iqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:46:33 -0400
Received: by ywb5 with SMTP id 5so5081177ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 01:46:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317110884.4082.5.camel@jlt3.sipsolutions.net>
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	<1317109617.4082.0.camel@jlt3.sipsolutions.net>
	<CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	<1317110884.4082.5.camel@jlt3.sipsolutions.net>
Date: Tue, 27 Sep 2011 12:46:32 +0400
Message-ID: <CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com> (sfid-20110927_104641_981752_E519CB84)
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 12:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-27 at 12:03 +0400, Andrew V. Stepanov wrote:
>> On Tue, Sep 27, 2011 at 11:46 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-09-27 at 14:33 +0400, Andrew V. Stepanov wrote:
>> >> From: Andriy Stepanov <stanv@altlinux.ru>
>> >>
>> >> Use as:
>> >> modprobe rfkill unblocked=1
>> >> or
>> >> /etc/modprobe.d/options
>> >> options rfkill unblocked=1
>> >
>> > Apart from the obvious style problems in this patch (tons of extra
>> > braces) I'm not convinced this is a good idea.
>> >
>> > What problem does it solve? Why can that problem not be solved
>> > differently with existing mechanisms (e.g. urfkilld configured to do
>> > nothing)?
>
>> 2. urfkilld  can't be used to ignore Hard blocked buttons.
>
> Oh that's a good point -- so NACK on the patch.
>
> You *can't* ignore hard block buttons. All you can ignore is events from
> them, which is definitely not useful.
>
> johannes
>
>

I wan't to completely ignore events (state) of software\hardware rfkill buttons.

One solution for this, is to compile Linux kernel with "CONFIG_RFKILLL
is no net".
Than hardware/software rfkill buttons dosn't have any action to wlan-interfaces.

Other method is use this patch.

Do you know third method ?

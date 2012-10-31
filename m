Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34705 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2JaSyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 14:54:13 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1311103lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 11:54:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210311825.37192.chunkeey@googlemail.com>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1578864.KppKrIJQWb@lx-vladimir> <CAB=NE6WRG9yYV=NLORnEEHSkgfjBSdZr_pycLCmCN2cRUFvQKw@mail.gmail.com>
 <201210311825.37192.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 31 Oct 2012 11:53:51 -0700
Message-ID: <CAB=NE6VKJ6-j7w3QpkAgm8=UiMhi6YVEy+c5kaOLdA+TV-doDQ@mail.gmail.com> (sfid-20121031_195417_477203_A4AB80EF)
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 31, 2012 at 10:25 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday 31 October 2012 16:14:19 Luis R. Rodriguez wrote:
>> On Wed, Oct 31, 2012 at 5:57 AM, Vladimir Kondratiev
>> <qca_vkondrat@qca.qualcomm.com> wrote:
>> > By the way, Atheros driver carl9170 uses MODULE_VERSION,
>> > should we consider killing it?
>>
>> Well its tied pretty heavily to the firmware which BTW is open and
>> GPLv2. Your driver does not need firmware (yet). Why exactly carl9170
>> would use MODULE_VERSION though... or need it.. is perhaps Christian
>> can clarify on. Christian any reason to have MODULE_VERSION(),
>> anything that provide to userspace that cannot be obtained by the
>> kernel release it came from instead?
> Well, to make the api level of the firmware interface which
> is used by the driver accessible through modinfo without
> having to load the module. So a script check whenever the
> api matches by testing modinfo of the driver and fwinfo
> of the fw.
>
> However, this information is also printed out when the
> firmware is loaded/parsed.
> [  150.588563] usb 1-10: driver   API: 1.9.6 2012-07-07 [1-1]
> [  150.594360] usb 1-10: firmware API: 1.9.6 2012-07-07
> So, it's only really useful if you need to know in advance
> or in absence of a device. [So, it's not very useful in
> most cases]
>
> If you want to make a patch to remove it: here is my
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> [Also, if you remove it, you can kill the ugly #defines
> which are used by it too]

Thanks, sent. Die!

  Luis

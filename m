Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62653 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2JaRZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 13:25:48 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so788290bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 10:25:47 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
Date: Wed, 31 Oct 2012 18:25:36 +0100
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1578864.KppKrIJQWb@lx-vladimir> <CAB=NE6WRG9yYV=NLORnEEHSkgfjBSdZr_pycLCmCN2cRUFvQKw@mail.gmail.com>
In-Reply-To: <CAB=NE6WRG9yYV=NLORnEEHSkgfjBSdZr_pycLCmCN2cRUFvQKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210311825.37192.chunkeey@googlemail.com> (sfid-20121031_182555_648803_6C0A155E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 October 2012 16:14:19 Luis R. Rodriguez wrote:
> On Wed, Oct 31, 2012 at 5:57 AM, Vladimir Kondratiev
> <qca_vkondrat@qca.qualcomm.com> wrote:
> > By the way, Atheros driver carl9170 uses MODULE_VERSION,
> > should we consider killing it?
> 
> Well its tied pretty heavily to the firmware which BTW is open and
> GPLv2. Your driver does not need firmware (yet). Why exactly carl9170
> would use MODULE_VERSION though... or need it.. is perhaps Christian
> can clarify on. Christian any reason to have MODULE_VERSION(),
> anything that provide to userspace that cannot be obtained by the
> kernel release it came from instead?
Well, to make the api level of the firmware interface which 
is used by the driver accessible through modinfo without
having to load the module. So a script check whenever the
api matches by testing modinfo of the driver and fwinfo
of the fw.

However, this information is also printed out when the
firmware is loaded/parsed.
[  150.588563] usb 1-10: driver   API: 1.9.6 2012-07-07 [1-1]
[  150.594360] usb 1-10: firmware API: 1.9.6 2012-07-07
So, it's only really useful if you need to know in advance
or in absence of a device. [So, it's not very useful in
most cases]

If you want to make a patch to remove it: here is my
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
[Also, if you remove it, you can kill the ugly #defines
which are used by it too]

Regards,
	Chr

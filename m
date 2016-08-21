Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:56738 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752029AbcHUKN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 06:13:29 -0400
From: "Mishol, Guy" <guym@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wlcore: mesh: add zone time sync support
Date: Sun, 21 Aug 2016 10:13:22 +0000
Message-ID: <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com> (sfid-20160821_121338_332756_BAB80A46)
References: <20160808085706.22668-1-guym@ti.com>
        <1471538527.3432.21.camel@qca.qualcomm.com>
 <874m6h5bex.fsf@purkki.adurom.net>
In-Reply-To: <874m6h5bex.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="windows-1255"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle/Thomas,
Thanks for your feedback.

This time sync support is different from the one that mac80211 maintains with mesh peers.
This time sync is mostly used by upper layers for several applications (like audio).
In this case we allow the user to configure for each zone who will be the synchronizer.
You can refer to the following Application Report (chapter 6) for more information: http://www.ti.com/lit/an/swaa166/swaa166.pdf

BR,

Guy Mishol
  (+972) 9-7906726
  guym@ti.com


-----Original Message-----
From: Kalle Valo [mailto:kvalo@codeaurora.org] 
Sent: Friday, August 19, 2016 12:57
To: Pedersen, Thomas
Cc: Mishol, Guy; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wlcore: mesh: add zone time sync support

"Pedersen, Thomas" <twp@qca.qualcomm.com> writes:

> On Mon, 2016-08-08 at 11:57 +0300, Guy Mishol wrote:
>> Add zone time sync support for mesh role.
>> This allows to configure the mesh peer master of each zone for time 
>> synchronization.
>
> What is this? mac80211 already tries to maintain TSF sync with mesh 
> peers if get/set TSF ops are supported by the driver.

Yeah, and why use debugfs?

--
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdCVNE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 09:04:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johan Hovold <johan@kernel.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2/2] zd1211rw: fix NULL-deref at probe
References: <20170313124421.28587-2-johan@kernel.org>
        <20170322090415.BE414609FF@smtp.codeaurora.org>
        <20170322124548.GC10130@localhost>
Date: Wed, 22 Mar 2017 15:02:12 +0200
In-Reply-To: <20170322124548.GC10130@localhost> (Johan Hovold's message of
        "Wed, 22 Mar 2017 13:45:48 +0100")
Message-ID: <87r31p31nv.fsf@kamboji.qca.qualcomm.com> (sfid-20170322_140526_880038_E8C9ED47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> writes:

> On Wed, Mar 22, 2017 at 09:04:15AM +0000, Kalle Valo wrote:
>> Johan Hovold <johan@kernel.org> wrote:
>> > Make sure to check the number of endpoints to avoid dereferencing a
>> > NULL-pointer or accessing memory beyond the endpoint array should a
>> > malicious device lack the expected endpoints.
>> > 
>> > Fixes: a1030e92c150 ("[PATCH] zd1211rw: Convert installer CDROM
>> > device into WLAN device")
>> > Cc: Daniel Drake <dsd@gentoo.org>
>> > Signed-off-by: Johan Hovold <johan@kernel.org>
>> 
>> Patch applied to wireless-drivers-next.git, thanks.
>> 
>> ca260ece6a57 zd1211rw: fix NULL-deref at probe
>
> What about patch 1/2 which fixes the same bug (literally copied from the
> zd1211rw driver)?

I will apply that to my separate ath.git tree, just didn't get to your
patch yet.

> And as these fixes should be backported to stable (I left out the tag
> for networking drivers)

Actually for wireless drivers you should add the stable tag.

> why only apply to -next?

I didn't see that the fix was important enough for 4.11.

-- 
Kalle Valo

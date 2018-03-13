Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbeCMNj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 09:39:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andres Rodriguez <andresx7@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
References: <20180309221243.15489-2-andresx7@gmail.com>
        <20180309230925.3573-1-andresx7@gmail.com>
        <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
        <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com>
        <bbdc304f-edd5-38df-ea88-012fefc54b90@gmail.com>
        <5AA5B777.5020106@broadcom.com> <20180312192704.GX4449@wotan.suse.de>
Date: Tue, 13 Mar 2018 15:39:23 +0200
In-Reply-To: <20180312192704.GX4449@wotan.suse.de> (Luis R. Rodriguez's
        message of "Mon, 12 Mar 2018 19:27:04 +0000")
Message-ID: <87r2oo9jsk.fsf@kamboji.qca.qualcomm.com> (sfid-20180313_143954_064872_DFC79860)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> On Mon, Mar 12, 2018 at 12:10:47AM +0100, Arend van Spriel wrote:
>> On 3/11/2018 5:05 PM, Andres Rodriguez wrote:
>> > > Your patch series then should also have the driver callers who you
>> > > want to modify to use this new API. Collect from the 802.11 folks the
>> > > other drivers which I think they wanted changed as well.
>> > 
>> > Arend, Kalle, would love to hear your feedback.
>> 
>> I am not sure if it was ath10k, but Kalle will surely know. The other driver
>> firing a whole batch of firmware requests is iwlwifi. These basically try to
>> get latest firmware version and if not there try an older one.
>
> Ah I recall now. At least for iwlwifi its that it requests firmware with a
> range of api files, and we don't need information about files in the middle
> not found, given all we need to know if is if at lest one file was found
> or not.
>
> I have future code to also enable use of a range request which would replace
> the recursive nature of iwlwifi's firmware API request, so it simplifies it
> considerably.
>
> Once we get this flag to be silent in, this can be used later. Ie, the new
> API I'd add would replace the complex api revision thing for an internal set.

TBH I doubt we would use this kind of "range" request in ath10k, the
current code works just fine only if we can get rid of the annoying
warning from request_firmware(). Unless if it's significantly faster or
something.

-- 
Kalle Valo

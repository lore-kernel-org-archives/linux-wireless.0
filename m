Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbeCJOlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
References: <20180309221243.15489-2-andresx7@gmail.com> <20180309230925.3573-1-andresx7@gmail.com>
 <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Sat, 10 Mar 2018 06:40:54 -0800
Message-ID: <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com> (sfid-20180310_154129_691438_EBB19EFB)
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
To: Andres Rodriguez <andresx7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 6:35 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> You also I take it have users in
> mind? I'd like to see at least one user of the API or this fixing a
> reported issue. Ie, if users have reported this as issues incorrectly,
> referring to those incorrect posts as issues and how this created
> confusion would help.

Your patch series then should also have the driver callers who you
want to modify to use this new API. Collect from the 802.11 folks the
other drivers which I think they wanted changed as well. The old up on
that front was that the firmware API was in a huge state of flux and
debate about *how* we'd evolve the API, either through a data driven
API or functional driven API, ie whether or not we'd add a flexible
one API call with a set of options, or keep extending functionality
with new exported symbols per use case. The later is how we'd keep
evolving the API as such the way you are doing it is fine. Ie, if
there is a use case for an optional firmware also for the async case a
new API call will have to be made. As stupid as this sounds.

Also please take a look at lib/test_firmware.c -- I don't think it
makes sense to add a new test case for this API call, so at least
worth documenting why somewhere if you find a suitable place for that.

Also - I forgot to ask you to extend the
Documentation/driver-api/firmware/ documentation accordingly. Please
do that.

  Luis

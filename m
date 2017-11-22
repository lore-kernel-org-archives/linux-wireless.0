Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdKVTqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 14:46:31 -0500
Date: Wed, 22 Nov 2017 20:46:29 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>, mcgrof@kernel.org,
        sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-11-19
Message-ID: <20171122194629.GI729@wotan.suse.de> (sfid-20171122_204635_063163_D33B310C)
References: <1511175768.4011.261.camel@coelho.fi>
 <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
 <1511259055.4011.268.camel@coelho.fi>
 <871skrdiaf.fsf@kamboji.qca.qualcomm.com>
 <1511264260.4011.274.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511264260.4011.274.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 21, 2017 at 01:37:40PM +0200, Luca Coelho wrote:
> On Tue, 2017-11-21 at 12:42 +0200, Kalle Valo wrote:
> > Luca Coelho <luca@coelho.fi> writes:
> > 
> > > > [   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > iwlwifi-8265-34.ucode (-2)
> > > > [   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > iwlwifi-8265-34.ucode failed with error -2
> > > > [   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > iwlwifi-8265-33.ucode (-2)
> > > > [   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > iwlwifi-8265-33.ucode failed with error -2
> > > > [   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > iwlwifi-8265-32.ucode (-2)
> > > > [   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > iwlwifi-8265-32.ucode failed with error -2
> > > > [   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading
> > > > firmware
> > > > iwlwifi-8265-31.ucode
> > > > [   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
> > > > 31.532993.0 op_mode iwlmvm
> > > 
> > > This is an unfortunate side-effect of the way firmwares are
> > > loaded. 
> > > There is currently no way to prevent these error messages by making
> > > some files optional... But you can ignore them.  Or, even better,
> > > upgrade your firmware to the latest version the driver supports. :)
> > 
> > Or even better that we improve request_firmware()&co to make it
> > possible
> > not to print an error message :)
> 
> The last time we discussed this, Luis was working on changes to the
> firmware subsystem APIs, but I stopped following and have no idea what
> happened with those patches...

You guys dropped the ball on this but I don't blame you, the state of affairs
of evolving anything on the firmware API has been a pain in the ass for ages.

I nose dived last time a "no warn" patch for async was porposed, I particularly
looked into how ath10k firmware loads [0], someone should really consider
making docs out of that email for ath10k...  anyway I *confirmed* that both
iwlwifi and ath10k share the same intent:

"do not warn if firmware is missing"

But they do this for an API revision series. So rather its:

"Lookup for firmware API start=x, end=y, and only warn if nothing is found"

The good news is that the code is implemented, however it was for the
"driver data API" and I had only ported iwlwifi [1] [2] (look at use of
DRIVER_DATA_API() macros).

In fact the iwlwifi firmware use for api revision uses recursion, I modified my
solution to not use it, making it deterministic as well, but that code was
written for the driver data API. As soon as we decide on a path forward on *how*
to evolve the firmware API we can consider adding such solution or extensions
in. Whether that be the simple "do not warn" on async calls or the full "look
for these revisions for me, and don't warn". Both are things I have already
implemented, its just then a matter of how to merge.

The thing *stalling* firmware API progress was a technical debate on whether
or not the firmware API should evolve through:

a) Functional driven API
b) Data driven API

Greg put his foot down on a) and I finally came to agree with him.

We seem to have reached a consensus on how to proceed forward slowly and
this means a cleanup without the data driven API.

So *other good news* is that last week I worked and published two patch sets
to help in this direction.

One is a set of fixes [3], and the other is a set of cleanups for the firmware
API which paves the way for a way to consider evolving the API without the
whole hated driver data crap approach [4], for consideration for v4.16.

I have these two patch sets in a git tree branch, just ignore the last
commit there for now [6], as it was taking the old data driven API
approach to the firmware API. Note that this *may* still be a good
approach forward, however it does not matter. Once the cleanup is
merged, it should be fairly easy to decide on a path forward to
evolve the API as that would be the *only* thing left to decide on.

If someone wants to be proactive, they can look at this branch, ignore
the last patch ("firmware: add extensible firmware params") and see
how they can nicely come up something like the DRIVER_DATA_API()
macro stuff I did earlier, that or just the "no warn" flag.

Please note that I did want to clearly split private Vs public flags. Public
flags should be for functionality exposed, private for internal hacks.

I could just be a simple matter of adding a public "No warn" flag first,
and only later add the "api revision" functionality.

[0] https://lkml.kernel.org/r/20170810170539.GC27873@wotan.suse.de
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170605-driver-data&id=8a2b582b9938f74827bbffb98a2f95c967c8ccde
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170605-driver-data&id=6cd4c6c8f93fac692ad0014792f1fd410742a1da
[3] https://lkml.kernel.org/r/20171120174535.27000-1-mcgrof@kernel.org
[4] https://lkml.kernel.org/r/20171120182409.27348-1-mcgrof@kernel.org
[5] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20171117-firmware-flexible
[6] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20171117-firmware-flexible&id=9cc12e4c4483c38cf46a71f3c37af9ace67e3e4d

  Luis

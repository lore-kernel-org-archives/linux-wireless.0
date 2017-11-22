Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46984 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751260AbdKVUu5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 15:50:57 -0500
Message-ID: <1511383851.4011.319.camel@coelho.fi> (sfid-20171122_215100_431258_854B939C)
From: Luca Coelho <luca@coelho.fi>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, sedat.dilek@gmail.com,
        linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 22 Nov 2017 22:50:51 +0200
In-Reply-To: <20171122194629.GI729@wotan.suse.de>
References: <1511175768.4011.261.camel@coelho.fi>
         <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
         <1511259055.4011.268.camel@coelho.fi>
         <871skrdiaf.fsf@kamboji.qca.qualcomm.com>
         <1511264260.4011.274.camel@coelho.fi> <20171122194629.GI729@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-22 at 20:46 +0100, Luis R. Rodriguez wrote:
> On Tue, Nov 21, 2017 at 01:37:40PM +0200, Luca Coelho wrote:
> > On Tue, 2017-11-21 at 12:42 +0200, Kalle Valo wrote:
> > > Luca Coelho <luca@coelho.fi> writes:
> > > 
> > > > > [   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > > iwlwifi-8265-34.ucode (-2)
> > > > > [   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > > iwlwifi-8265-34.ucode failed with error -2
> > > > > [   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > > iwlwifi-8265-33.ucode (-2)
> > > > > [   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > > iwlwifi-8265-33.ucode failed with error -2
> > > > > [   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
> > > > > iwlwifi-8265-32.ucode (-2)
> > > > > [   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
> > > > > iwlwifi-8265-32.ucode failed with error -2
> > > > > [   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading
> > > > > firmware
> > > > > iwlwifi-8265-31.ucode
> > > > > [   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
> > > > > 31.532993.0 op_mode iwlmvm
> > > > 
> > > > This is an unfortunate side-effect of the way firmwares are
> > > > loaded. 
> > > > There is currently no way to prevent these error messages by
> > > > making
> > > > some files optional... But you can ignore them.  Or, even
> > > > better,
> > > > upgrade your firmware to the latest version the driver
> > > > supports. :)
> > > 
> > > Or even better that we improve request_firmware()&co to make it
> > > possible
> > > not to print an error message :)
> > 
> > The last time we discussed this, Luis was working on changes to the
> > firmware subsystem APIs, but I stopped following and have no idea
> > what
> > happened with those patches...
> 
> You guys dropped the ball on this but I don't blame you, the state of
> affairs
> of evolving anything on the firmware API has been a pain in the ass
> for ages.

Luis,

I really appreciate your work on this, don't get me wrong.  But I don't
think we dropped the ball.  We still need the small feature (not sure
if it can be done with a small *change*, though) of not warning when a
firmware is not found.  Nothing changed here.

The problem, and the reason why you see it as my having dropped the
ball, is that the change we needed grew into a massive refactoring of
the entire firmware loading mechanism, with the addition of driver
data, lots of advanced options etc.

You certainly remember that I even reviewed the first patchset, but
then it all snowballed into discussions that led to literally
*hundreds* of emails going back and forth and I just didn't have the
time to follow anymore...

In a selfish way, if I only think about the iwlwifi and ath10k drivers,
 I don't care *how* the "no warning" feature is implemented.  If it is
implemented with the "load from a range", a new concept of "driver
data", a "functional API" or just a simple "optional" flag, it doesn't
matter.  The driver can implement the range search, as it does now. 
The only thing the driver *can't* do at the moment is to get rid of the
warnings.

But, personally, I'm not in a hurry.  It's a bit annoying to get
reports repeatedly from the community about those warnings and having
to explain how things work, but I can live with that.

I'd be happy to help with anything that doesn't involve following
hundreds of emails and reviewing massive refactors in code I'm not
completely familiar with. ;) Let me know.


--
Cheers,
Luca.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934500AbeGDKSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 06:18:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org
Subject: Re: [PATCH v2 0/6]  *** Add support for wifi QMI client driver ***
References: <20180605123304.31969-1-govinds@codeaurora.org>
        <20180619021742.GA17220@rodete-desktop-imager.corp.google.com>
        <87woucnxkh.fsf@kamboji.qca.qualcomm.com>
        <20180703215556.GA15106@ban.mtv.corp.google.com>
Date: Wed, 04 Jul 2018 13:18:17 +0300
In-Reply-To: <20180703215556.GA15106@ban.mtv.corp.google.com> (Brian Norris's
        message of "Tue, 3 Jul 2018 14:55:57 -0700")
Message-ID: <87muv7mhhy.fsf@kamboji.qca.qualcomm.com> (sfid-20180704_122014_343237_9DDF63FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Tue, Jul 03, 2018 at 06:33:34PM +0300, Kalle Valo wrote:
>> Brian Norris <briannorris@chromium.org> writes:
>> > On Tue, Jun 05, 2018 at 06:03:04PM +0530, Govind Singh wrote:
>> >> Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
>> >> This module is responsible for communicating WLAN control messages to FW
>> >> over QMI interface.
>> >> 
>> >> QUALCOMM MSM Interface(QMI) provides the control interface between
>> >> components running b/w remote processors with underlying transport layer
>> >> based on integrated chipset(shared memory) or discrete
>> >> chipset(PCI/USB/SDIO/UART).
>> >
>> > So this seems to imply QMI would work with transports that are not
>> > integrated. Except, your code is directly calling SNOC (one of your
>> > integrated chipset interfaces) code from the QMI driver. Correct? I
>> > suppose that's OK for now, but it's a little misleading. If you actually
>> > intend this to support multiple transports, then you might instead want
>> > a callback interface for this.
>> 
>> Sure. But do we even know that the QMI interfaces are even compatible?
>> AFAIK QMI is just an RPC protocol, so there's no guarantee about
>> interface stability. So I don't see the need to support other interfaces
>> until we know exactly what we need to implement.
>
> I think my questions were meant more of clarifying questions rather than
> proper suggestions. If your explanation is correct, then I'd figure this
> language should mention that we're implementing a handshake specific to
> SNOC (or WCN3990), instead of appearing to be agnostic.

Makes sense. I haven't fully studied QMI yet but my gut feeling is that
I should consider QMI just as a transport protocol. And if different
components use QMI it does not necessarily mean that the actual
interface is the same, just that they use the same transport protocol.

>> >> QMI client driver implementation is based on qmi frmework https://lwn.net/Articles/729924/.
>> >> 
>> >> Below is the sequence of qmi handshake.
>> >> 
>> >>        QMI CLIENT(APPS)                                         QMI SERVER(FW in Q6)
>> >> 
>> >>                          <------wlan service discoverd----
>> >> 
>> >>                        -----connect to wlam qmi service----->
>> >> 
>> >>                        ------------wlan info request----->
>> >> 
>> >>                        <------------wlan info resp------------
>> >> 
>> >>                        ------------msa info req-------->
>> >> 
>> >>                      <------------msa info resp------------
>> >> 
>> >>                      ------------msa ready req-------->
>> >> 
>> >>                      <------------msa ready resp------------
>> >> 
>> >>                      <------------msa ready indication-------
>> >> 
>> >>                      ------------capability req------->
>> >> 
>> >>                     <------------capability resp------------
>> >> 
>> >>                     ------------qmi bdf req--------->
>> >> 
>> >>                      <------------qmi bdf resp------------
>> >> 
>> >>                       ------------qmi cal trigger------->
>> >> 
>> >>                   <------------ QMI FW ready indication-------
>> >
>> > Let's see if I'm interpreting this right:
>> >
>> >  * The above process is just initiating a handshake with the QMI
>> >    service and doesn't actually do any loading of firmware on its own;
>> >    it just hands things off to the SNOC client driver (and ath10k core)
>> >    once the firmware is magically ready (??)
>> >  * The ATH10K_FW_FEATURE_NON_BMI flag you added previously basically
>> >    provides a way for a driver (and now we see which driver; it's this
>> >    QMI / SNOC driver) to completely sidestep the typicaly in-kernel
>> >    firmware load implementation; in fact, the kernel only reads the
>> >    WLAN firmware just to parse some feature flags, not to actually
>> >    program it to the device
>> >  * Some yet-unmentioned proprietary app is involved to handle
>> >    sideloading the actual firmware from user space
>> >
>> > Is this correct? If not, please correct me. But if it is:
>> >
>> >  * When does the user space app actually load the WLAN firmware? I'm not
>> >    sure I can place it in the above diagram.
>
> BTW, I think Govind answered most of these questions, but IMO, those
> sorts of clarifying bits should be in the documentation here. Maybe in
> the cover letter here, but also in either the patch description(s) or
> code comments. It's nice to retain some of this architectural
> description in the git history somehow -- particularly, to note what
> outside dependencies there are.

Sounds very good to me.

BTW, in the future I hope to store the cover letter also to git. Dave
already does that but I can't as patchwork.kernel.org doesn't support
it:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=2bdea157b99903c8d344dbae44fedf033db4e2c2

Hopefully the upcoming upgrade on patchwork.kernel.org makes this
possible.

>> >  * Is there any open source implementation of this? How am I supposed to
>> >    actually use this driver, if it relies on proprietary components that
>> >    I can't review and aren't really even mentioned?
>> >
>> > I hope I'm sorely wrong on this. But if I'm not, I don't see why this
>> > driver should be merged at all. Linux drivers should be self-sufficient
>> > wherever possible, and I don't see a good reason why this driver can't
>> > manage actually loading the WLAN firmware on its own, similar to how the
>> > BMI component of the ath10k driver loads firmware for other ath10k
>> > transports. But even more importantly: I believe this driver is hiding
>> > the fact that it relies on undocumented proprietary components to run on
>> > the CPU [1] just to make use of it at all.
>> 
>> First of all, thanks for bringing this up! I was aware of the need of
>> user space tools to download the firmware to Q6 but I assumed they were
>> Open Source, which to my surprise they were not. An upstream driver
>> definitely needs to have open user space components so that anyone can
>> use it, and hence I cannot apply these until that's solved. Luckily
>> Bjorn has been working on that and he has done good progress on those,
>> though I think there were some issues still.
>
> Good to hear Bjorn is working on this. I've been asking through other
> channels too, and I don't have anything more than lip service. In fact,
> I've been told the opposite at times -- that I won't get source. But
> then, I'm quite aware that the right hand often doesn't know what the
> left hand is doing ;)

Hehe, I say the same quite often :)

> Anything you and Bjorn can do to help push this along would be great,
> because while I'd love to have this driver upstream, this is a huge
> sticking point for me.

So Bjorn's work is available here:

https://github.com/andersson/tqftpserv

https://github.com/andersson/pd-mapper

Do take into account that this is very much work-in-progress, but at
least the initial feedback I got from Govind was very positive. Big
thanks to Bjorn for all this!

-- 
Kalle Valo

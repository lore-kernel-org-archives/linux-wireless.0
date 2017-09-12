Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47301 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751289AbdILMdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 08:33:43 -0400
Date: Tue, 12 Sep 2017 05:33:41 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Kevin Cernekee <cernekee@chromium.org>,
        franky.lin@broadcom.com, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
Message-ID: <20170912123341.GA19179@kroah.com> (sfid-20170912_143347_359392_FD4852C1)
References: <20170909193020.19061-1-cernekee@chromium.org>
 <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com>
 <87tw08mpq1.fsf@purkki.adurom.net>
 <59B78E94.5040909@broadcom.com>
 <87o9qgicju.fsf@kamboji.qca.qualcomm.com>
 <59B793C9.2030103@broadcom.com>
 <87k214ibps.fsf@kamboji.qca.qualcomm.com>
 <59B79838.6090408@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <59B79838.6090408@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 12, 2017 at 10:18:00AM +0200, Arend van Spriel wrote:
> + Greg KH
> 
> On 9/12/2017 10:05 AM, Kalle Valo wrote:
> > Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> > 
> > > On 9/12/2017 9:47 AM, Kalle Valo wrote:
> > > > Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> > > > 
> > > > > On 9/12/2017 7:48 AM, Kalle Valo wrote:
> > > > > > Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> > > > > > 
> > > > > > > On 09-09-17 21:30, Kevin Cernekee wrote:
> > > > > > > > In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
> > > > > > > > the length of rxframe is validated.  This could lead to uninitialized
> > > > > > > > data being accessed (but not printed).  Since we already have a
> > > > > > > > perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
> > > > > > > > and ch.chspec is not modified by decchspec(), avoid the extra
> > > > > > > > assignment and use ch.chspec in the debug print.
> > > > > > > > 
> > > > > > > > Suggested-by: Mattias Nissler <mnissler@chromium.org>
> > > > > > > > Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> > > > > > > > Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > > > > > > > ---
> > > > > > > >      drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
> > > > > > > >      1 file changed, 1 insertion(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > 
> > > > > > > > V1->V2: Clarify changelog re: whether the uninitialized data is printed.
> > > > > > > 
> > > > > > > This patch and the others in this series look fine to me.
> > > > > > 
> > > > > > Should these go to v4.14?
> > > > > 
> > > > > I have no strong opinion. These are certainly improvements, but it
> > > > > does not seem an -rc fix to me. Within this series I would say patch
> > > > > 3/3 adds an additional sanity check in the event processing against an
> > > > > attack so you may consider adding just that one to v4.14
> > > > 
> > > > Ok, I'll queue patch 3 to v4.14.
> > > > 
> > > > > and tag it for stable, ie.:
> > > > > 
> > > > > Cc: stable@vger.kernel.org # v3.8.x
> > > > 
> > > > But why v3.8.x? I admit that I haven't fully figured out the stable tags
> > > > yet, but doesn't that mean that it will be only applied to v3.8.x and
> > > > nothing else? I was expecting it to be:
> > > > 
> > > > Cc: stable@vger.kernel.org # v3.8+
> > > > 
> > > 
> > > It is actually in the stable-kernel-rules documentation [1]:
> > > 
> > > """
> > > Also, some patches may have kernel version prerequisites.  This can be
> > > specified in the following format in the sign-off area:
> > > 
> > > .. code-block:: none
> > > 
> > >       Cc: <stable@vger.kernel.org> # 3.3.x
> > > 
> > > The tag has the meaning of:
> > > 
> > > .. code-block:: none
> > > 
> > >       git cherry-pick <this commit>
> > > 
> > > For each "-stable" tree starting with the specified version.
> > > """
> > 
> > Yeah, but it says "starting with" which I interpret as "starting with
> > string '3.3'". For example the commit here would be applied to 3.3.1,
> > 3.3.2 and 3.3.3 etc but _not_ to 3.4, 3.4.1, 3.5 or any later release.
> > 
> > Of course I can be way off here, wouldn't be the first :)
> 
> Dito. I interpret "each -stable tree" as each stable branch in the stable
> repository. Would Greg know?

"# 3.8+" and "# 3.8" mean the same thing to me, we would never backport
something to only a very specific kernel version, and leave newer kernel
versions to not have that fix.  That would be crazy, and would break our
"no regressions" rule (i.e. newer kernels should always work as good as
older kernels.)

Don't get hung up on the semantics here people, it's not all that
complicated, and I do it all by hand anyway :)

thanks,

greg k-h

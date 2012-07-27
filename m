Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62855 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2G0OaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 10:30:11 -0400
Received: by bkwj10 with SMTP id j10so1944864bkw.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 07:30:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Fri, 27 Jul 2012 16:30:05 +0200
Cc: Javier Lopez <jlopex@cozybit.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1343332743-11845-1-git-send-email-jlopex@cozybit.com> <201207262212.06227.chunkeey@googlemail.com> <CAPjQAd_0sD69dunzyd4Bx9Ys_XgTA9-Zr5TJkfNweopJWNBTJQ@mail.gmail.com>
In-Reply-To: <CAPjQAd_0sD69dunzyd4Bx9Ys_XgTA9-Zr5TJkfNweopJWNBTJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207271630.06025.chunkeey@googlemail.com> (sfid-20120727_163015_969715_57148C88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2012 05:52:49 Javier Cardona wrote:
> On Thu, Jul 26, 2012 at 1:12 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Thursday 26 July 2012 21:59:03 Javier Lopez wrote:
> >> This patch contains following modifications:
> >>
> >> - Add mesh capabilities on fw.c to permit creation of mesh
> >>   interfaces using this driver.
> >>
> >> - Modify carl9170_set_operating_mode, to use AP-style beaconing
> >>   with mesh interfaces.
> >>
> >> - Allow beacon updates for NL80211_IFTYPE_MESH_POINT type in
> >>   carl9170_handle_command_response.
> >>
> >> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
> > Hm, what about virtual interfaces?
> >
> > Do you think it's save to share a MESH node with
> > a STA, IBSS, AP interface on the same hardware?
> 
> Does this hardware support multiple beacons?
> If not, we probably should limit the driver
> to only accept one beaconing vif at a time
> (e.g. one mesh vif + multiple STAs vifs ok).
oh yes. In fact, Due to your modifycations to fw.c
you have to update carl9170_op_add_interface as well.
As you are currently claiming any mesh/ap/sta
combination, even though it's not supported in the
code atm.

Just add a case for NL80211_IFTYPE_MESH in the 
switch (main_vif->type) block and to the
if ((vif->type == ...) below.
 
> > On a side node: Can you tell me anything about
> > the crypto of mesh traffic? Because currently,
> > the code will disable any hardware crypto
> > offload for any mode other than STA and AP.
> 
> The hardware crypto needs to support one tx/rx
> pairwise key per peer, a groupwise key for each
> peer and management frame protection.
> Not sure if this is the case for this hardware,
> so until we do, it seems reasonable to disable
> crypto offload.
ok, a groupwise key for each peer is not possible
with the hw. (no need to change anything, swcrypto
is selected in this case).

Regards,
	Chr

BTW: Did you do any experiments? I.e.: Does it really
work?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFPVHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 17:07:18 -0400
Subject: Re: [PATCH] libertas: Fix re-enabling IEEE PS with WPA/WPA2
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <45e8e6c40906161303y7be52452vf4cd16bbc3cc7e43@mail.gmail.com>
References: <1245096111-20884-1-git-send-email-andrey@cozybit.com>
	 <1245182004.28992.18.camel@130.81.190.10.in-addr.arpa>
	 <45e8e6c40906161303y7be52452vf4cd16bbc3cc7e43@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 17:06:47 -0400
Message-Id: <1245186407.28992.59.camel@130.81.190.10.in-addr.arpa>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-16 at 13:03 -0700, Andrey Yurovsky wrote:
> On Tue, Jun 16, 2009 at 12:53 PM, Dan Williams<dcbw@redhat.com> wrote:
> > On Mon, 2009-06-15 at 13:01 -0700, Andrey Yurovsky wrote:
> >> With IEEE PS enabled, the driver will temporarily take the device out of
> >> PS mode to issue commands and then re-enable PS once the commands have
> >> completed.  With WPA or WPA2 security, the driver fails to re-enable PS
> >> mode because of a check for key lengths that are always zero.
> >>
> >> This patch removes the key lengths check (the local copy of the keys is
> >> not maintained) and fixes IEEE PS mode with WPA or WPA2 security.
> >> Tested on GSPI and SDIO interfaces with V9 firmware.
> >
> > I have no idea what this code was trying to do originally (I'm pretty
> > sure it's a left-over from the vendor driver), but it seems like maybe
> > it was ensuring that the adapter did *not* return to power-save mode
> > until the supplicant had set the GTK?  There's a window where the GTK
> > won't be set, and we probably shouldn't be entering PS mode until that
> > window is closed.  Old sd8385 code from a Motorola phone has:
> >
> >        if ((Adapter->PSMode != Wlan802_11PowerModeCAM) &&
> >                        (Adapter->PSState == PS_STATE_FULL_POWER) &&
> >                        (Adapter->MediaConnectStatus ==
> >                         WlanMediaStateConnected)) {
> >                if(Adapter->SecInfo.WPAEnabled
> >                        || Adapter->SecInfo.WPA2Enabled
> >                ) {
> >                        if(Adapter->IsGTK_SET == TRUE) {
> >                                PRINTM(INFO, "EXEC_NEXT_CMD: WPA enabled and GTK_SET"
> >                                        " go back to PS_SLEEP");
> >                                PSSleep(priv, 0);
> >                        }
> >                } else
> >                {
> >                        PRINTM(INFO, "EXEC_NEXT_CMD: Command PendQ is empty,"
> >                                " go back to PS_SLEEP");
> >                        PSSleep(priv, 0);
> >                }
> >        }
> >
> > Says to me, "if WPA is enabled but the GTK hasn't been set yet, don't go
> > to sleep".
> >
> > Does that sound like a plausible explanation of what the original bits
> > intended to do?  Like I said, it was inherited, but there might have
> > been a good reason for it.
> 
> That might be the original intention, but assoc_helper_wpa_keys() sets
> both and lbs_cmd_802_11_key_material() then clears out the driver's
> copy, which is then (incorrectly) checked when deciding whether to go
> back to sleep.  As I understand it, the execution path for WPA/WPA2
> association shouldn't cause this situation where WPA is enabled but
> the GTK isn't set yet and we're deciding to go back to sleep.  Do you
> agree?  Should we even be keeping the 'driver copy' of the keys?  I
> don't see why we want to do that.  Thanks,

It might be possible to remove the priv->... bits; but here's why they
exist.

We keep shadow copies of the WEP & WPA keys in the priv structure to
represent the "current" values there, so that we don't have to hit the
hardware up every time somebody does an iwconfig.  That's somewhat bogus
because drivers don't actually guarantee that the current key will be
returned, but it's nice to have.

Second, we need to populate a new assoc_request with the "current" state
of the card when building up a change request.  That involves copying
that current state into the new association request, same as all the
other "current" values get stuffed into the request.  There are other
ways to do the association request stuff than this, like a list of
"change events", but some commands require more state than just the
particular thing to be changed, thus the assoc_request is trying to be a
picture of the adapter at the time it's created.

If we wanted to just hit the hardware up for the WEP & WPA keys when
doing 'iwconfig' then we could certainly just split up
lbs_cmd_802_11_key_material() into a getter and setter, which should
probably be done anway.

But that doesn't fix the issue of building up the assoc_request.  This
*could* all go away if/when we convert to cfg80211's WEXT compat stuff.
At that point we ditch the assoc_request junk (which was only there to
ensure 'iwconfig key xxxxx; iwconfig essid foobar' and the supplicant's
WEXT driver worked correctly) and maybe the private key copies in the
driver.

I think the bug here is actually that the driver isn't copying the keys
from the assoc_req to priv in assoc_helper_wpa_keys().  Thus the only
way the priv->wpa* get set is by getting them explicitly.

Dan

>   -Andrey
> 
> >> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> >> ---
> >>  drivers/net/wireless/libertas/cmd.c |   29 +++++++----------------------
> >>  1 files changed, 7 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> >> index 01db705..5825396 100644
> >> --- a/drivers/net/wireless/libertas/cmd.c
> >> +++ b/drivers/net/wireless/libertas/cmd.c
> >> @@ -1782,32 +1782,17 @@ int lbs_execute_next_command(struct lbs_private *priv)
> >>               lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
> >>                           le16_to_cpu(cmd->command));
> >>               lbs_submit_command(priv, cmdnode);
> >> -     } else {
> >> +     } else if ((priv->psmode != LBS802_11POWERMODECAM) &&
> >> +                (priv->psstate == PS_STATE_FULL_POWER) &&
> >> +                ((priv->connect_status == LBS_CONNECTED) ||
> >> +                (priv->mesh_connect_status == LBS_CONNECTED))) {
> >>               /*
> >>                * check if in power save mode, if yes, put the device back
> >>                * to PS mode
> >>                */
> >> -             if ((priv->psmode != LBS802_11POWERMODECAM) &&
> >> -                 (priv->psstate == PS_STATE_FULL_POWER) &&
> >> -                 ((priv->connect_status == LBS_CONNECTED) ||
> >> -                 (priv->mesh_connect_status == LBS_CONNECTED))) {
> >> -                     if (priv->secinfo.WPAenabled ||
> >> -                         priv->secinfo.WPA2enabled) {
> >> -                             /* check for valid WPA group keys */
> >> -                             if (priv->wpa_mcast_key.len ||
> >> -                                 priv->wpa_unicast_key.len) {
> >> -                                     lbs_deb_host(
> >> -                                            "EXEC_NEXT_CMD: WPA enabled and GTK_SET"
> >> -                                            " go back to PS_SLEEP");
> >> -                                     lbs_ps_sleep(priv, 0);
> >> -                             }
> >> -                     } else {
> >> -                             lbs_deb_host(
> >> -                                    "EXEC_NEXT_CMD: cmdpendingq empty, "
> >> -                                    "go back to PS_SLEEP");
> >> -                             lbs_ps_sleep(priv, 0);
> >> -                     }
> >> -             }
> >> +             lbs_deb_host("EXEC_NEXT_CMD: cmdpendingq empty, "
> >> +                             "go back to PS_SLEEP");
> >> +             lbs_ps_sleep(priv, 0);
> >>       }
> >>
> >>       ret = 0;
> >
> >


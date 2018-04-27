Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:40223 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758883AbeD0RfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 13:35:03 -0400
Received: by mail-io0-f180.google.com with SMTP id t123-v6so3334486iof.7
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2018 10:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180412154159.13934-1-alfonso.sanchez-beato@canonical.com>
 <CALLGbRJd+fXDxJa_2Tek0pivxFqPHRVFTAg=7dQ0t=uB+zkyow@mail.gmail.com> <CACM4vuATSFKLE65Tkxej2_PEUrbJz8zJzEqeC6GN8GSFX_puzQ@mail.gmail.com>
In-Reply-To: <CACM4vuATSFKLE65Tkxej2_PEUrbJz8zJzEqeC6GN8GSFX_puzQ@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 27 Apr 2018 17:34:26 +0000
Message-ID: <CALLGbRLkn0+Gy0wsdavMwrv-8sHPo=9hWJwrAZY4adCJarfuYg@mail.gmail.com> (sfid-20180427_193507_318270_2DB24760)
Subject: Re: [PATCH] ath6kl: use WMI to set RSN capabilities
To: alfonso.sanchez-beato@canonical.com
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 27, 2018 at 9:57 AM Alfonso Sanchez-Beato <
alfonso.sanchez-beato@canonical.com> wrote:

> Hi Steve,

> On Fri, Apr 27, 2018 at 5:47 PM, Steve deRosier <derosier@gmail.com>
wrote:
> > Hi Alfonso,
> >
> > On Thu, Apr 12, 2018 at 8:42 AM Alfonso S=C3=A1nchez-Beato <
> > alfonso.sanchez-beato@canonical.com> wrote:
> >
> >> This fixes AP mode when the ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE flag
> >> is not present in the FW. The id of some WMI commands is also fixed
> >> (there was an error in the enum order), and a function to set RSN caps
> >> is added.
> >
> >> Signed-off-by: Alfonso S=C3=A1nchez-Beato <
alfonso.sanchez-beato@canonical.com>
> >> ---
> >>   drivers/net/wireless/ath/ath6kl/cfg80211.c | 21 ++++++--------------=
-
> >>   drivers/net/wireless/ath/ath6kl/main.c     | 10 +++-------
> >>   drivers/net/wireless/ath/ath6kl/wmi.c      | 23
+++++++++++++++++++++++
> >>   drivers/net/wireless/ath/ath6kl/wmi.h      | 15 +++++++++++----
> >>   4 files changed, 43 insertions(+), 26 deletions(-)
> >
> >> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> >> index 2ba8cf3f38af..1b89c53d47e7 100644
> >> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> >> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> >> @@ -2933,13 +2933,11 @@ static int ath6kl_start_ap(struct wiphy *wiphy=
,
> > struct net_device *dev,
> >>           * advertise the same in beacon/probe response. Send
> >>           * the complete RSN IE capability field to firmware
> >>           */
> >> -       if (!ath6kl_get_rsn_capab(&info->beacon, (u8 *) &rsn_capab) &&
> >> -           test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
> >> -                    ar->fw_capabilities)) {
> >> -               res =3D ath6kl_wmi_set_ie_cmd(ar->wmi, vif->fw_vif_idx=
,
> >> -                                           WLAN_EID_RSN,
WMI_RSN_IE_CAPB,
> >> -                                           (const u8 *) &rsn_capab,
> >> -                                           sizeof(rsn_capab));
> >> +       if (!ath6kl_get_rsn_capab(&info->beacon, (u8 *)&rsn_capab)) {
> >> +               ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "RSN caps %d\n",
> > rsn_capab);
> >> +
> >> +               res =3D ath6kl_wmi_set_rsn_cap(ar->wmi, vif->fw_vif_id=
x,
> >> +                                            rsn_capab);
> >>                  vif->rsn_capab =3D rsn_capab;
> >>                  if (res < 0)
> >>                          return res;
> >
> > So, let me see if I understand this correctly.  Original flow was:
> >
> > 1. get RSN capable from the beacon if one
> > 2. if the firmware is capable of the override, set the IE  else don't d=
o
> > anything
> >
> > New flow:
> > 1. get RSN capable from the beacon if one
> > 2. unconditionally send the rsn_cap WMI down
> >
> > So, what happens on a firmware that _does_ have the rsn-cap-override
flag
> > set? I'm guessing nothing good.  Admittedly I haven't tried your patch
on
> > my platform.
> >
> > I think that simply ignoring the flag and using a WMI instead of settin=
g
> > the IE on all devices AR6002..AR6004 is likely going to cause problems
for
> > everyone else.

> Admittedly, I have not a wide range of devices to test. This patch was
> mostly an RFC to see if the issue is only for a particular fw revision
> and to expose it for people that might find it useful. Note that I am
> not the first person to hit this, see for instance

> http://www.spinics.net/lists/linux-wireless/msg115085.html


Fair enough. However, breaking it for the rest of the devices out there
isn't good. I welcome the fixing of it, but it has to be done across the
spectrum of the supported chips.



> >
> >
> >> @@ -3918,14 +3916,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
> >>                  return -EINVAL;
> >>          }
> >
> >> -       /*
> >> -        * Even if the fw has HT support, advertise HT cap only when
> >> -        * the firmware has support to override RSN capability,
otherwise
> >> -        * 4-way handshake would fail.
> >> -        */
> >> -       if (!(ht &&
> >> -             test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
> >> -                      ar->fw_capabilities))) {
> >> +       if (!ht) {
> >
> > Perhaps the comment isn't relevant if we're using the RSN WMI command
on a
> > device with the flag, but I'm willing to bet you neither tested it nor
that
> > the assumption is true.  I'm guessing this change just broke the 4-way
> > handshake for the majority of devices.
> >
> >>                  ath6kl_band_2ghz.ht_cap.cap =3D 0;
> >>                  ath6kl_band_2ghz.ht_cap.ht_supported =3D false;
> >>                  ath6kl_band_5ghz.ht_cap.cap =3D 0;
> >> diff --git a/drivers/net/wireless/ath/ath6kl/main.c
> > b/drivers/net/wireless/ath/ath6kl/main.c
> >> index db95f85751e3..4e186f8b3950 100644
> >> --- a/drivers/net/wireless/ath/ath6kl/main.c
> >> +++ b/drivers/net/wireless/ath/ath6kl/main.c
> >> @@ -579,13 +579,9 @@ static int ath6kl_commit_ch_switch(struct
ath6kl_vif
> > *vif, u16 channel)
> >>                   * reconfigure any saved RSN IE capabilites in the
beacon
> > /
> >>                   * probe response to stay in sync with the supplicant=
.
> >>                   */
> >> -               if (vif->rsn_capab &&
> >> -                   test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
> >> -                            ar->fw_capabilities))
> >> -                       ath6kl_wmi_set_ie_cmd(ar->wmi, vif->fw_vif_idx=
,
> >> -                                             WLAN_EID_RSN,
> > WMI_RSN_IE_CAPB,
> >> -                                             (const u8 *)
> > &vif->rsn_capab,
> >> -                                             sizeof(vif->rsn_capab));
> >> +               if (vif->rsn_capab)
> >> +                       ath6kl_wmi_set_rsn_cap(ar->wmi,
vif->fw_vif_idx,
> >> +                                              vif->rsn_capab);
> >
> >
> > So, basically same comment as the first one.
> >
> >>                  return ath6kl_wmi_ap_profile_commit(ar->wmi,
> > vif->fw_vif_idx,
> >>                                                      &vif->profile);
> >> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c
> > b/drivers/net/wireless/ath/ath6kl/wmi.c
> >> index 777acc564ac9..d7de9224d755 100644
> >> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> >> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> >> @@ -4168,3 +4168,26 @@ void ath6kl_wmi_shutdown(struct wmi *wmi)
> >>          kfree(wmi->last_mgmt_tx_frame);
> >>          kfree(wmi);
> >>   }
> >> +
> >> +int ath6kl_wmi_set_rsn_cap(struct wmi *wmi, u8 if_idx, u16 rsn_cap)
> >> +{
> >> +       struct sk_buff *skb;
> >> +       struct wmi_rsn_cap_cmd *cmd;
> >> +
> >> +       skb =3D ath6kl_wmi_get_new_buf(sizeof(*cmd));
> >> +       if (!skb)
> >> +               return -ENOMEM;
> >> +
> >> +       ath6kl_dbg(ATH6KL_DBG_WMI, "set_rsn_cap: 0x%04x\n", rsn_cap);
> >> +
> >> +       cmd =3D (struct wmi_rsn_cap_cmd *)skb->data;
> >> +       cmd->rsn_cap =3D cpu_to_le16(rsn_cap);
> >> +
> >> +       return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
> > WMI_SET_RSN_CAP_CMDID,
> >> +                                  NO_SYNC_WMIFLAG);
> >> +}
> >> +
> >> +int ath6kl_wmi_get_rsn_cap(struct wmi *wmi, u8 if_idx)
> >> +{
> >> +       return ath6kl_wmi_simple_cmd(wmi, if_idx,
WMI_GET_RSN_CAP_CMDID);
> >> +}
> >> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h
> > b/drivers/net/wireless/ath/ath6kl/wmi.h
> >> index a60bb49fe920..011d4b6fb5ab 100644
> >> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> >> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> >> @@ -597,10 +597,6 @@ enum wmi_cmd_id {
> >
> >>          WMI_GREENTX_PARAMS_CMDID,
> >
> >> -       WMI_RTT_MEASREQ_CMDID,
> >> -       WMI_RTT_CAPREQ_CMDID,
> >> -       WMI_RTT_STATUSREQ_CMDID,
> >> -
> >>          /* WPS Commands */
> >>          WMI_WPS_START_CMDID,
> >>          WMI_GET_WPS_STATUS_CMDID,
> >> @@ -621,6 +617,10 @@ enum wmi_cmd_id {
> >>          WMI_RX_FILTER_COALESCE_FILTER_OP_CMDID,
> >>          WMI_RX_FILTER_SET_FRAME_TEST_LIST_CMDID,
> >
> >> +       WMI_RTT_MEASREQ_CMDID,
> >> +       WMI_RTT_CAPREQ_CMDID,
> >> +       WMI_RTT_STATUSREQ_CMDID,
> >> +
> >>          WMI_SEND_MGMT_CMDID,
> >>          WMI_BEGIN_SCAN_CMDID,
> >
> >> @@ -2533,6 +2533,10 @@ enum wmi_sync_flag {
> >>          END_WMIFLAG
> >>   };
> >
> >
> > I can factually state that the above reordering of the commands is wron=
g
> > for a 6003. The order in the WMI file is consistent for a 6003. Your
> > reordering is consistent for a 6004. Now, the only commands affected by
the
> > reordering aren't utilized by the driver, other than your added get/set
> > RSN_CAP_CMDIDs.  But on a 6003, your now used WMI_SET_RSN_CAP_CMDID wil=
l
> > trigger a WMI_GET_OPPPS_CMDID, which isn't what you want.
> >
> > I've encountered this issue a before - wmi code mismatch between the
> > different firmwares and the driver. This is a limitation of the driver
that
> > probably should be resolved in some meaningful way. To date, it's been
> > mitigated by the driver just not using the higher-numbered commands.
But
> > by "meaningful way" I don't include redefining command IDs in favor of
one
> > particular person's firmware and causing problems on the other 99% of
> > devices out there.

> Agreed. I do not have access to much information for the ath6k, so
> this was more like a shot in the dark.

> >
> >> +struct wmi_rsn_cap_cmd {
> >> +       __le16 rsn_cap;
> >> +} __packed;
> >> +
> >>   enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi);
> >>   void ath6kl_wmi_set_control_ep(struct wmi *wmi, enum htc_endpoint_id
> > ep_id);
> >>   int ath6kl_wmi_dix_2_dot3(struct wmi *wmi, struct sk_buff *skb);
> >> @@ -2728,4 +2732,7 @@ void *ath6kl_wmi_init(struct ath6kl *devt);
> >>   void ath6kl_wmi_shutdown(struct wmi *wmi);
> >>   void ath6kl_wmi_reset(struct wmi *wmi);
> >
> >> +int ath6kl_wmi_set_rsn_cap(struct wmi *wmi, u8 if_idx, u16 rsn_cap);
> >> +int ath6kl_wmi_get_rsn_cap(struct wmi *wmi, u8 if_idx);
> >> +
> >>   #endif /* WMI_H */
> >> --
> >> 2.14.1
> >
> >
> >  From your answer to Kalle re: what hardware
> >
> >> I have tested this in an Atheros QCA6234. kmsg shows this about the fw=
:
> >
> >> ath6kl: ar6004 hw 3.0 sdio fw 3.5.0.604 api 1
> >> ath6kl: firmware supports: 64bit-rates,ap-inactivity-mins
> >
> > The firmware you're using is old. Mine for the QCA6234 is more advanced
> > than that and has the rsn-cap-override flag, but even the stock one in
> > linux-firmware is more up-to-date: 3.5.0.2356 api 3. I haven't run it
> > recently to see if it also has the rsn-cap-override flag, but it might.
> > Maybe you can try the current firmware to see if it solves your issue?

> This is hw 3.0, there is actually no ath6k/AR6004/hw3.0 folder in
> linux-firmware. I would appreciate pointers for more modern fw for
> this hardware version if you have them.

Ah.  Silly me, I just looked at the highest number in linux-firmware.
You're right, there's no HW 3.0 in there. I know there's a publically
available firmware for HW 3.0 out there, because I have a note on it, but I
don't recall where I saw it as it's been years.

@Kalle - do you have a more recent official QCA drop for this chip? And if
so, can we get it into linux-firmware?

You never said who's module you're using. If it's a Laird SD/MSD/WB50NBT,
the firmware I use has the rsn-cap-override and is easy to get from them.
It should look like:
     ar6004 hw 3.0 sdio fw 3.5.0.10011 api 5
     firmware supports:
sched-scan,rsn-cap-override,sscan-match-list,rssi-scan-thold,tx-err-notify,=
sched-scan-v2,hb-poll,64bit-rates,no-ip-checksu

There possibly is a more current version than I have on-hand.

- Steve

--
Steve deRosier
Cal-Sierra Consulting
https://www.cal-sierra.com/

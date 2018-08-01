Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15660 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbeHAKjZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:39:25 -0400
From: Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCHv2] ath10k : Fix channel survey dump
Date: Wed, 1 Aug 2018 08:47:56 +0000
Message-ID: <1170e721d5ea4e00b671698fbe56c735@APSANEXR01F.ap.qualcomm.com> (sfid-20180801_105647_807605_B8D140A0)
References: <1533039077-1532-1-git-send-email-vnaralas@codeaurora.org>
 <3dd6d368-e54e-d8ba-d538-c48617a575b9@candelatech.com>
In-Reply-To: <3dd6d368-e54e-d8ba-d538-c48617a575b9@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Ben
> Greear
> Sent: Tuesday, July 31, 2018 11:08 PM
> To: Venkateswara Naralasetty <vnaralas@codeaurora.org>;
> ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCHv2] ath10k : Fix channel survey dump
>=20
> On 07/31/2018 05:11 AM, Venkateswara Naralasetty wrote:
> > Channel active/busy time are showing incorrect(less than previous or
> > sometimes zero) for successive survey dump command.
> >
> > example:
> > Survey data from wlan0
> > 	frequency:                      5180 MHz [in use]
> > 	channel active time:            54995 ms
> > 	channel busy time:              432 ms
> > 	channel receive time:           0 ms
> > 	channel transmit time:          59 ms
> > Survey data from wlan0
> > 	frequency:                      5180 MHz [in use]
> > 	channel active time:            32592 ms
> > 	channel busy time:              254 ms
> > 	channel receive time:           0 ms
> > 	channel transmit time:          0 ms
> >
> > This patch fix this issue by assigning 'wmi_bss_survey_req_type'
> > as 'WMI_BSS_SURVEY_REQ_TYPE_READ' which accumulate survey data in
> FW
> > and send survey data to driver upon the driver request. Wrap around is
> > taken care by FW.
> >
> > hardware used : QCA9984
> > firmware ver  : ver 10.4-3.5.3-00057
>=20
> Have you tested this on other firmwares?  I am pretty sure that at least =
some
> of them, probably 10.2, will have issues.
>=20
I have tested this change with firmware version 10.2.4-1.0-00036 (hw used Q=
CA988x) as well it's working fine for me without any issues.
=20
> Maybe you could make this change specific to certain firmware that is kno=
wn
> to work with the change?
>=20
> Thanks,
> Ben
>=20
> >
> > Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> > ---
> > v2:
> >  * updated commit log.
> >
> >  drivers/net/wireless/ath/ath10k/mac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> > b/drivers/net/wireless/ath/ath10k/mac.c
> > index f068e2b..db93ab1 100644
> > --- a/drivers/net/wireless/ath/ath10k/mac.c
> > +++ b/drivers/net/wireless/ath/ath10k/mac.c
> > @@ -6837,7 +6837,7 @@ ath10k_mac_update_bss_chan_survey(struct
> ath10k *ar,
> >  				  struct ieee80211_channel *channel)  {
> >  	int ret;
> > -	enum wmi_bss_survey_req_type type =3D
> WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
> > +	enum wmi_bss_survey_req_type type =3D
> WMI_BSS_SURVEY_REQ_TYPE_READ;
> >
> >  	lockdep_assert_held(&ar->conf_mutex);
> >
> >
>=20
>=20
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

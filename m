Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48239 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdAKHsu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 02:48:50 -0500
From: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] cfg80211: Add support to sched scan to report
 better BSSs
Date: Wed, 11 Jan 2017 07:48:43 +0000
Message-ID: <54d6fd2bc55f4c9290402e692ed27005@aphydexm01b.ap.qualcomm.com> (sfid-20170111_084900_864882_D22EE636)
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
 <25527a43-0458-f9f4-9afb-f5986dffbae1@broadcom.com>
In-Reply-To: <25527a43-0458-f9f4-9afb-f5986dffbae1@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
=20
> > + * @relative_rssi_set: Indicates whether @relative_rssi is set or not.
>=20
> So you see a use-case for doing a scan with @relative_rssi being zero, ri=
ght?

Yes. Zero value for relative_rssi is also valid.

> > + * @relative_rssi: Relative RSSI threshold in dB to restrict scan resu=
lt
> > + *	reporting in connected state to cases where a matching BSS is
> determined
> > + *	to have better RSSI than the current connected BSS. The relative RS=
SI
> > + *	threshold values are ignored in disconnected state.
>=20
> The description says "better RSSI" so I suppose it could be typed as u8.
> The last sentence is intended driver behavior

I like to leave this as s8 only. This will leave more flexibility to usersp=
ace especially in case of more than two bands in future.
=20
> > +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]) {
> > +		request->relative_rssi =3D nla_get_s8(
> > +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]);
> > +		request->relative_rssi_set =3D true;
> > +	}
> > +
> > +	if (attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]) {
>=20
> Maybe I misread but I thought this attribute to be applicable only if
> request->relative_rssi_set is true.

@relative_rssi is valid only when @relative_rssi_set is set to true and @rs=
si_adjust is valid only when @relative_rssi is valid. I think that is under=
standable to drivers and there is no need of explicit check here.

> >
> > -static int nl80211_send_wowlan_nd(struct sk_buff *msg,
> > +static int nl80211_send_wowlan_nd(struct wiphy *wiphy,
>=20
> This seems to be unrelated change. At least I do not see any reference to=
 wiphy
> variable in the added code below.

My bad, Will remove this unnecessary change and upload a patch.

Thanks,
Vamsi

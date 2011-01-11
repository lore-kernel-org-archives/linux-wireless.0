Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38559 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1AKIEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:04:45 -0500
Subject: Re: [PATCH v5 1/2] wl12xx: BA initiator support
From: Luciano Coelho <coelho@ti.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	 <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
	 <1294671655.1992.103.camel@pimenta>
	 <AANLkTi=KnSjVVCN=9=PaL9_GYpDOpJFvD-LGxFXEevhw@mail.gmail.com>
	 <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 10:04:42 +0200
Message-ID: <1294733082.12992.21.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 01:18 +0100, Levi, Shahar wrote:
> On Tue, Jan 11, 2011 at 2:13 AM, Levi, Shahar <shahar_levi@ti.com> wrote:
> >
> > On Mon, Jan 10, 2011 at 5:00 PM, Luciano Coelho <coelho@ti.com> wrote:
> >>
> >> On Mon, 2011-01-03 at 14:42 +0100, Shahar Levi wrote:
> >> > diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> >> > index 9cbc3f4..df48468 100644
> >> > --- a/drivers/net/wireless/wl12xx/acx.h
> >> > +++ b/drivers/net/wireless/wl12xx/acx.h
> >> > @@ -1051,6 +1051,40 @@ struct wl1271_acx_ht_information {
> >> >         u8 padding[3];
> >> >  } __packed;
> >> >
> >> > +#define BA_WIN_SIZE 8
> >>
> >> Should this be DEFAULT_BA_WIN_SIZE?
> >
> No, the FW support win size of 8. it is not configurable.

If only 8 is supported, why do we even have to pass it to the firmware
in the ACX_BA_SESSION_POLICY_CFG command? I think that, even though this
cannot be really changed, it should be part of the conf structure.


> >> > +{
> >> > +       char fw_ver_str[ETHTOOL_BUSINFO_LEN];
> >>
> >> This is weird, but it seem to be what is used in cfg80211 (as Shahar
> >> pointed out on IRC).  IMHO it should be ETHTOOL_FWVERS_LEN instead, both
> >> here and in cfg80211.
> >>
> >> In any case, this is a bit confusing here, because we don't use the
> >> fw_version in the wiphy struct (we probably should).  Let's keep it like
> >> this for now and maybe later we can change.
> >>
> >> Also, I don't see why you need a local copy here.
> >
> i use local copy in order to remove '.' (*fw_ver_point = '\0') without
> destroyed wl->chip.fw_ver_str.

Ah, I see, but if you use sscanf, as I suggested, this won't be needed
anymore.


> >> > @@ -161,10 +166,13 @@ struct wl1271_partition_set {
> >> >
> >> >  struct wl1271;
> >> >
> >> > +#define WL12XX_NUM_FW_VER 5
> >> > +
> >>
> >> WL12XX_FW_VER_OFFSET sounds better to me.
> >>
> >> And it shouldn't it be 4,
> >> which is the "Rev " prefix?
> >
> the macro represent the number of numbers in the version. it is not offset.

Right, I guess I didn't follow your algorithm in details, since using
sscanf would be much easier.


-- 
Cheers,
Luca.


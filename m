Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA726461F
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 04:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785386033; cv=pass; b=YmkE0D8QRiF1YHaJnwCMx5wdQvWNrJ+IFSCujM19+Dfcc07TEfhHyfHFmaiGgtWOhJrknOdSGUzdOHvYngLgRREw9RyRc2R+ddHWK0bgZIRobWHuw7JPHOCtc+/WdadVJXu1ZrEc0gsDRRvxNYqpEqFJ+AstzxTcgNWT521Yiqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785386033; c=relaxed/simple;
	bh=kyOx3qzGP8+DYM0Igihk2bi9jOoiLZwFZLTqoso8B60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJnCeWaphyQvvCMONLGHahkD68YLtxMAXeZ3jyBd6z31/jcaM02egr/BAcRbQ7mjzdBaQk9AVGP4J1w7qEYouSGh5UTj5AOGzQwQcVoTrxzpyAnIZUtrZAg0lbAo/Yw9ubLYTz7tnImU1O4540je3LcZPZJ5Ay+zBApZaTZeuXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o//arq7s; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o//arq7s"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69f734cd461so217285a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 21:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785386030; cv=none;
        d=google.com; s=arc-20260327;
        b=G7W1Uc9nFg1zYoO3rLw0sz3BdDkJ7Qw7OiBsd7vqMnIzQbN3GjvAv4qZqTc5oJcjC9
         V5UChS62RHoVhA0TmJBmbGdftmmMfhekbjHFn//Pzi9pWSEDkLZUl7p8yWpiLLX2qP20
         VI9YR1g/nQW+CU3AHk9xy+cL5Qzwyyp6YSng1Zl9rieqIgfXkUt4BFOs9xjP6yvKEJx2
         +12W21kMoMyx4CCC32RUtKFOahh/xE7PpvcpkNSjFlN9bThD0kiO/Om0Brvhy4raZH11
         apQAt4NDolc/OcFWJO9pJi0UNjMj0rPPR/0B8YJy0G8u77nAuwlbx7RRClrgp6G8Fu05
         sHow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qo5bTcyEgwxKv/RE8wlvgqZrF3Kc2k1fuqDN8MdgDoc=;
        fh=aKOTxJi4jyrNN3r/Yy2VFHZ2mojm9enz4CpKF2bOF+Y=;
        b=LVyNs6rS6YMrzgYyt37iZMpMDn+7Ej5YiTh09LiLCF0OTW46Gfr+Wphytobduh9VWI
         b4r8CBul+PepLi52BmgT30wyiygZZyi41Xl5oXP9g6YQniQALdV55ZryYKmceQ8o9KT3
         9xoHzvMB1M6HcY8YrF3R2ivl3YFaetgp7pjETxFX9HP/5XMChJ2f4llVjIDe50o9S0CE
         sKsR0DKrFW6V9Rwp+tn4NxcRciaEyCzrLhJvuZnIPXocGI9bkKEgeV4JsCNenztb/ZuQ
         ewaQkkc+Ti5RPdJ5wTtdleTOLElTb1teHg9+BaUsMNJIy6qtKuB3tkpioCmV4kBn8o9W
         gu3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785386030; x=1785990830; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qo5bTcyEgwxKv/RE8wlvgqZrF3Kc2k1fuqDN8MdgDoc=;
        b=o//arq7siyGnzT2PiXFcu8MyruOHua1rKp3uAysCxzZ7Pd8Fyv0ZBIXOPCJhGmWkMb
         XiBvXp4uwnjTKdbcXzHwmvRXUEbda59kLWQh9EMLHBKWIUONsPYr18WIkDN3HDExHCjp
         qEXJ6elTPsm6TFJz1J75wbS6o64dFDUQ5cfbtmkh5BokLXxZ56molm0Frn51gKoDTSOg
         DrQF7FuPl0PVn4kuGPPJmHhc/1FlOJ23jZRioG3v5JqJpUrL+z+78H/xyynRO5SJjB5N
         QMbBd7UdHbPoAyPlQFxMvhxOqwYDG5aBOgZYFtqyfSyrrhjiDkqlqsEA3dUQsHdMWgtX
         0sGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785386030; x=1785990830;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qo5bTcyEgwxKv/RE8wlvgqZrF3Kc2k1fuqDN8MdgDoc=;
        b=UyweTTpoQRvy16578LondMEb/Waml5iU/8oGJwWooOZEKwhMASx3bb4f8zApEzOJcy
         n/pL+C74SGnBHy+wZAjDFMScKPE88DBHRI0h92Ia2kzCpLJHFlRNPzL0tmNmMldSUBK5
         SVHUCHS4wDllmL4lOo8uGj7nkAZjUblwkBBJun2ZnMdYjSxc5qw8OkioN0xBSWvyiy+F
         jffCRLvWP5WLnxn0qW9my4VXWIWCBUjM1VUwR1h8ZXAULUKUt6U2M2l8q2vODYsYIDXu
         cJg1MPaSCOf0vbYQlGJLZhtfy/uJnKef1DPok1VqIJqLn2HSSFPbwZTWZZOLdeFrAhWR
         Ca3w==
X-Gm-Message-State: AOJu0YzRa02TRU9XEgZRXLWsoLOLgUm8lSaQhkUA/cETxRO6EHVXkCWG
	y8Cwjy33qbWekFfACnnflI35hjTIycAWrd9R2b4NbZE14ofXp1iavwd24lNo4MgmVFqAhjUyYlz
	17DjWfDoxzm5u3K/cuYgyb+49NkYDweE=
X-Gm-Gg: AR+sD11zFJNVT3Zlo/2t6datqclGO7qxWnqpDZCo+HGFZavbKKtlJWS1KWA/9hL/jfL
	o8EMe65vTEp1A8jZ3ofEQLxYqZLopdcfE6WHcdQoFvo+zI6JP8+kUehpKalTZqLhSa6ZSK4AN3M
	Ofp3M+ZfJmT83RsL6nKh9I3QRwMntWbyrqbvtEN9KOhFmzdBiUh9oICJdsZsWJeFhU6XViN9uii
	ujHHuQytddUHLgI5qbz0tmNVA9hhUoBfnKDxftwhhu0lx4578cBgbWdvSLyejXSQKogfX5xHFgF
	Qsj89HJXyUUkiE8P8MBRifo+Axwqzgtggb3VwFKZ3JqWIiNBMLXTxdeR0KtHr9BrG/ixUaiyP/P
	43o3ECJrHL9sfAptviD/i04xRY9ZDi0n+yZjVwyB9Wek=
X-Received: by 2002:a05:6402:2792:b0:6a0:eb:ae4b with SMTP id
 4fb4d7f45d1cf-6a07b53987dmr448092a12.0.1785386029768; Wed, 29 Jul 2026
 21:33:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com> <CA+ORkNQntwC4k2arcngGdYB3mwsbJCkCRNTJRJ2GoRxjdGXLzA@mail.gmail.com>
 <c452116c-6215-4d62-b96b-72ae23a478e1@broadcom.com> <CA+ORkNSsb8Z5eUVH1GRvWtO_he6A+_b67ov2Cm6VJuWciJeKZQ@mail.gmail.com>
In-Reply-To: <CA+ORkNSsb8Z5eUVH1GRvWtO_he6A+_b67ov2Cm6VJuWciJeKZQ@mail.gmail.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Wed, 29 Jul 2026 23:29:59 -0500
X-Gm-Features: AUfX_mzaHH2vW7h39z8Rz_JT1cnvFYJQ6qtIa7jMngupATV60VsZSG2dQZna7GM
Message-ID: <CA+ORkNSG45LrTu09AiHNwTZ882Yybq-3E-=enwe+2eA36fEO4g@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gokul,

Looks like this is also missing, can you please add it in your patch:

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d32b35ce0..455f5619f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -77,6 +77,11 @@

#define        DOT11_BCN_PRB_FIXED_LEN         12      /* beacon/probe
fixed length */

+#define WL_IOV_OP_BSSCFG_DISABLE               0
+#define WL_IOV_OP_BSSCFG_ENABLE                        1
+#define WL_IOV_OP_MANUAL_STA_BSSCFG_CREATE     2
+#define WL_IOV_OP_MANUAL_AP_BSSCFG_CREATE      3
+
#define BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS   320
#define BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS  400
#define BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS      20
@@ -5260,6 +5265,19 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy,
struct net_device *ndev,
               if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss)=
)
                       brcmf_fil_iovar_int_set(ifp, "mbss", 1);

+               if (!test_bit(BRCMF_VIF_STATUS_AP_CREATED,
&ifp->vif->sme_state)) {
+                       bss_enable.bsscfgidx =3D cpu_to_le32(ifp->bsscfgidx=
);
+                       bss_enable.enable =3D
+                               cpu_to_le32(WL_IOV_OP_MANUAL_AP_BSSCFG_CREA=
TE);
+                       err =3D brcmf_fil_iovar_data_set(ifp, "bss", &bss_e=
nable,
+                                                      sizeof(bss_enable));
+                       if (err < 0) {
+                               bphy_err(drvr, "bss_enable config failed %d=
\n",
+                                        err);
+                               goto exit;
+                       }
+               }
+
               err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
               if (err < 0) {
                       bphy_err(drvr, "setting AP mode failed %d\n",

Thanks,
Bogdan

On Wed, Jul 29, 2026 at 8:19=E2=80=AFAM Bogdan Nicolae <bogdan.nicolae@gmai=
l.com> wrote:
>
> Gokul,
>
> Great to hear. Are there any other changes you are planning to submit?
> I found this to be the minimal working config at least for WPA3 personal,=
 but would like to know if I am missing anything else.
>
> Thanks,
> Bogdan
>
> On Wed, Jul 29, 2026, 07:28 Arend van Spriel <arend.vanspriel@broadcom.co=
m> wrote:
>>
>> On 29/07/2026 13:48, Bogdan Nicolae wrote:
>> >> On Wed, Jul 29, 2026, 04:48 Arend van Spriel
>> >> <arend.vanspriel@broadcom.com <mailto:arend.vanspriel@broadcom.com>> =
wrote:
>> >>
>> >>     On 29/07/2026 07:34, Bogdan Nicolae wrote:
>> >>      > When bringing up a WPA3-SAE SoftAP with external (user space)
>> >>     SAE, the
>> >>      > driver never told the firmware which SAE Password Element (PWE=
)
>> >>     method to
>> >>      > accept. The firmware was observed to corrupt its heap over tim=
e
>> >>     due to
>> >>      > this omission, leading to firmware trap (data abort in heap
>> >>     allocator).
>> >>      >
>> >>      > Parse the beacon IEs on start_ap() and set the extsae_pwe iova=
r
>> >>      > accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-=
only
>> >>      > membership selector is present, 0 otherwise. This matches the
>> >>     behaviour
>> >>      > of the upstream/vendor driver and only applies to SAE-capable =
APs
>> >>     when
>> >>      > external SAE is supported.
>> >>
>> >>     This makes sense, but may I ask what device do you have? Suspect =
it
>> >>     is a
>> >>     Cypress/Infineon chip. I could not find the iovar in our (Broadco=
m bca)
>> >>     code base so I suspect it is vendor specific.
>> > Hi Arend,
>> >
>> > Indeed, this is a bcm43455 as found on Raspberry Pi SoCs.
>> Than we should only invoke the parse function for cyw vendor.
>>
>> Regards,
>> Arend

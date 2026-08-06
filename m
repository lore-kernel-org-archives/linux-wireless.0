Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8066388397
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993088; cv=pass; b=KI7dA5MJDtVZXP7Tza52sd6kexexvXSPuw8TdQjztBpcPV2nEMDgz7Gi70+Tj/6hnl5ZbcgKNHPeNx7DS4fZ4q6fW8HyRq+vH0ocfMDSczkR4cpMAvexNkx/W7hM+5WOD773m/VXzOJpzg3y8wacpq0JEOjHtA9je1Jwtnt9uMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993088; c=relaxed/simple;
	bh=k1goGX9ms2y8+aqdJQdoISCFl5wLZrig4iyvTQP2HtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WjNgZcs24qbm1rqatg6JZBV32GYBg09xJWOfo1h0FIV7eLOhXCeLBRKagD43m8R+254rpn7bmMIoHb55fMuBPv9MEGG9CgSIv13rHEWSO+VP/cKuohtfne7aDUZg8e3+Kfxzc64ByO3pmJjSpB/4emgBpOhQty2H3z8TLpyZZu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nac5Ie1V; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nac5Ie1V"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-908239232adso3326516d6.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 22:11:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785993086; cv=none;
        d=google.com; s=arc-20260327;
        b=Zo02pA/m4agnLB2uly2QXVCytc4+HYZ6NXKXn+rQQcfvPknvM1iHMm6fax3KUvAj+t
         Ixr5FuxUXyMUKFsYjcENEG+/qhcuhEul1xq22K8wRog+0QbjLObYX+7h57oR0HZaH/oG
         LCN0ckkMBsRNVHYEo8mK5H7l+S5ekMVMqvnT4W7vFTNnVr1m/GGIEg8k1sStM2uj0bIE
         hhwFLQA4JVNR40K84ak/nvasVgnq7ge83IDDl/lNv9UZrKAg24jt8ZhC8hUhAqF+sarR
         IWkM9kV3WMZuCN6PTKdDw/1tQ7A4pS2Rqv+gVSbruzoL1Yrk07WOKL+3fb+l5jQ6yUfP
         7E3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IgMEv8RBPh4y366LZ+1BocbTIa3kWw/yR9S8afmJwhM=;
        fh=wwW/3Gp/VpTGC2wmGnR08siYMkLCOjZ+9nEkcE2B3L0=;
        b=DzsicT/JcNDBH1+lotQgWtnFqq7C+wQDhvnHkzX1hkMvlbNQskvxRTbzwPyukqpF33
         s95BtF/jfT4aq+pwiCiO7oq1nyaNDW+me46Fg7GN7SNbhkdUSUBk6PFTy0bWSycrbVDK
         Radq8VcQEr+5u0JgT491QhhZ8QYIH03QnF/Y1hVPcjud9wxUStYZAkFVPjgYY3tgmxqn
         Mqhev953YgE9kyclgaaE+VkBDhZbDpZuEsx883XFodr7OWI7J4UsTnOwGGom0/sOFtON
         l66kOXj7KhBp0+PvooAlkOUoGsVDWVR6+s21ppukt8uefM+Thh5cVzjyqw/xMl3tIvS5
         KPgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785993086; x=1786597886; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IgMEv8RBPh4y366LZ+1BocbTIa3kWw/yR9S8afmJwhM=;
        b=Nac5Ie1VvC57UBoaPfrViZCq49wkclGJHq7MFH6uqR8OIo4gTK+0Ay5ujHN3oWhCA2
         ZuUO10cpUQ1cQuY8JQ60wRfDswvSDaHI2OFF2SjMXhFqgtLrWRvyycfo92DW4ClO9qJc
         hv3+NdoRa9dp7v6FILBRJ9BimS9Ar1hJrB2P4irgJ0ecfODMyMdVUjpzxHTBejAwSTRQ
         O5zZk0kHOLXar71xto7GtEBUfvikGLKv2nP30Kv96gxMWB7vAtBqLRRSOCKZddVL+Mt7
         UMQMXH7vGqpyEksOGtZtBshcbXd0pI8YJvtK3LRY60ONco7qEbHzJwcrf4BMeP6ql3At
         qgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785993086; x=1786597886;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgMEv8RBPh4y366LZ+1BocbTIa3kWw/yR9S8afmJwhM=;
        b=LUIeinVXJMH8Gh5NiCMT3PZkojknKG0o1N2YOOb/OSDDKKXT+ZGBdyiNrm7JTF6aqE
         B++YuW2phTlcLbrZoGjn4jnDugOLsL69e13LEmOqN60sihRt9t60Lkb8BozIPT0ZoFdl
         uQm6dpaIrMNzHAVUWTi04xLuYMZxPb3lTXhug2Onm7ACLV2LX81MMfy7cOl5qzTfcEcj
         je9NaeeUrBkkgpkzjPnRZFXlP15z6C3KDNTrSeKMhl3mBUCoZcmXr0OdnKXn6LwG7c9t
         6vF5T59qVaSQRalSwjAcQesKQWzmmS3hENNWjh1hwNQeqpy+MG8tqg1KFB3XRB10gYJQ
         jSjA==
X-Forwarded-Encrypted: i=1; AHgh+RozWgXfJLpqOOd8+nzSk9fw+tpZgRab1sU/EQn5fsaRuu7T4YCSIylb/J/2RF9H6l2UqtghqXQihKfnrg31rw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4UbCiqI2sPeK6T8ti58LI36WhWqJpXr1HIpQ0THFdtBPw46mG
	5qLPOm0h52ZlDDUyZ7jJi4R9iqRIN5vHNHBZO4Pt1q1IQSkv1b2VRRTgz879b3ZsoX1SF5Y5XIB
	nKW/QAq6PgYEbTw1bFEuDApZAUD/lBPJfWZVY
X-Gm-Gg: AR+sD100R8IOD4C06hF80dMDLR+eCKECs9fkgAfmiCfLgkJbXkpqkXSztCI5sN8ZGIb
	0+niX3yw3vIT+4UwTKyXLH+bMqVcyo9BNQcS5AnCG6ZriRdqxlfmchFIjDkqWt9k4xhTRHQc+aa
	K0fxpfDi1gzrea26R9Q7k/KZttDMUoCj0P8oR7WCoTBcur2VQ0qgm6HYiriJirqcktpzQp9/uqV
	viYJ1pExMix/FQDgB+rDt0kVYC1EEcVwLGE5EcJl79H1xssszYpj+8m0rXqpw9ykH01Ihuxaq5b
	fpolpQMEpJEPrl9ELuUenb3GjD4Eepx53z3hwH1WESFf
X-Received: by 2002:a05:6214:f25:b0:8f1:ed00:7fd8 with SMTP id
 6a1803df08f44-9088f7b8eccmr48849346d6.3.1785993085612; Wed, 05 Aug 2026
 22:11:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801004243.489010-1-perceivalpercy@gmail.com> <88d5042e-21e2-497c-b86d-3cdf8c0642dc@oss.qualcomm.com>
In-Reply-To: <88d5042e-21e2-497c-b86d-3cdf8c0642dc@oss.qualcomm.com>
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
Date: Thu, 6 Aug 2026 07:11:14 +0200
X-Gm-Features: AUfX_mznDfeEMS-VWWTO4_p31iY5MFEpIwhVYBSCQLBJd3y4jNQ0MDuzru0BpCs
Message-ID: <CAKXN084AmmjNWLM2fmczTpvDxr15t9-YmvZVCKGbO6TYzfOOrg@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Esteemed Rameshkumar,

Thanks for the review and for the correction =E2=80=94 you're right, and my=
 commit
message is wrong. I've verified it in the tree rather than argue it:

`cfg80211_iftype_allowed()` (net/wireless/util.c) short-circuits before
`interface_modes` is consulted for the 4addr case:

case 0:
if (is_vlan && is_4addr)
return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
return wiphy->interface_modes & BIT(iftype);

and `WIPHY_FLAG_4ADDR_AP` is set unconditionally by mac80211 at alloc time,
not gated on AP_VLAN being advertised (net/mac80211/main.c, in
`ieee80211_alloc_hw_nm()`):

wiphy->flags |=3D WIPHY_FLAG_NETNS_OK |
WIPHY_FLAG_4ADDR_AP |
WIPHY_FLAG_4ADDR_STATION | ...

So the missing `NL80211_IFTYPE_AP_VLAN` bit cannot have blocked hostapd's W=
DS
path, which sets NL80211_ATTR_4ADDR. The `check_swif =3D=3D 1` case falls b=
ack to
the same flag, so interface combinations don't block it either.

The premise the patch rests on is still correct =E2=80=94 mac80211 skips ad=
ding AP_VLAN
for us because of SW_CRYPTO_CONTROL (main.c):

/* if low-level driver supports AP, we also support VLAN.
* drivers advertising SW_CRYPTO_CONTROL should enable AP_VLAN
* based on their support to transmit SW encrypted packets.
*/
if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP) &&
    !ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL)) {

=E2=80=94 but the consequence I attributed to it is the wrong one. As you s=
ay, what is
actually gated is the non-4addr AP_VLAN case, i.e. dynamic per-station VLAN=
s via
`hostapd_vlan_if_add()`.

On what I actually hit: the symptom was hostapd failing to bring up WDS sta=
tion
interfaces on IPQ5332, and I developed this patch alongside a hostapd fix i=
n
`get_hapd_bssid()` (bss->ctx dispatch), which Jouni has since applied. Give=
n the
above, the hostapd change is almost certainly what fixed the WDS case, and =
my
attribution to this patch was confounded =E2=80=94 the two were tested toge=
ther, and at
least one of my A/B runs was invalid because wpad was never actually restar=
ted.
I should have caught that before writing the commit message.

I'll send a v3 with the rationale corrected to the dynamic-VLAN path and dr=
op
the WDS claim, keeping your Reviewed-by only if you're happy with the rewor=
ded
message =E2=80=94 say the word if you'd rather re-review it.

I have the hardware set up (IPQ5332 AP with a 4addr client), so if it is us=
eful
I can also test the non-4addr dynamic-VLAN path explicitly =E2=80=94 with a=
nd without
the bit =E2=80=94 and report what each does, rather than leaving the justif=
ication
resting on code reading alone.

Regards,
Kamil

On Wed, 5 Aug 2026 at 20:18, Rameshkumar Sundaram
<rameshkumar.sundaram@oss.qualcomm.com> wrote:
>
> On 8/1/2026 6:12 AM, Kamil Bienkiewicz wrote:
> > Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
> > IPQ5332 entry does not. As ath12k sets SW_CRYPTO_CONTROL, mac80211 does
> > not add the mode on the driver's behalf, so AP/VLAN is absent from the
> > wiphy and hostapd cannot create WDS station interfaces:
>
> Small clarification: for WDS station interfaces, hostapd creates the
> AP_VLAN interface with NL80211_ATTR_4ADDR set. That path is allowed by
> cfg80211_iftype_allowed() via WIPHY_FLAG_4ADDR_AP even when
> NL80211_IFTYPE_AP_VLAN is not set in wiphy->interface_modes.
>
> So the missing interface_modes bit seems to affect the non-4addr
> AP_VLAN case instead, e.g. dynamic/per-station VLAN interfaces created
> via hostapd_vlan_if_add(). Is that the failure path you hit?
>
> >
> >    nl80211: Failed to create interface <name>: -95 (Operation not suppo=
rted)
> >
> > The 4-address datapath itself (sta_set_4addr, per-station TCL metadata,
> > WMI_PEER_USE_4ADDR/WMI_VDEV_PARAM_WDS, 4-address frame and NULL/EAPOL
> > handling) is shared Wi-Fi 7 code with no per-chip or per-bus gating, so
> > IPQ5332 can already deliver it. AP_VLAN is a software interface type, s=
o
> > no interface combination changes are needed.
> >
> > On a mixed-bus single-wiphy group the effect is wider still, since
> > ath12k_mac_get_ifmodes() intersects interface_modes across all radios:
> > one IPQ5332 masks AP_VLAN for the QCN9274 radios too.
> >
> > Advertise AP_VLAN on IPQ5332 as QCN9274 does. Tested with 4-address WDS
> > stations on IPQ5332 + 2x QCN9274; RADIUS dynamic VLAN was not tested.
> >
> > Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
> > Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> >
> > Signed-off-by: Kamil Bienkiewicz <perceivalpercy@gmail.com>
> > ---
> > v2: rebased onto ath/main (8150c22bc). No functional change; v1 was
> > generated against a backports tree and its trailing context no longer
> > matched after .supports_cong_ctrl_max_msdus was added to the IPQ5332
> > hw_params entry.
> >
> > IPQ5424 (line ~845, and possibly QCC2072/WCN7850) appears to need the
> > same change, but I have no such hardware, so I have limited this to
> > IPQ5332 which I could test.
> >   drivers/net/wireless/ath/ath12k/wifi7/hw.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/w=
ireless/ath/ath12k/wifi7/hw.c
> > index 7b86f324b..a20c21807 100644
> > --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> > +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> > @@ -664,7 +664,8 @@ static const struct ath12k_hw_params ath12k_wifi7_h=
w_params[] =3D {
> >
> >               .interface_modes =3D BIT(NL80211_IFTYPE_STATION) |
> >                                  BIT(NL80211_IFTYPE_AP) |
> > -                                BIT(NL80211_IFTYPE_MESH_POINT),
> > +                                BIT(NL80211_IFTYPE_MESH_POINT) |
> > +                                BIT(NL80211_IFTYPE_AP_VLAN),
> >               .supports_monitor =3D true,
> >               .supports_cong_ctrl_max_msdus =3D true,
> >
>
> Actual change looks good to me so,
>
> Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

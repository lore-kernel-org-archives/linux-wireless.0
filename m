Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793930866;
	b=CRW+pNG7PJA+X1zbCCAHROdZYT5ur2qUQoFHSeNB9ooE8t0KTUB4P1KYEHguwJvvfloC
	 8SPzdfWPwO4t86m9GsS8RZLmizk0M4Fp+vCEjpk/hEKhaXNGVCYaTMXo5Q+E9iHinchhG
	 /eWOVYkV7WGzCbnqULRakLRAOsB4ZP3vu0+czeval7ZpkUsxBpyPkAAwgcMTYt+Le1RvP
	 aGQckWhcLMvL4xwzqV35c0zw26zkKDT8huxVPB0V9ePSwpcEsOEd9CF2Ms+pNM5g4CFsj
	 rY4ZfWeMBcLUhms4DrawKJY7CnEK1t3ngNfKCWS52QuBRmaskK7egpEKQyYDlObbp2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793930866;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Content-Type:
	 Content-Transfer-Encoding:Mime-Version:Subject:Message-Id:Date:Cc:To:
	 X-Mailer;
	bh=9tVWOE571yIRel1WCas/DMzsKiN3hCHNnaxbQG3mgi0=;
	b=PD5T+BnVHvPNvlb8lT40Yr7oqY1rmL6NarTtEYZcutOsy7C2rRYo742t82QRbpOYcXRn
	 kI6vZu2XegK0OszJ4PXHVKCIUvApX43sZUu1lGEGfFJbbGaGTsOxgzE91enSQwsnB+lpH
	 Snxg2G4NtsArGedC32Qe7idTONc3E0+x88RD4eykrYjLSnGBkto8Uter27jMk31AF9Mci
	 ONPBytdtZB3rFyUGtb4wbcxVysdsvAuZuPAn84ILvx4UX9jin3h8nTql52cLNL76p/d69
	 vgMH/3HYltZYX3nV4KdOiIwHm74Z7I98zi4ZlWn5+YfXj3S5EXzj23E36WSxDZxM2jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r8Fcw000;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AB9606A31B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 02:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3AB9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r8Fcw000
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53665358476so961131cf.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 18:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793930865; x=1794535665; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9tVWOE571yIRel1WCas/DMzsKiN3hCHNnaxbQG3mgi0=;
        b=r8Fcw0000BPjizp5xlh8MhT8PG/EIleM69V6pRu/RlurMmwFZ7Mp0Z5o6JjYowLCKI
         1MLklZV91sksHGOVieYCcabzT/nKZA3AU5VYKf3yRtn1qQeMdXjkOsrbOQ580tLvpWvV
         Ff0K0pi44nn3COv5YYAKy2PPc6JipKs5whijLP2H3sHiOtaakFvXN3myFEiM45TmggYV
         kKnoqRpVvm26LSgjFPJmJ+av6H/0GUIMXauX5FoHOIScdMfi6C3gib8ioZDM3kLMVLci
         /R3CvTCJSyMrPzoUnqfZPqtSwuJmFNUsB3XR9EWF7C4AXJBA2j95C0tsk7uhdO5vtLoG
         Pwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793930865; x=1794535665;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9tVWOE571yIRel1WCas/DMzsKiN3hCHNnaxbQG3mgi0=;
        b=G+5kLCzT8rvlSEDjVMUt1HdU4MTf5ECuQCGJHGe7WAfOAJ8P7Sj9/QizgMNijIdqos
         9Fx5xq9R1Hxt5hmnLCp7NZGOLvUsRt+vXGR1TL/iJ8mWUuZ+Gy4I1LSkIvl/mMG8og9j
         vj975kVJR/eEK4+BjkNjwgEBjgTh4Ud8eTvyQ3Xq+in9HdwyQU1YV5BdNYTgvCyiEmDR
         YyoyHvG/Jkvo+k5nUt6PJSyv+IExZ6BC5hL4inExx0tKW4BKuF5BQlEpWOneQ4kSrxPW
         gerzGlVuIfV43wmlvulSKUqPEKS1ieRwtrskLDO3hYbgJLXnlrAvsQn5LV06ujuZ7aSt
         WPTQ==
X-Gm-Message-State: APuU4Z8WEwck7WRuF/3f5W7q50Ts0tR1plZgIQWN9j4i92EENIbsYsr1
	5gijWhIBxEVY4wJVpWw5kjABulbIethg+Yl6id3Z3dQsUxDefqwV6kTc5Kbi9w==
X-Gm-Gg: AYBFou2X3CJwul1URewYnk6PatqbECObN6b+KB6PCNEk7HQ7SyNVfdLre9EBSjuTgpy
	tyqCConS8Bnzy1F52aSyv1Ax+CzGmNMh9mk6Htj1PJinpRVS9SHXsn5Ext0h86fuqsbQ4J1z43C
	HKOcUX/NcqIOusdeQKBSebJwu5CeZoYkXV1fD/UC3K/afWg1YNdqcbhw9CGBjPwkMR/c6GBdHY3
	tADLi/lnjU2ebh1B7m37laAhDk2q4GLcj8vcHSRJKaNCC6bjwN9puQ2k6fv0wfGAP9X3xaV6ux5
	qwY0r6itAAQGQQnkApx5A39DoPjw7vWq3fiiwU+aLQ3HkhpT2uuWVOqTQ6F33EU6Jj6Y4RUxr1f
	oGAV3kBDzKxhRUrX/XagCheWtRvCOR9XQT3blHnsh6w0alEsxjvO3ZH+42lUWyxtKoO7IpoXCFi
	OKyE6HepPhiYJOdQWrAufE6yKJKUt+etR3olmflgKe5gTh+FcnFS/dF4hwL9c2SFfiKth1GwxM1
	25aYncfUe/NYWN32WHLVnqCfYCpeyr+936FsGaaAuzMvTQswHmotEB+5jxQWrEMNQ/wR57NjyOF
	giJUSiJVP97DGz0g1IrMrI21HiXjgYD5ZktazrevJc1MuKcvKKFvI8s=
X-Received: by 2002:a05:622a:1cce:b0:536:65fc:1e with SMTP id d75a77b69052e-54e1596c2ccmr18352831cf.62.1793930864495;
        Thu, 05 Nov 2026 18:07:44 -0800 (PST)
Received: from smtpclient.apple ([2600:4041:44c7:5c10:3958:f724:43b6:fd8])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e27207259sm8179661cf.27.2026.11.05.18.07.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 18:07:44 -0800 (PST)
From: Christopher Hill <ch6574@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: [BUG] mac80211: ap_isolate is not applied to AP_VLAN interfaces
Message-Id: <20E87267-920A-4FD9-9443-050AE7676E45@gmail.com>
Date: Thu, 5 Nov 2026 21:07:33 -0500
Cc: linux-wireless@vger.kernel.org
To: johannes@sipsolutions.net
X-Mailer: Apple Mail (2.3901.200.71.1.16)

Hi,

When an AP uses AP_VLAN interfaces (hostapd dynamic_vlan, e.g. VLAN
assignment via wpa_psk_file or RADIUS), the ap_isolate setting of the
BSS is not applied to stations bound to an AP_VLAN. mac80211 keeps
forwarding frames between stations of the same AP_VLAN even with
ap_isolate=3D1, so client isolation is silently ineffective for those
stations.

Code (wireless tree as of 2026-11-04, also v6.18 and mainline
7.4-rc1):

1. ieee80211_change_bss() (cfg.c) stores ap_isolate only on the
   sdata the request was issued for, i.e. the AP interface:

   if (params->ap_isolate >=3D 0) {
       if (params->ap_isolate)
           sdata->flags |=3D IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
       else
           sdata->flags &=3D ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
       ieee80211_check_fast_rx_iface(sdata);
   }

2. When an AP_VLAN is opened (ieee80211_do_open(), iface.c), several
   settings are copied from the master AP sdata (control_port_*,
   cab_queue, hw_queue, chandef, tailroom count), but not the
   IEEE80211_SDATA_DONT_BRIDGE_PACKETS flag. There is also no
   propagation to existing VLANs when ap_isolate changes later.

3. The intra-BSS forwarding decisions test the flag on the station=E2=80=99=
s
   own sdata, which is the AP_VLAN sdata for VLAN stations:

   - ieee80211_deliver_skb() (rx.c), sdata =3D rx->sdata:
     if ((sdata->vif.type =3D=3D NL80211_IFTYPE_AP ||
          sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN) &&
         !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) && =E2=80=A6=


   - ieee80211_check_fast_rx() (rx.c), sdata =3D sta->sdata:
     fastrx.internal_forward =3D
         !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) && ...

Interestingly, __ieee80211_check_fast_rx_iface() already iterates
stations whose sdata->bss matches the AP, i.e. it re-evaluates fast-rx
for AP_VLAN stations when ap_isolate changes - but the evaluated flag
lives on the AP_VLAN sdata, which is never updated.

By contrast, multicast_to_unicast is stored in struct ieee80211_if_ap
(sdata->u.ap) and read via sdata->bss in
ieee80211_multicast_to_unicast() (tx.c), so it does apply to AP_VLAN
interfaces.

Observed effect:

Linksys E8450 (MT7622 + MT7915E, mt76), OpenWrt 25.12.6 (mac80211
from backports 6.18.55), hostapd 2025-08-26 (ca266cc2), dynamic_vlan=3D2
with VLANs from wpa_psk_file, ap_isolate=3D1, multicast_to_unicast=3D1.
The AP_VLAN netdevs (wlan1-vlanN) are bridge ports with hairpin on (as
OpenWrt sets up for multicast_to_unicast, expecting ap_isolate to stop
mac80211's own intra-BSS forwarding). Every multicast frame from a
station is delivered twice to the other stations on the same AP_VLAN:
once by mac80211 (not isolated) and once by the bridge (hairpin).
E.g. an IPv6 all-nodes ping from one station gets two replies per
sequence from every other station on the same radio/VLAN, one from
wired hosts. Turning hairpin off on the AP_VLAN bridge port stops the
duplicates immediately, while the stations still answer - i.e. the
remaining copy is forwarded by mac80211 despite ap_isolate=3D1.

The sdata flags in debugfs confirm that the isolation bit
(IEEE80211_SDATA_DONT_BRIDGE_PACKETS, 0x8) is only set on the AP
interfaces, never on the AP_VLANs (ap_isolate=3D1 in hostapd):

 /sys/kernel/debug/ieee80211/<phy>/netdev:<if>/flags
 wlan0        flags=3D0x28 (IN_DRIVER|DONT_BRIDGE_PACKETS)
 wlan0-vlan10 flags=3D0x1  (ALLMULTI)
 wlan0-vlan20 flags=3D0x1
 wlan0-vlan30 flags=3D0x1
 wlan0-vlan40 flags=3D0x1
 wlan1        flags=3D0x28 (IN_DRIVER|DONT_BRIDGE_PACKETS)
 wlan1-vlan10 flags=3D0x1  (ALLMULTI)
 wlan1-vlan20 flags=3D0x1
 wlan1-vlan30 flags=3D0x1
 wlan1-vlan40 flags=3D0x1

Reproduction:

1. hostapd AP with dynamic_vlan=3D1 or 2 and per-station VLAN
   assignment (wpa_psk_file "vlanid=3D10 ..." or RADIUS), ap_isolate=3D1.

2. Check the sdata flags: cat
   /sys/kernel/debug/ieee80211/<phy>/netdev:<ap-if>/flags shows 0x8
   set; the same file for the AP_VLAN netdev does not.

3. Bridge the AP_VLAN netdev (e.g. wlan0-vlan10) with hairpin OFF.

4. Associate two stations A and B that both land on VLAN 10 on the
   same radio.

5. With correct isolation, A and B must not reach each other (no
   bridge hairpin, no mac80211 intra-BSS forwarding).

6. Observed: A pings B (IPv4 unicast): replies received.
   ping -6 ff02::1 from A: B replies (once per sequence).
   Both stations on the same radio and VLAN, hairpin off on the
   AP_VLAN bridge port, ap_isolate=3D1: the traffic can only have been
   forwarded by mac80211.

   Expected: ap_isolate applies to all stations of the BSS, including
   those on AP_VLAN interfaces.

Possible fix (untested sketch, for discussion only): evaluate the
master AP's flag for AP_VLAN sdata in both rx.c places, e.g.

static bool ieee80211_sdata_dont_bridge(struct ieee80211_sub_if_data =
*sdata)
{
    if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN && sdata->bss)
        sdata =3D container_of(sdata->bss,
                     struct ieee80211_sub_if_data, u.ap);
    return sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
}

or move the setting into struct ieee80211_if_ap next to
multicast_to_unicast.

Thanks,
Christopher Hill

(Disclosure, bug investigation was AI assisted)=

Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70A49A3B6
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 23:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792278773; cv=pass; b=ddDJ/rbfzx0EKRDkoqJfiSaB8+Xu+aKobH2Z9NNOOJ4doagra4BfDYMEgnhjq+ETeJXJpKkrILoQBYoh6yyBpXEuFpn4pCvxgYvi5JzHKTfKilyv7GmdDdiu2DVysgaf/74Q6rxh7Ohu6KQKsFnOB2rpgbWQmKcqkbQz5WWBb0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792278773; c=relaxed/simple;
	bh=Lcn+Qs0uiwtnlOCcugPxjXr2GSZhyyUpSDrObLaCOjo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=V4jSJKyOElTbhOn3DkgIcHN44kq5JvPuKs9Tx2CEQdNwHSh/YrdM5Wu2rEXesMgGcW7mEBPvu1AvJnhtXUrNLgPWaLCBF/PPQ+EVJj78AKsh23ajGB8ZPSJvT4a7oIdjAc6zuhJ27ZwDONxDvecLhC7j/OhlJD0k/Mg6f8Xy2KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jqv38der; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jqv38der"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be469d4f9fso849293e87.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 16:12:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792278770; cv=none;
        d=google.com; s=arc-20260327;
        b=eXXn5Yqd4Rwcp01kh40fI4yMaEcHRXavXNu+yUB+KqIPaXaeqnKYzkLxdKJKIBE+Af
         7Is9BWwBv0aYTNYKC42OTF8xJ7xCVO5CMQv9aXFwNduH573N0SB5D+wR+ReDDCXL/91F
         S7TQ8a+Mm7Yn6x6jADg1U9nauIn75agvYuOXUCEBZVwOkt51kw994wRhqkVEWS/lFbmb
         QdvTJbkT5W+8fVgO8TaGJqLHF7PZDekKB8RmTJhmXtCNvKGIdBd3K5Nhhrh7Vn+GtqZy
         df54PxzEKp/jA4ZpOMn9J3nmAa39RblTjDIxM/JlaGYeKBRAdv7zeGidH7aBWf953r/D
         h5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=cLA4jswBq21u3uDgRDpKl04UzBdoBSJ1Zn64aYp/wdo=;
        fh=3jedLMbe8S87f+9ipamBXFqbX+vHjN20ADb/zc9JI+U=;
        b=p4B1oayOe6oh+7gKXYEBmMwM3IlAOI1R3cQtM9RBRdPhdVBSPR/y2KYQ7hJdf5sdck
         UCMd2Tyl45SCj0WjbTAzbERJfPGiKSVIiTRlYya7fpG6yHf+MB+IOaSTxs/C8CNxyf4o
         uRXVqf45KoljHqpbLZNswKQ64vYqMjTUdKY1ROXAx3Sp/R5HElxmdYZKwuu8k1+eG11C
         vRGCFGuh3+lPG9XPYE0cRNm9XX+kxXOqF2mTrrUKD2YHlyD4G4msK0/gdl14KE+UISZh
         /0Nc/kGe5HHaRVPTpj3szV5o9BmFjup57t7S5VmYsM5cY5Gv34xh0/WN6QGN1K8740cm
         Sl3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792278770; x=1792883570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cLA4jswBq21u3uDgRDpKl04UzBdoBSJ1Zn64aYp/wdo=;
        b=Jqv38dermv21WlGlK9zYV37RxAkBqRhuNWTuAjktFcOk3aeNoqpjx22N8LxV3+PVtf
         G2GtNkbtvu5f5g6HeulZHr17aGm6C08ghMkdsWvcDi+E9dppURqpuc5l5kew4Qf1sojG
         6nlfspcGZqORjIjzbrBBp77Oz0DLYd0vQPEEmtRpvO1xd8VLIqvmGSAlOuPMTJHna/0r
         IugUM6e/gbQljZC+tSw+AjKwZayyeIC6Iqd43v90uHrZRU39Y541N70j9TMcOMSk+kf6
         ppkBvaLJ1XtD6ahiDMIT/L2j1M1ZIcf/5SPS93ikmJ3IWoaI86eU32el98EcbzCcSi1Y
         WUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792278770; x=1792883570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cLA4jswBq21u3uDgRDpKl04UzBdoBSJ1Zn64aYp/wdo=;
        b=s7jcYuYQMf1yNwmxroWYL7V0rDWY8Dg55scl0Io9sJ6MSyDti5ERzJotZOex/HFxzc
         LxhZ4iW53rPyx2USYY0Yi6dwcWHaTx/wNAWoyW7qDCVqKVPPC3TuzjkskSrplK0B4rcx
         o7PqadyKOFclWN5vsiOasTsUPASQBbTC6AyjAMwPxUeL+jwViyvl2nV6ficNCf6Q/jdc
         c2olIN91DYQAqy2PcJwXfsXDSNliQ9osjR5QLwZ/zEtfFzu9nfTylqFpqu37zXZ8da5L
         8HAXU6uFBIYYqtLKGpqjDgqUzPDQhS2+PscPeoHn3QccB4WGPT3B4+Z8Nz4MXDOny4he
         y5ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwO6uqpDomYhF3SJs1ce1juhRGzefhhGKjax3an9POAoEmD0+w7jEKI5o6o5EH4epXJ5Y0bf/Cf0CJ1LEl5Qg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKZ2AE4MrU4l/67/tnkQJFwAsT1rff0TMZvdqaOuC1lP4iQ2VhJ
	ugtYvisTS+IAlsfJI2kLvlYS8aQA3oO1PoPkoH9V5ERlqgRjaUYSZqvz0QWAPjhj5ZRbf2DG/D8
	kF3fLx8EqU2BkGHIM70BamhNYUmtyWRBUggvc
X-Gm-Gg: AYBFou2gc3BShIYhhKqxAxayywA78miGIpBjJ9ftaifnTf4zPPMEa60CQThu36nwJTz
	4tZ7C6njErcT2j603E6+0NlWnKeOyTGfowVUdlGroJDfrhVZqGbKSyr319+sHVfstUOweTVLTTg
	U0JCx4gSkJrwvgqnh+PnA1kvpfzW+u6jfyZsK4b+oerl8FBtIAlRcFTNGNeHJCQ7k7BKnwC1nbh
	6O2/HEGSdAb81uWikm8onGcsDRrnnBbeWCreCppaj7O6fzeInW/+pbvf0Db9iaaOffvI93fPqBa
	z0DhX67PuEYLkueACRxPbCtMT2LTDCfwXOaG3c9g4M3iIEo4wpkLATV3TQufRoBQU7JslLljKkv
	vwo9IYhsQtZxlZg==
X-Received: by 2002:a05:6512:b8c:b0:5bc:dd4f:c3b with SMTP id
 2adb3069b0e04-5be50a72c99mr992481e87.33.1792278769657; Sat, 17 Oct 2026
 16:12:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Sun, 18 Oct 2026 01:12:38 +0200
X-Gm-Features: AclHuK9-AjNmYzX1iG8JbGL6r55wNosQzwWegrmilVkKGZR91-wQYqsz3EtKGG4
Message-ID: <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
Subject: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Berg <benjamin.berg@intel.com>, linux-wireless@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Since 7.2, mac80211_hwsim radios in AP mode stop sending beacons
after the host has been suspended once. A single beacon goes out
roughly every <time spent in suspend> instead of every beacon
interval, so stations see massive beacon loss, scans come back empty
and APs without associated stations become invisible.

Environment: Fedora 44, kernel 7.2.11-200.fc44.x86_64, hostapd 2.10
(Alpine), radios created with "modprobe mac80211_hwsim radios=3DN",
wmediumd in use. I have not tested a vanilla build, but the code
below is identical in current mainline and wireless.git.

Symptoms (station side, after one ~5 min suspend of the host):

  $ iw dev wlan0 station dump
          beacon loss:    480
          beacon rx:      1

The station stays associated (unicast data still flows, the timer is
only used for beacons), but a second AP on another channel is never
found by scans, so roaming cannot happen. Nothing is logged in dmesg.

At that point CLOCK_BOOTTIME - CLOCK_MONOTONIC was ~302 s on the host.
After a reboot (gap =3D 0) everything works again, including roaming,
until the next suspend.

Analysis:

The beacon hrtimer is still set up on CLOCK_MONOTONIC:

  hrtimer_setup(&data->link_data[i].beacon_timer, mac80211_hwsim_beacon,
                CLOCK_MONOTONIC, HRTIMER_MODE_ABS_SOFT);

but since commit 933f5bec98a1 ("wifi: mac80211_hwsim: register beacon
timer by calculating TBTT") the callback re-arms it with an absolute
expiry derived from the TSF:

  hrtimer_set_expires(&link_data->beacon_timer,
                      mac80211_hwsim_tsf_to_boottime(data, tbtt));

and the simulated TSF is based on boottime since 1926f4e06dce ("wifi:
mac80211_hwsim: rename and switch simulation time to boottime"). So an
absolute boottime value is used as a CLOCK_MONOTONIC expiry. Once the
system has been suspended, boottime is ahead of monotonic by the total
suspend time, and every re-armed beacon lands that far in the future.
The first beacon after enabling still works because it is started
with HRTIMER_MODE_REL_SOFT.

Before 933f5bec98a1 the callback used hrtimer_forward_now(), which is
clock-agnostic, so 6.12 and 6.18 are not affected.

Possible fix (untested): set the timer up on CLOCK_BOOTTIME, like the
NAN timers in the same driver already are:

  -      CLOCK_MONOTONIC, HRTIMER_MODE_ABS_SOFT);
  +      CLOCK_BOOTTIME, HRTIMER_MODE_ABS_SOFT);

(in mac80211_hwsim_new_radio(), for link_data[i].beacon_timer)

Reproducer (wmediumd not required as far as I can tell, the timer
path does not depend on it):

  1. modprobe mac80211_hwsim radios=3D2
  2. start hostapd (any open or WPA2 config) on the first radio,
     scan from the second one: the AP is found
  3. suspend the host for a while, e.g. "rtcwake -m mem -s 60"
  4. scan again from the second radio: the AP is no longer found;
     "iw dev <sta> station dump" on an associated station shows
     beacon loss increasing

#regzbot introduced: 933f5bec98a1

I found this while building a containerlab-based Wi-Fi lab (hwsim
radios moved into container netns, wmediumd on the host).

Full disclosure: I am not a kernel developer and not very technical.
The symptoms above are real and were observed on my machine, but the
debugging, the code analysis and this email were done with the help of
an AI assistant (Claude). The analysis may therefore contain mistakes.
I am happy to test a patch or run any commands you send me.

Thanks,
Lo=C3=AFc Kassel

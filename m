Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C93537F738
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791644716; cv=pass; b=luVATFKWVEazO1XbVvbB7MzRCEE/EK68YOKKnkBXNlwKGI21VpoxCeDOD03YoVqJdOQkk+U4XxpUjX7uj7Q7AHqf9eeBCbUgDuyRnqnhZ98uatzmIUFK9xSxyP8SBSob3BCF8mkILSiKb0bDDzyeiAraqhOnWamRk180JLoFtfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791644716; c=relaxed/simple;
	bh=11jlVCLHFqnNR6Dp/bNjVQNcIjrLj+Y6/rpoOHLB/ns=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NxemsbeKDLBi/96iy+z9mTNMBVoxiI5EO597DZgNcCJxrpCjhpgzt5Rmc+647/1RzA61KzfDyxCW3oXox3rABrZTyCwGNQDnjmfp6ZlgcBnGzYz6SpglHenPgUt5DVr9NOb6Fvp7hhLQ3mqu5jLg98Yp1+7rbsk0pr7Blw2lMZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWGBZiCg; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWGBZiCg"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a772ec8389so5509821fa.3
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 08:05:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791644713; cv=none;
        d=google.com; s=arc-20260327;
        b=cDu5vEoJuglna9lU73hqAZzp++roiI0SfByQLTNqTMKA3ntBcT/Pk+rDcYFdrwnjNk
         fT6ag7P+/2THK8cKslbVByKuPuOSxqHhTZoHMgNfbSWpAHW/zatAI/2Qb8xx4ZNZ2Oda
         xFqyU5R/ScZ6GWzWxG+GDtAMgzAX/QMcNVB803PQ1hT+qUoUOPvAS/gb76ilD1Ao68g4
         Db0uNANA4t8AWPpd2nc/P2UDU+9FZII8lmyDh+DMM4KZHn8Udwd/tssekvwRCQ8389BK
         MxgEL7ZapbuNEX4VMPwgkkzdI/dZ/RwSp25zdv6eKEFrZ+XSw8epVXqOrI34dYtUnGvb
         HeGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=KfH9tsGK37spKp5ytoeFcdf/Xc7jhbYKmz2ALtASldI=;
        fh=mRlY/7aqHeH3yRGYvkuG3bnzztR5XOOJ3JXWh9DmbDI=;
        b=ne5Guk3Z39W45KsR7pJ6k8a45El37fWsn1XPpMMi8xl7Dx1M4lbh5VMXzpEkHBh8pA
         WsPMq0wDrPLOwZtbeuNA5OG9nXbyeF2LniPn7BoXcEkuXx4xG8nuCQi0rtgK9ZXLlgsw
         83tjK6uRf2eSTAA/xEpuc4uJh8tXAvLk+Ss4mYC1pmNCPz+4UM5GNi8IK9fC3jjHTMqs
         f46zHV86gMueiTHuEOQyLDm9c9U2RxijYAsePl3Z6g1zxzILbAtN6+zd9FSdW3WMILbW
         dXSyDn9YCF/p1eObB/nKVfx0ZkqaAZlDjODhOTlo+43CnoUJPJ+CCgTuxvx05iAhMoDR
         17wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791644713; x=1792249513; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KfH9tsGK37spKp5ytoeFcdf/Xc7jhbYKmz2ALtASldI=;
        b=YWGBZiCg1bSu73nVFHn9aPs2RkOsSAhgm3LPH+RS91NeLWS8VQ/xSwTYT1Lo9TK9z3
         UYCrtELpzvMrUAGhbnkQ7Ba+H7tPijTlilAmwIQ2YxE6SSslXejgjIz2RvMjU17vpzTJ
         kpZMLjf2bI69tJjb/Omw5SlB1tQOiYXDiw87FFnO0tcYOCQTeR8qjI92h3bLhXD2B0t1
         P8SRHY6HS5/Zciln2xY06bJFvRQV/X7mKgJU8YlywDWi6K0q+eN6NfLhSF/bqxegl30W
         dNZKPGtJchdiBwLJ2ZKOkw8KNQKp3cR5Ed4qmAStpWaZAgKfC1a2aK0/hdvei3Fdn62I
         0S4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791644713; x=1792249513;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KfH9tsGK37spKp5ytoeFcdf/Xc7jhbYKmz2ALtASldI=;
        b=RO8o2l1b8BLGuHAomqEvzh0QCOt+8PscD9lwE2B1TD3qXqr9QlZKq0bgIOtN62X7wh
         xJ3I4c7q9Dl1NINY5j6ys/V6f9Kf3z7wAcM5KEbORUfeirLG96pZtzNDC8FjihPOwAji
         JPxJ1YVswFIVNrfimriudXwDyFW1eq+3hpFRB7VexLpGHXfT+tREsJT/Ou48b4Nc+OZx
         Llix06HjD/rRrCkxsMAdi0rCOahvYYpHeO5gcxYw4j4BOQ6VTKbGmjJoxHNhcQoXVCoz
         RL42YrABYmqS21SnBCkRVwsRgday7g+wjgCFvhOc5n0MUkHgJinx4TdHOBSFd8Tmu0eY
         GeOA==
X-Gm-Message-State: AFq9FYIh+fbrmxWNknyn/MN924RGP/0VkzyqnJi3D1cfhNZ9F2om/hf/
	wR7cTwufGS7dWIk83AIMvaIKHrBkqvp06NWxk71iqdiFrKpKNASFKyzwzRpnhiQ6ZaTWcXrOVmO
	I06WOh82jRTCzeo6eKdcg/pq5ogHIuXVMjowX
X-Gm-Gg: AYBFou0lTDReksnv3s09CPLPv2fRCz4azADUPnEmaVegvmJ2WtQ7olHbwNA1/FUfBsn
	1P4X7Y907tRZfpelkQzF2CMbeF+iZM9nLgAGEPPIKoFRUicCyiDzqWRqf8b1rYvBFGJSJ0rR9uK
	R6YrDcLvKulUXg77TEO7FUHDhEBvejQaUeL8rdBwfM5OJnOg8B8gKp7ybzlg4JnQVxJwqJVCleh
	gBkQn6wZ8itqIVjbH3G3HiS0d2ivsiKsCy10oyty5JnQENwFwzAELWOZM/Bf1mipqeNqRc2M0J8
	R/kaW31u+YO+vl4LiF4ux4vcTkVIYUQtUatlZ+VD7KUzlQClQkQiYsbcpJz8EK+j2vjCvReHi7r
	pz7/taxOq3rJw70tkA7rskzLM8s27yivavU0vQzvV6h7ZJ/xSH88ddDpbImpIwngUTiNFz5pXiv
	ucT7IgWCE=
X-Received: by 2002:a2e:bc23:0:b0:3a3:3170:5420 with SMTP id
 38308e7fff4ca-3a9c4eb683cmr11429611fa.3.1791644712815; Sat, 10 Oct 2026
 08:05:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Desert Rat <desertratua@gmail.com>
Date: Sat, 10 Oct 2026 17:05:00 +0200
X-Gm-Features: AclHuK-IJuyztRdXxql2cHRRhhnJuUttkjp4JuBBFRLPFcowCa021dw9HfmTotw
Message-ID: <CAOCtixsdv8D8kJr7qdFzd_SOn4U82BsdPZ+uxGCPh7yPYxt9_Q@mail.gmail.com>
Subject: iwlwifi: AX210 fw 89 asserts (0x14FD, PHY_CONTEXT_CMD) on 5 GHz AP
 advertising non-aligned VHT80 block
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, 
	"miriam.rachel.korenblit@intel.com" <miriam.rachel.korenblit@intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

An Intel AX210 cannot authenticate to a MikroTik AP whose VHT Operation
element describes a 5 GHz 80 MHz block that does not follow the 802.11ac
channelization. Each attempt crashes the firmware in PHY_CONTEXT_CMD and
the device is re-probed. The same laptop running Windows connects to this
AP without problems. Once the AP was set to a standard 80 MHz block, Linux
connected immediately at VHT80.

Setup
- Intel Wi-Fi 6E AX210 160MHz [8086:2725, subsys 8086:0024], iwlmvm
- firmware 89.123cf747.0 (iwlwifi-ty-a0-gf-a0-89.ucode, linux-firmware
  20260319, the newest available for this device)
- Ubuntu kernel 7.0.0-34-generic (the taint flags in the trace come from
  the out-of-tree NVIDIA module)
- wpa_supplicant 2.11, NetworkManager 1.54.3
- self-managed regdomain, country ES

AP (MikroTik hAP ac^2, RBD52G, RouterOS legacy wireless), as seen by
"iw scan":
  freq: 5640.0
  HT operation: primary channel: 128, secondary channel offset: below
  VHT operation: channel width: 1 (80 MHz)
                 center freq segment 1: 130
                 center freq segment 2: 0
  VHT capabilities: Supported Channel Width: neither 160 nor 80+80

The VHT80 center is therefore channel 130, i.e. 5610-5690 MHz (channels
124-136), and not one of the valid 80 MHz centers (42/58/106/122/138/155).
RouterOS allows this through extension settings such as
"20/40/80mhz-eCee".

What happens
cfg80211_valid_center_freq() only checks alignment strictly on 6 GHz:
  /* We only do strict verification on 6 GHz */
  if (center < 5955 || center > 7115)
          return true;
and cfg80211_chandef_valid() accepts center_freq1 = control +/- 10 for
NL80211_CHAN_WIDTH_80 (fall-through to the 40 MHz case). The chandef
5640/80/center 5650 is accepted, and the firmware asserts when the channel
context is changed to it during authentication:

 iwlwifi 0000:04:00.0: Microcode SW error detected. Restarting 0x0.
 iwlwifi 0000:04:00.0: Loaded firmware version: 89.123cf747.0
ty-a0-gf-a0-89.ucode
 iwlwifi 0000:04:00.0: 0x00000071 | NMI_INTERRUPT_UMAC_FATAL
 iwlwifi 0000:04:00.0: 0x00016AD2 | data1
 iwlwifi 0000:04:00.0: 0x00000010 | data2
 iwlwifi 0000:04:00.0: 0x807DFF00 | hcmd
 iwlwifi 0000:04:00.0: 0x00C40103 | last cmd Id
 iwlwifi 0000:04:00.0: 0x200014FD | ADVANCED_SYSASSERT
 iwlwifi 0000:04:00.0: 0x80483AE2 | umac branchlink2
 iwlwifi 0000:04:00.0: 0xC00814E0 | umac interruptlink1
 iwlwifi 0000:04:00.0: 0x00000082 | umac data1
 iwlwifi 0000:04:00.0: 0x00CC0108 | last host cmd
 iwlwifi 0000:04:00.0: UMAC CURRENT PC: 0x804a5ab0
 iwlwifi 0000:04:00.0: LMAC1 CURRENT PC: 0xd0
 iwlwifi 0000:04:00.0: FW error in SYNC CMD PHY_CONTEXT_CMD
  iwl_trans_pcie_send_hcmd_sync+0x38c/0x3a0 [iwlwifi]
  iwl_mvm_send_cmd_pdu+0x53/0xa0 [iwlmvm]
  iwl_mvm_phy_ctxt_apply+0x3a2/0x420 [iwlmvm]
  iwl_mvm_phy_ctxt_changed+0xa2/0x150 [iwlmvm]
  iwl_mvm_change_chanctx+0x124/0x1b0 [iwlmvm]
  drv_change_chanctx+0x59/0x150 [mac80211]
  _ieee80211_recalc_chanctx_min_def+0x40/0x70 [mac80211]
  ieee80211_assign_link_chanctx+0x92/0x3a0 [mac80211]
  _ieee80211_link_use_channel+0x2f0/0x360 [mac80211]
  ieee80211_prep_channel+0x393/0x4b0 [mac80211]
  ieee80211_prep_connection+0x38d/0x5f0 [mac80211]
  ieee80211_mgd_auth+0x2da/0x6e0 [mac80211]
  cfg80211_mlme_auth+0xbd/0x240 [cfg80211]
  nl80211_authenticate+0x3c2/0x420 [cfg80211]
 iwlwifi 0000:04:00.0: PHY ctxt cmd error. ret=-5
 iwlwifi 0000:04:00.0: Failed to send LINK_CONFIG_CMD (action:2): -5
 iwlwifi 0000:04:00.0: Device error - reprobe!

wpa_supplicant only sees "SME: Authentication request to the driver
failed". It happened on 2 out of 2 attempts. With the AP moved to a
standard block (5180 MHz, 20/40/80mhz-Ceee, center 5210) the same client
associates at VHT80 2x2 with no firmware errors. Other 5 GHz APs on
standard blocks also work. Because the crash happens at auth time,
per-network wpa_supplicant options like disable_vht don't help (they only
affect the association request). The only client-side workaround I found
is iwlwifi disable_11ac=1, which applies to all networks.

Suggestion
The firmware should not assert on this. Still, it seems reasonable for
mac80211 (or cfg80211) to treat a 5 GHz VHT/HE operation whose 80/160 MHz
center doesn't match the standard channelization as invalid, and fall back
to HT40 (here 124+128, which is a valid pair) instead of passing a
non-standard chandef to drivers. Windows apparently already does something
like this.

I have put the AP back on a standard configuration for now, but I can
switch it back to the broken layout to test patches or collect more data
(e.g. a firmware dump) if that would help.

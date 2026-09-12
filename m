Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3937B3F2
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198148; cv=none; b=GsYftdhq1epkQD++jU2cnhzsJv3Ze/V66akpTffzn2QjViVJIWTc52KpfjNuMuhqA+r2umo2ql4twD4tOOsDJt9rY36cwrhm8bum32i9JJDqo092UDxxa1Hg6lxjO9PeICeFlpXPS5tN7hCI2c7+I4KnSbMit7eEcgrmdUGcUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198148; c=relaxed/simple;
	bh=dhpBYpFhJDs9xOYSwPliRDQuXyKGEUdRkSMpWqBtp9k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iXNW4FfyUh6K3AeP+yGx3tRHbwa4Xwiyp4CYFqEq6Xu4RejcZhxkSs/TVZYM70pTSKhBP27zFz+RGrLQsfrOUAZUMXWOlOk1Pweor2Fqh66UAYbDG5ekB/0J4G7YRhZ1ySjPWLMIDKXFiR5kxay3n3PktAtG9RImZ+6fMqz9eQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiCZVzuy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiCZVzuy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso5080215e9.3
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 00:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789198145; x=1789802945; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qthRk4n3iEIfUHnnP0shWi37odfpZtGT+hDRI85+BXo=;
        b=aiCZVzuyIoqS11fm2pXvg0NLUqkxTzGZjfwmoqSXKl7ZeswFZ2jur6AOTyd39JoV2A
         +lpWmlBHvUICqIGoDScOqD9CfudlPWp2Y70DplXrC5pwTY5FSy91TPWTjjqYOiAoLvZM
         e5Zl5Jzoj9bOGBQYyd0cmcvO9yuL3iCcSFuhuSQCJIzrPceTKmQ/3PApf6zYXcxAt4N6
         h1PD1YI09pLp+kmBTB3C1fwcQLII24AQ2K2kUwC75segu0b98lbXN7Z+zc2gSjHXRdyM
         8QiuxZjOYw2W0616A7E2fsqqGnw2lFD77RTZEAg0mgsynYU/WgKsWUvWEPdQTpGZWaVk
         IstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789198145; x=1789802945;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qthRk4n3iEIfUHnnP0shWi37odfpZtGT+hDRI85+BXo=;
        b=TDIuggjHp7im0/LhAdOaLE2IyPK1NP7bVm2f2V6qeKSaFSJ9iNpDd0nvZCv9nZZ6ZG
         fWvoifnnhGm07MU0tdsOfNq8HI4w1P38avOdgCrOB5EwEiZv5UjnRP9lTTmOtvUCwaUV
         AXrAVGM2p4QQB/CmsqeBy5wShIXlieeoit3BTe7GwdejCYgAez+Sp0zK6e2+/bgLXgPJ
         SwBL/L9n4NdBSsv3TQC99XxTAGO5QKV09N1BTZxHfvvod+EDQRjQZQQZly8nR/FRVGSN
         jLrTC4D0igtRFnc8dRXFfZOU0NP5TSjh3gcIZCYyFwE3+kYs1L3MnDJngseHh/Nyd0Z/
         abMg==
X-Forwarded-Encrypted: i=1; AKwUvBxEsE9H/4GoDJ48yo7XontCDa0w3thRNlIEW6wjNlARxsXkB71blsNcXXhKe00ANLs7LLyQvjbjymTaDvRYMw==@vger.kernel.org
X-Gm-Message-State: AFuF++nUXAdHwFQdsvUJKaQirNeVT8exnR7otLtBiZidkh58GIDBtcC7
	cxcPiU+WFLVNwEZR31+j5aWKU+5FIbxgGBzxXljtUnc4ZAKJDPsmb6Dk
X-Gm-Gg: AYBFou2Xaa84uSUxVE90Rgpv9UoPy1mKJ5aW0bnFdKNs75P9Dvhei6rpIli5GV5zkmW
	uxgVMDSLuyLbA3ELBGhx62Mhe1uLr4oBZxfMjLmBtUe0cLnlwNDwakVjNF9DyEvFX9mr3P1xuQg
	TkG+6zexkEKcutnnx5UWvN41cfv4ZghmKioobs+wF2LFS98U/pcYMulLepicbo8jdrqnfA4lSHF
	D6O2sejAPGpfcbzunqwhMGDH7rxy4aOV1aSfZUqo4uNpLC+y/a5H9siIgDX1z0O/qJePf0M/+Y3
	zOto+8K9+R/t2rct/Cy6hNVeOsIbmuQVRw5PPaDis4/uwI1iCohPN4ZW0fbPs8bBYNxk8IBdVv4
	yPNLymxupFqHfUhTnSVQDjuApy+TL3aJqXykBW3mE8UKRvRbkUSY7YyqvLX8FOdzz8WVpXWzWDu
	zDgL2j2pr4+8vwDk74mJRbOW25EhcmCz9n3We+5VCHSMw+r4sYwjvha+JidRTlXLxbL4k=
X-Received: by 2002:a05:600c:c490:b0:49c:f4e1:4c2d with SMTP id 5b1f17b1804b1-49e619c0423mr90508945e9.16.1789198145050;
        Sat, 12 Sep 2026 00:29:05 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm171299395e9.3.2026.09.12.00.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 00:29:04 -0700 (PDT)
Date: Sat, 12 Sep 2026 10:29:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org
Subject: [bug report] wifi: nxp: add nxpwifi driver for IW61x
Message-ID: <aqT_PG-XPtelJ5cR@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jeff Chen,

Commit 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x") from
Jun 5, 2026 (linux-next), leads to the following Smatch static
checker warning:

	drivers/net/wireless/nxp/nxpwifi/uap_cmd.c:1054 nxpwifi_set_11ax_status()
	error: __memcpy() 'ax_cfg.data[4]' too small (50 vs 255)

drivers/net/wireless/nxp/nxpwifi/uap_cmd.c
    1019 int nxpwifi_set_11ax_status(struct nxpwifi_private *priv,
    1020                             struct nxpwifi_uap_bss_param *bss_cfg,
    1021                             struct cfg80211_ap_settings *params)
    1022 {
    1023         struct nxpwifi_11ax_he_cfg ax_cfg;
    1024         u8 band = bss_cfg->band_cfg & BAND_CFG_CHAN_BAND_MASK;
    1025         const struct element *he_cap;
    1026         int ret;
    1027 
    1028         if (band == BAND_2GHZ)
    1029                 ax_cfg.band = BIT(0);
    1030         else if (band == BAND_5GHZ)
    1031                 ax_cfg.band = BIT(1);
    1032         else
    1033                 return -EINVAL;
    1034 
    1035         ret = nxpwifi_send_cmd(priv, HOST_CMD_11AX_CFG,
    1036                                HOST_ACT_GEN_GET, 0, &ax_cfg, true);
    1037         if (ret)
    1038                 return ret;
    1039 
    1040         he_cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
    1041                                         params->beacon.tail,
    1042                                         params->beacon.tail_len);
    1043 
    1044         if (he_cap) {
    1045                 ax_cfg.he_cap_cfg.id = he_cap->id;
    1046                 ax_cfg.he_cap_cfg.len = he_cap->datalen;
    1047                 if (params->twt_responder == 0) {
    1048                         struct nxpwifi_11ax_he_cap_cfg *he_cap_cfg =
    1049                         (struct nxpwifi_11ax_he_cap_cfg *)he_cap;
    1050 
    1051                         he_cap_cfg->cap_elem.mac_cap_info[0] &=
    1052                                 ~HE_MAC_CAP_TWT_RESP_SUPPORT;
    1053                 }
--> 1054                 memcpy(ax_cfg.data + 4,
    1055                        he_cap->data,
    1056                        he_cap->datalen);
                                ^^^^^^^^^^^^^^^
Smatch thinks we need some bounds checking on this.  The comments
on cfg80211_find_ext_elem() suggest this is true.  I've been
starting to use ChatGPT to review Smatch warnings and it says the

	he_cap_cfg->cap_elem.mac_cap_info &= ~HE_MAC_CAP_TWT_RESP_SUPPORT;

assignment on line 1051 is a concern as well since that was
supposed to be const...  But I think const here is more of a guideline
than a hard requirement?

    1057         } else {
    1058                 /* disable */
    1059                 if (ax_cfg.he_cap_cfg.len &&
    1060                     ax_cfg.he_cap_cfg.ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
    1061                         memset(ax_cfg.he_cap_cfg.he_txrx_mcs_support, 0xff,
    1062                                sizeof(ax_cfg.he_cap_cfg.he_txrx_mcs_support));
    1063                 }
    1064         }
    1065 
    1066         return nxpwifi_send_cmd(priv, HOST_CMD_11AX_CFG,
    1067                                 HOST_ACT_GEN_SET, 0, &ax_cfg, true);
    1068 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

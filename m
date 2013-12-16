Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:56706 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3LPBvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 20:51:11 -0500
Received: by mail-vb0-f48.google.com with SMTP id f13so2691646vbg.21
        for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 17:51:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386962034-7141-4-git-send-email-luciano.coelho@intel.com>
References: <1386962034-7141-1-git-send-email-luciano.coelho@intel.com>
	<1386962034-7141-4-git-send-email-luciano.coelho@intel.com>
Date: Mon, 16 Dec 2013 09:51:10 +0800
Message-ID: <CAEFj987JhRnx93qCTusoGB-gmcuLLDXeL76xEw_bz7HUmLFitQ@mail.gmail.com> (sfid-20131216_025116_191828_7AE1F52C)
Subject: Re: [PATCH v10 3/5] mac80211: refactor ieee80211_mesh_process_chanswitch()
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -
> -       rcu_read_unlock();
> +       if (cfg80211_chandef_identical(&params.chandef,
> +                                      &sdata->vif.bss_conf.chandef)) {
> +               ibss_dbg(sdata,
> +                        "received csa with an identical chandef, ignoring\n");

mcsa_dbg here?

-----
Chun-Yeow

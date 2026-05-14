Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC13A7D72
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 07:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743074; cv=none; b=ZYd14ZN2T+02ZnU/BF/PvKJOadByjlJBe+/OqkJPfOAArw0Op+md14Um8C5Szl+4BO8WHWWC3wGT43NYQUIH8R3PmwEoRKYzNtlE7Nb7fpW3wkfjcBBKn7OGYX2AX9yAcjBelHSl4QiSDSUvuLa5S/cNEvhl7Js0vkqZ53kUx8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743074; c=relaxed/simple;
	bh=rrV25ezjFxZMBOw5wRb9fNdhMkJ4YvJm/i5k08tN2ZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnEbHThnYATtw13DOBMISVHGRhFCXMvaagm3gHW1Gkjnusry3kcMLuXGfxSlVWclBXqtcBRC9PZ0xBnQRg/iP6czdtPwSJWzAX4gaDrBn9H5V7D2UrcLVJ2msTF1eXsTR1eOxFN5cqaYH7Ww3DgwC7NOiuZfuWpDnQPGfeByybo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=AG4ShBAb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="AG4ShBAb"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bd2c147abaso11949295ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 00:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1778743072; x=1779347872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/NHQKG10ujJp+9ENCNtK2S918BRtVtcAFmZUtbZ97Jc=;
        b=AG4ShBAbIje/LJvxIrMVqAWu9+QhsIXy2ek8T2fKtOkRNwOfLWZwG2oqM+xP6y+wiC
         pez9eTd/TvXTh704zDew1bOKRKFEGiHjZtJNxQFZcZFvyuIzEnqObQc73WQb7rrU3F3j
         F07qIBchYpLMNf+HgjibV0YwP9gMyupYvIVPO5Ry3C98D9VMKUwpqMCsClP81gWfnfpv
         bmV1IlPrBmVkkMkfJRHnVE8AdMHhLUTGkZdKGs4BPmWiRr/68WEyql3rgeGh40DAni/w
         j3WfaKoYcx5LnYdX3yvKFmdD+VaMJ036n+bHgSkGOTrGvoC5YAw//N61rLylTCReByEo
         UWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778743072; x=1779347872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NHQKG10ujJp+9ENCNtK2S918BRtVtcAFmZUtbZ97Jc=;
        b=j8ITb5m4VOdq+Pw6IGAsKNBVXU68Wie/zwnGsmh7a1QVZwctgMdUkUzNWjDcn01gI2
         58fwIwMQPhv4dn2+fzsE0887vG5W6zvPxQOnVIlUWCrtl2bS6DYD1CZwOAAMnzFhuSAH
         iePJF4gCSMTd7kAGr+HH4+xZUfXYv/1UF2bAgsZfgoa1u4PydunBGKhp46vyEipB7ped
         82M8lbhFC1GrdSQg4fDGPPJ3N83C1YOioaAB0xT48YebIjAP9vMRpSvZGPzvhQCwaRpm
         b5Bv24qkJPpGC1Y+96l6CSUjWW4yeRczXu+pk/ytD28nJFwZlfXiga4Mx4578tDSMTf+
         Q8mw==
X-Gm-Message-State: AOJu0Yw6A1yMm5bl4Jjk7vjYv3PWP8qzpu+gm0W2MMwwy/q0/y2p6yZ4
	QjrQsbmru24CVETgLn1Q2li4+xdmR0T+S5SXEq12C/i8s9V1fKbCz7tDKzIo/IkTbX0=
X-Gm-Gg: Acq92OH5RDbCPG37ieU4EnEJHD5PzVdqPevjb4FPP56Ot96h+qkRjG6r5UQtOwp+kzo
	s7EwZK2gfE1aSiETkxGZsugDhf98omZ9wH4lNH5IJk7sThztc1Q/8ByTwrJyv0gNSTsTivqdNy0
	WkMnVY6jpoNg7Grry05A/YGBflMi62XIR7ITw3BTGjZIk6/PqQmFAel/DhV3jsBA5fGQZpVBUAX
	2oVoEHxFnba2tC2AcLykNnlOFlNy1sFtkJSlhguC+JbANxniTCwftIzMWdj17oU7LsIBjzCLffH
	Ua2Y/wg+KTEWIGwZvW6I3hPjGGrAsq/ld9vipQ1Vj/M6GY+q+XgJuwo+xawpP4JmLGs/p2qLuEC
	BrtgqsfQNci1VgDZgp1O9dQdeNObCMt6OvWuTsHpXE+PnK5voMFvV0/JfUtLKF1AjRATjUoN8p8
	5qU/8wbWhc8zsQ5WDZDR5w4RJdqLjfrN7OM2cAcqe5LlCesUILN2ZRt6p0ORx3zztNTeLCpNgMc
	BC4YdnsIJe3+KD9Ob8dPV4=
X-Received: by 2002:a17:902:7c0e:b0:2bd:3bfd:22c3 with SMTP id d9443c01a7336-2bd3bfd3328mr35179215ad.24.1778743072107;
        Thu, 14 May 2026 00:17:52 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5cfe6b8fsm14908475ad.46.2026.05.14.00.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 00:17:51 -0700 (PDT)
Date: Thu, 14 May 2026 17:17:49 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211_hwsim: dont perform
 rate validation for S1G
Message-ID: <27dk2lej2j7tw7iulx6l2kb6ctr4mh5mvsidlnc5e3i4br3s2l@hep6dkloxcy4>
References: <20251008014006.219605-1-lachlan.hodges@morsemicro.com>
 <0f82718459bc6e31238f1189f8f5bfc859b59a3e.camel@sipsolutions.net>
 <e3fl4s2at6oz5rtvurivxormmndj22l3h2dkqovhnhj5u6fw2q@c65nw3shnxcl>
 <ccef9238eaced219bf7526a30e8ee0acb54ea282.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccef9238eaced219bf7526a30e8ee0acb54ea282.camel@sipsolutions.net>

Hi Johannes,

I am revisiting this thread again with some fresh eyes;

> > It seems that introducing a flags parameter into the ieee80211_link_sta where
> > drivers can apply the inverse i.e LINK_STA_NO_RATE_CONTROL or something similar
> > that before drv_link_sta_rc_update() is called the flag can be tested, something
> > like, for example within rate_control_rate_update():
> > 
> > [...]
> > 	if (sta->uploaded && !(link_sta->pub->flags & LINK_STA_NO_RC))
> > 		drv_link_sta_rc_update(local, sta->sdata, link_sta->pub,
> > 				       changed);
> > [...]
> > 
> > Then w.r.t setting the flag, we could introduce a new function that gets
> > called within mac80211_hwsim_sta_add() called mac80211_hwsim_link_sta_set_flags()
> > or something where it could enumerate the links of the ieee80211_sta and
> > apply the flag to the link with an S1G band channel context?
> > 
> > The reason for it being driver-facing is that any future upstream S1G drivers
> > may make use of the .sta_rc_update() callback.
> 
> But the .sta_rc_update() call is desired/needed either way (if
> implemented) - the issue is about the _other_ side of this, "if (ref &&
> ref->ops->rate_update)", no?

The actual call into .sta_rc_update() isn't the issue here from mac80211,
but rather the call from mac80211_hwsim_sta_add(). Just for a refresher
on this main idea of this thread - is that during the hwsim tests that
I've made for hostapd the WARN is hit in mac80211_hwsim_sta_rc_update()
since there is no understanding of S1G widths.

But actually looking at this again, even during normal S1G operation
at the current point .sta_rc_update() is never called since there's no
channel switching support and only identical chanctxs are allowed.
In the future you are right we would like this to be supported, but
that is a fair chunk of work down the road ^.^.

Anyways a potentially nicer solution is to only call sta_rc_update()
for non-S1G chanctxs. Something like this:

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 3a0c4366dfdb..a0e81282d42a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -2788,9 +2788,21 @@ static int mac80211_hwsim_sta_add(struct ieee80211_hw *hw,
                                  struct ieee80211_sta *sta)
 {
        struct hwsim_sta_priv *sp = (void *)sta->drv_priv;
+       struct ieee80211_chanctx_conf *conf;

        hwsim_check_magic(vif);
        hwsim_set_sta_magic(sta);
+
+       /*
+        * Don't perform the RC update for S1G chandefs. Since S1G cannot
+        * exist during MLO operation we can take the vif->bss_conf chandef.
+        */
+       scoped_guard(rcu) {
+               conf = rcu_dereference(vif->bss_conf.chanctx_conf);
+               if (conf && cfg80211_chandef_is_s1g(&conf->def))
+                       return 0;
+       }
+
        mac80211_hwsim_sta_rc_update(hw, vif, &sta->deflink, 0);

        if (sta->valid_links) {

I do agree that this is still somewhat hacky, but I think it's a bit
clearer now maybe? I'm not sure. This sort of allows us to get some
basic hwsim infra up and running without introducing a new flag for
S1G rate control and such. I've run the hwsim tests and it seems to
not break any of the MLO tests but I am not an expert there so yea.

Let me know your thoughts, can always explore some other options.

lachlan

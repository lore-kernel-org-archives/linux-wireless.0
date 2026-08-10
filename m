Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98E436BFB
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386613; cv=none; b=pQfM151XRyrywxlxHO6sxIHEldNEFuqEPfMndrBsdmvL2vh9MHb3SWbvJ3FnWgP8GelrEq2ofDR+rSHFocdNAmg2pqRL/KQM9eceLTBaKBvdmhZFBNu90kv0EX3NCrpMqtrFR0DkSWJm0zcTgDiH3hmfnpiaKjC0nBwln+b3Lh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386613; c=relaxed/simple;
	bh=4CaHWiIprzpnJxK29/NUSlS9mmzQLzQBiOk8ENpXpUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gD8cWg3HtgpiSJ3PkZWNA7a4CDTur0WRjjRvbFx6EWd+Fvnv2h+YF4GL70AK0pTEwWAaK5rBtoWvIebICwddk5+sk/T4QLpoKSIx6VeQVGnnsLndbuddB0rjhChQLG4sZDsMbepQAWE2qlCOwL9CjonflJnU8otOUboUFF08iyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=AvHKGgFP; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AvHKGgFP"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-caf45fc5202so1850014a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 11:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786386611; x=1786991411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cixrKiaGYKoE51uWaNmYqYzgYbXZIR4e3E/JR6pSpcI=;
        b=AvHKGgFPYnVwEQ7e2dfUZyQ9vxRQ1X5NJpVT2yVPzoYjxVkcO1cA0HoEDHst1LUWFo
         nBpOXrJEKK/ExGO2ujl0uU6Obp423MeIUkEp93kG30vA86mOfpATn/OvZgZR/TD6WT2t
         il5WfB/y1U9ZV2x0PY3ghASuwypTCNbbSNjvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786386611; x=1786991411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cixrKiaGYKoE51uWaNmYqYzgYbXZIR4e3E/JR6pSpcI=;
        b=ccm+2nBDXt6GcMxaA3QXwfGn9M1Gh0cK1OgscNOXZ0x3QnQakOt7FKSP2QipGeCPA0
         h+e54UAILyWXNWH7ZIQgsdhuNC2D2JEc6XuyXpq5udpqSQDeJ8Jxkf168SmCYeGbGbih
         PYJQF/ngGZvgQgDm1Mcw3JswOENG4yHAiE9OFakQwLlJNMEnLSxh7RNwjaJiAsCjVCjr
         hJHEMyBDsR9aeo5qAHbAE12i8fwEYdY21ekVWNSiFVTux0v47ImFw1wMLs/MdtL9F8PR
         4UPNO+ArP97PnPmrIEcPUAVOgeAY0ZTn/TPpXmORXiY+x6dGSs+D5WqQfLrwYGap5TDS
         CecA==
X-Forwarded-Encrypted: i=1; AHgh+Rory0rXtX3sePI8RheFgiLGA95BLUFk3ypWmwMwtpRHIjxVTTkVAGqKnKO6kdOmP23UGP0pUddtklNoYL585Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRKb1XcgvUkiqH87KGy1lkabfMW+Uozu+hM8740+qD5sBoD5U2
	wWFT0aMRsQ0V1H8xvhatRS/9F1HDTvYLiuloGWRHozqFUx8qTXwo9PYY8HxgOpL4XA==
X-Gm-Gg: AR+sD11Mg1TMRMY1O20JVU+lc5fakWarrRD1esSGa3XBG7ih4tBG5e0gWQcD/hk9P6g
	A9h2S6yrwhkJeRQ0wq+KkeP6aXO7ozUS1VFouNslcaJWNnNTWNf6+No5EMJ8JRexDFxR/Wo18qX
	Lm5T9Vef2JtiLhrkJyMnK8JAh5z4RTHLw5kIphH6NyBcDPzfQ0Oprlreb+s36+XcUj51K13t3bZ
	VL1Wi9Z5gUdcjMCVof2f+9ijIUYuWic/+k0pg06OdkwfT74Uk1evLcd/E4p2RiiQQmAO2BZbGCU
	Cd+v6wZvk+mAf1CU8HhY7TCwilIcThzieKfVg01wSnv4XLjMj3ScYzF4o8SeHIckvsVxLi0FiNB
	N7dcLM/38kkXK6HPfuZUe7AnKE74RcOOnlRK1KCgn4ud7f/z11mjXgn4WaKeoLKlfs6UPCI3xM9
	g7lQMS5DMIqevRZ7H1NPl+Pglhx0Df4gHUnFP/hQS/04cMpkeW6/BLsJOjrtz6gn3UgH8KdcPbb
	0/0kgrW1FQMzD38PcL9Qv68lxA=
X-Received: by 2002:a05:6a21:6e92:b0:3c6:61c6:8970 with SMTP id adf61e73a8af0-3cb85df2778mr59898448637.14.1786386611035;
        Mon, 10 Aug 2026 11:30:11 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:5c18:61df:6569:108b])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-14101b7ad29sm36583642c88.13.2026.08.10.11.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 11:30:10 -0700 (PDT)
Date: Mon, 10 Aug 2026 11:30:07 -0700
From: Brian Norris <briannorris@chromium.org>
To: George Valkov <gvalkov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, sashiko-bot@kernel.org,
	andrew@lunn.ch, chunfan.chen@gmail.com, francesco@dolcini.it,
	kees@kernel.org, miriam.rachel.korenblit@intel.com,
	wenst@chromium.org, rafael.beims@toradex.com,
	avraham.stern@intel.com, peddolla.reddy@oss.qualcomm.com,
	error27@gmail.com, s.kerkmann@pengutronix.de,
	gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] wifi: mwifiex: ignore ROM regulatory hint on
 WRT3200ACM/WRT32x
Message-ID: <anoYr9H4KojJv-aZ@google.com>
References: <anWWr80yAcOQaVVS@nxpwireless-Inspiron-14-Plus-7440>
 <20260807182124.41572-1-gvalkov@gmail.com>
 <9cf8e6ee9c4c655e685708bc5660429074b18326.camel@sipsolutions.net>
 <CADOrJmbhdWhqRj_TSKYEgb_TrbJUpkQeYTGDb_93WSDdeaJPpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADOrJmbhdWhqRj_TSKYEgb_TrbJUpkQeYTGDb_93WSDdeaJPpQ@mail.gmail.com>

On Fri, Aug 07, 2026 at 10:49:40PM +0300, George Valkov wrote:
> Hello Johannes, and thank you for your quick reply!
> 
> > You're supposed to always update bindings first, no?
> To me the logical order is to implement the feature in the driver and
> then enable it in each board which needs it. For Linux just WRT3200ACM.
> A separate patch for WRT32x should be sent to OpenWrt.
> 
> Please let me know if I should reverse the order.

Johannes is asking about the binding documentation (.txt or .yaml), not
the .c (driver) or .dts/.dtsi files. You haven't included
"marvell,ignore-regulatory-hint" in any valid binding document, so it's
not a valid property to use in this driver.

See Documentation/devicetree/bindings/net/wireless/marvell,sd8787.yaml
for the correct binding file relevant to this driver.

> Hello Sashiko AI,
> Yes, I intentionally implemented the flag as a root node.
> This way the new device-tree property can be reused for the
> other radios, which use mwlwifi, and also require this fix.
> 
> It would be inefficient and impractical to define a separate
> device-tree property for each radio, where it is actually the
> board that is affected, so it should be a per-board setting.

I'm not sure what you're saying here. Device Tree Blobs are inherently a
per-board object. The question here is simply where within the Device
Tree we want to add a property.

I believe that you're describing problems with the radio, and so you
should add DT properties to the node for the radio(s) in question, not
the root node.

> Also my attempts to use per device nodes or the parent always
> return false so they are not usable.

That seems like something you need to figure out. Just because you found
it difficult doesn't mean we should accept the wrong approach.

IIUC, you're using a PCIe-based WiFi card, and that's enabled in
arch/arm/boot/dts/marvell/armada-385-linksys.dtsi:

&pcie1 {
        /* Marvell 88W8864, 5GHz-only */
        status = "okay";
};

&pcie2 {
        /* Marvell 88W8864, 2GHz-only */
        status = "okay";
};

I think those are the "port" nodes, and there currently is no node that
actually represents the PCIe endpoint device (i.e., your wifi cards).
You need to add those as children, like:

&pcie1 {
...
	wifi@0 {
		compatible = "pciXXXX,YYYY"; /* figure out the appropriate IDs here */
		marvell,ignore-regulatory-hint;
		...
	};
};
...

> I do not understand the part about dependence on CONFIG_OF.
> of_property_read_bool() returns false when the flag is not
> defined. This preserves the original behaviour as if it is
> set to false, so the feature is disabled.
> External radios which do not implement support for this flag
> are not affected.

I think if you stop using 'of_root', you'll dodge this problem. And you
should not be looking at of_root.

> v2 of this PR used of_machine_is_compatible, but there was an
> objection that this adds platform code to the driver.
> 
> How can I add binding documentation and where?

Documentation/devicetree/bindings/net/wireless/marvell,sd8787.yaml. See
the other hints above too.

Side question: did you consider Jeff's suggestion from v2, to try the
'reg_alpha2' module param? It might already do what you need, and it
only requires you configure your OpenWrt builds properly, I think.

Brian

> On Fri, 7 Aug 2026 at 21:39, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > On Fri, 2026-08-07 at 21:21 +0300, Georgi Valkov wrote:
> > >
> > > +                             /* Allow platforms to ignore an incorrect
> > > +                              * regulatory hint from ROM, so userspace
> > > +                              * can set the correct regulatory domain.
> > > +                              */
> > >                               if (country_code &&
> > > +                                 !of_property_read_bool(of_root,
> > > +                                                        "marvell,ignore-regulatory-hint") &&
> > >                                   regulatory_hint(wiphy, country_code))
> >
> > You're supposed to always update bindings first, no?
> >
> > johannes

Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D33F8899
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963428; cv=pass; b=V5FOyVgfkLXbc8IkTBCNg47/mP6cXbFWsGMthClpo4Bx5uh5Dxa8RQK+Kc175qmoT6Ja/F3fTQuGkpB5y6NgUpSSp9q1xMX+XY7gGME+kOPtuwGj6JHHZpzr2Ubq1IJyzlIrVIdIcb7QsenSJTodrCciPx/7GgxHH7nQwDHWwYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963428; c=relaxed/simple;
	bh=mS3Uur/ZQDFMzmjlcJ5SZiJWLd3W4kIodGJs78FCiq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sW37kdaB1uQrJjbGBs3YUUiqKSSfvpPcnPrKEx5xwv5p+rBpqvpifsULhdHcqm+8F9ZU0b+063y3HxAlCIXELvZdJptuqrgr9Fd8myC7owaGk0g6YB4L65DsiRYjN9RrhuAaXSbNlu5t6CP7Go/tUAQBKb3RuyIZFKx6lzUSiPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nOVEbcdp; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nOVEbcdp"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b3119957f0so2908125e87.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:43:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786963424; cv=none;
        d=google.com; s=arc-20260327;
        b=aNI4AleDeLgN0lfCjSSkt+KwruS2J9WkHOQPxRquvqHTSimVr6ms4FFCkx4UG0H60j
         MSgxkdz5UgqtQ4kjecPcaRo4XiH8FO11ABXLT8+oRtFC5pu8wIlt+D8hDqeXhe/Wg3Mv
         V7q35+EHC1d3wBNZj64NwSQd6kUzCs6trnYava3AIHfHq8gOjHH+LPOk+PqV0rNNjpNI
         KeOeK61GYM72KBEQWVkKAecbUCJCQyC5CIbIuHpMtaubBEHWhpIagkonVGH47/qK6zNC
         ZvabdTG4in6zhnxqj2T7H/jZM0sU7rSUYvLwFj0Wc25L6XBRgFpULn1DLEQLO3Wj7l9w
         dliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tfXrwhUEdtSGObkxJ4yfvMMbCGkxVNdt2ypMc+rYzxU=;
        fh=PbP7FCB2LoqLJe6AwRm0IFHqsbca4wXhlBv+rlETTSw=;
        b=DlYigI10eWAfXSVa2+cRAqJAvPdJycxEBhWV/ix9ydxQaYLs0az1BlNyC7eIEPbrTJ
         rOkgxE/jTHLEOFNXlN+LOQAjlliH5txR+CCafGxGvkvhrRM4iWPjm6+OnNRypzBASdkE
         yxusfrsLwxcHF/wKHnfgtWSPhIDdEZ5gXYwNLiJ9GiMulmn8LtWR+6UtOlMpK2Ho5d0e
         KcYNaFzPWW21vjHA47nzzbZt/tzR85y3ZZ10c+CMZRxzrez1A3pOMomVseN/AH1NGxQJ
         tKRVhUwVEXRVU5DFCo8G4ImVcXjr4LuetewKHEF8wtP7FTFBEW0XPMhEf+thD/+ygkVp
         DFUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786963424; x=1787568224; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tfXrwhUEdtSGObkxJ4yfvMMbCGkxVNdt2ypMc+rYzxU=;
        b=nOVEbcdpWCGlhabRUSQOCWqSZZEhKARMRxMMoDsCVztTc9JhkQHgtqc3WYOJHXLh5E
         kcyZ+6+2soma3YD/Ey2zubjV61T6/oXquRK1wghKSKlVpEp+q6dBbp0GCUJ7luAMHhbZ
         wPcNRTY8szAuHomZR9EHBS/0TJ6aEjHE2LwK5pNUTjThJ+qQZA6ZbAlPnqUqzJnOuYaV
         PZNPXLQLqbfgbVdD5Ev/T5ayRhkXxONRQaWXeLk8JmexCTKUSQY1cWBEQxIolpZmAu1o
         zYfM2CUo6ubGFigYhpdise+Wb8YmD/M8QtZkk9+13Nt4mFWfTPUoJ0a95XIc81nKrz7V
         0C7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786963424; x=1787568224;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tfXrwhUEdtSGObkxJ4yfvMMbCGkxVNdt2ypMc+rYzxU=;
        b=GMLhe2GMtO1MAhCXK7YIzocEuzYMl1GSDYHOoUTcA3xOBsc6t0+Zq+DdijjQ8OBxlG
         ZAGlwM3jof5BwWvp1JttRwfqISRDp8uPL+9pN5fCyK8bG9360zBU53gWugGehpT7apAm
         JQIecmO8yWDzEF+1acNhc1rpd24v4TTE9w6yYFRg26II4X0pbF2skRsJjicRyytzv5Ym
         rUTmkEFGP8MNwSphwdJgmxFvYYFsjIgIFo/D351uRHhyjnd/Ez8h5kGzImeD7VByqdjA
         0LuCTmhxDfDr2YbaqD6cByXpRlVdX8hzqbQu+954UDvgseaRN0i10R/JbOZeL+oyXi4k
         shcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rprjb3LeMw1XlBVKup1BT9SimZKRblPZgVDiSUCVtpz88CDzTNeNUgShFmDUCOf2Kp+Mu98MW7iS8Jh5H7tGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkzdBBdGwLKq3Ohb9qvSum7lwQEdd8X7YVTGhDCky8mITUynUR
	8bMTz5g5QZvxye10Z6krBZU4hi6UnioxH+O5OrHzj+Iti1XYe882nqs3xMte8JxMIGU4pRaMS+T
	wBOsfvpCULxpqER9AjSWU7Zelh0+MaIM=
X-Gm-Gg: AR+sD12XHynJnkueccd6FdN3tp6468vXC7xRVc1b3ebWoe2hDD+PW7R8YIkz73GKUwI
	fDk2yLbzOB3P3K1xRtxMWXIZP04xRjuRtdiMcIATgJssdPmeFqbWDFczAt0HoNeWn70skaceAU7
	svjJtKsTP8g0+jxySrWEuo0ppyhjKu7uzGgOKxSv9fIEFaev4grBtgGP5kEKH0CZ6RTlhHglCRh
	ddyxLQhBEaQcQRSncVSp0ycuyXqBdmHVUpEPnkNHIIz1TTRIZWtfVBe6Yd9nzGVissrdoBbbiN5
	viTQl69XXKhHRzhz3t9xfOeHwo/X8A3P6l5yEFEDpVh9WJwOn1lpkPOp83jAtAzGtCLRNxCCQ7V
	lLSIfuhLdwVUUMrjw2NC5snUG
X-Received: by 2002:a05:6512:b94:b0:5b2:a1fe:5e86 with SMTP id
 2adb3069b0e04-5b459139605mr3519047e87.1.1786963424020; Mon, 17 Aug 2026
 03:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <anoYr9H4KojJv-aZ@google.com> <20260814125025.90522-1-gvalkov@gmail.com>
 <20260817-hairy-serval-of-refinement-49039a@quoll>
In-Reply-To: <20260817-hairy-serval-of-refinement-49039a@quoll>
From: George Valkov <gvalkov@gmail.com>
Date: Mon, 17 Aug 2026 13:43:32 +0300
X-Gm-Features: AcwNN1Wb4hk7Y6VXWg-VU6GgBLtF3C0paYqmgk3rIoJzQ18A47YrPXh_NP66Nso
Message-ID: <CADOrJmb3uJPpYR481rB-CnL0A9B_5PQ683XP+Gdis47uihqMBw@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: net: wireless: add flag marvell,ignore-regulatory-hint
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	francesco@dolcini.it, johannes.berg@intel.com, kees@kernel.org, 
	miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, Frank.Li@nxp.com, chunfan.chen@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Aug 2026 at 11:54, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, Aug 14, 2026 at 03:50:23PM +0300, Georgi Valkov wrote:
> > WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> > from the mwifiex ROM, which conflicts with the platform regulatory
> > configuration on units sold outside the US market. For example:
> > - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> > - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> > - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
>
> v1 as reply to v3 in big thread. How tools can parse that?

Hello Krzysztof,
I apologise, I forgot to add the v4 tag to the subject.
I have documented the changes between each revision.
I saw my mistake after sending the mail. But I wasn't sure
what to do? I will make sure to add v5 to my next revision.

> Does b4 diff work?
>
> b4 diff '20260814125025.90522-1-gvalkov@gmail.com'

What is b4?


> > When the system boots, it detects a conflict between the user selected
> > region and the radios, e.g. BG FR US, and applies extreme restrictions,
> > preventing use of 5 GHz and DFS channels. This also affects phy0.
> >
> > Add a device-tree flag, which allows affected platforms to ignore
> > an incorrect regulatory hint from ROM, so userspace can set the
> > correct platform regulatory domain.
> >
> > [1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> > [2] https://github.com/openwrt/openwrt/issues/9956
> >
> > Tested-on: WRT3200ACM, OpenWrt
>
> Not a valid tag, drop.

I believe the tag is helpful because it describes that my changes
have been tested on a certain device and platform. It's a common
practice in OpenWrt contributions. My last two accepted patches
have this tag. Should I still remove it?


> And you cannot even do that, otherwise explain me
> how did your device execute THIS (exactly THIS) code?

I am not used to your terminology and this gets me completely confused.
You have not quoted any particular code change, so I'm not sure what
you are referring to. Here is a summary of the patch series:

Patch 1 documents a new flag: marvell,ignore-regulatory-hint.
Patch 2 adds a device-tree node with the radio and the flag.
Patch 3 skips the regulatory_hint() call when the flag is set.

> > Cc: stable@vger.kernel.org
>
> Drop, what is the bug being fixed here?

Without these patch series:
- all 5 GHz radios are unusable and DFS channels do not work

With the fix applied:
- all 5 GHz radios work correctly, the platform is allowed to use
  the correct regulatory domain for which the device is certified

So this is indeed a bug fix and a very important one too.
I thought the commit description and forum links make this clear enough.
I can send more links if you wish, or just search: WRT3200ACM DFS.
There are endless conversations and many people looking for a fix.

> Anyway, property looks like SW choice. You must describe hardware
> instead.

I am sorry, I do not understand what you want me to do?
Can you please send a diff or a clear description suitable for people
who have way less experience than you?

Georgi Valkov

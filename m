Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564BC37F32B
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 01:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790817957; cv=pass; b=Qvv7wBTyjDZyzn0xtqzokCQbqMLbJMJVjtwp/KS7Uk2OQDurK8Jn999a7UjYAvw6++c8GguVXKSgnk8RVdLr2awEgR/e/mVTv4faTZ8pwNqgGkHfJCfSzbHB8nAyX3AAWsMuFwuO/o7IU71DCTztcnAWJKtDaMnKL6krkEdRBLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790817957; c=relaxed/simple;
	bh=r6ctB+l5Dfn9MACz7F6BggHrrpU6bwM9aCqlAtWjz7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFgBFt6Xwd6FD0Slazlm6wUZyl6I2WigUdeUeWum0vG/mjORH9v2nUM+/FZW8omgrXdIKSJVGk29JhWvTnyx3II9RNXVBcd9+UCE2SiOdmKyfb4c6joDnzHGXUHENhEfIZeKG1942qmv5UMdHXNl1yKFe/CT3OI2Z+VFQKtoM70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/Q+237S; arc=pass smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/Q+237S"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-887ba76d5afso484314b3a.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 18:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790817953; cv=none;
        d=google.com; s=arc-20260327;
        b=Cp1lePdxJOWTqOyXEMngPcms10ylJT6KCBarSU3vdFerZF/WNCWXhhuGbKp9YFKVM/
         hO/FgSACswqHmKUxg2KXN5x4CclJ82DEYvMSx8zkjqd8VFz5LQxyF8viiHhR4GVjEcQ9
         o5IOpDSRKmGzwWY28QSCBrKHKP6lUKLW70O/4XUZmL9SR8Fmbikt9sSPqYB6shZlwtQq
         Mw1yTB7MZ4lCskdsgI1IG/zMch12+AJ4OlBjI+kII5IRZ4hpX5yX2Ez4FpYd1T+6ioOj
         6ILz/UZB0hvUAlYrmVTDkEScCr5FptgNE4AQBRmlpTujZaCxr4m8ZyhoIGcNyiZ7CIlW
         dUsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rFT97ZWRBz3ey/79pcQ9Crf/WiVH/cFfH5FZgLCxjms=;
        fh=BinJ/7R4iYI2XLx1SdPgUo7e5nOaQ/cs8eD7tGsvUZ8=;
        b=Njji5jhqa4+5cGJwyKGUxQPphqorq5YjoB+ASHVK75gbN4q5fONtwxKC4LSnG1BPXI
         1oQv2YQjA7quwHuw2RMHQzesZrYpYcc2RaBNLT2PWzeQbUzhSiYXfbbWjGJ41Nd3M7vv
         TUJtQOKswsHehQoRlf3AuLC6tikfXAwOHrrOHZbYFEZ1KHpCzjdNEh/8jRY7UXJXgMmf
         tqnpi9viFRIcEtWH5YP38Z68qPsvtuoPQTkPvyDlzGN9vaWuWJLjN8HNy4JfMGSKMW6F
         AoAxGY1C22d8kNJVSOHU+DHtdtOqbfgO1AUtZ2skG6ASJhzx3XqxW4q+VGwnpUx/OqGn
         nnTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790817953; x=1791422753; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rFT97ZWRBz3ey/79pcQ9Crf/WiVH/cFfH5FZgLCxjms=;
        b=c/Q+237SYhdPkmYP0tTeXj3muhEKmyxyGItznzkKGywBJ7oJku+J1uGZ4Ouj4ZhYop
         P/ZCgRJZqNzrGaISbV6B9dQPQdxZGZWh/+xD7I/ewNbA5OLIPkgKyRWlGIeFjWI28LuF
         YALYfYntaYDEKyKuxNNoRbvMzURcYxAM4NIVHQ2JiT99JMUcKXwmD8Ur25+Oyq5w3OfN
         DLGuUtM/jK+yfsMeDwzByFSD2/ekCFpqLHsK2hGkYvvIpqzxUc1KvhTExfOT0+NgtJ6O
         gk6eKTqV6NEZ2HXYmqkCIx8T4Lpil5GxdKI8Hga3xjPmJQYxlW6W69JFw+dy+BuvZ8hM
         3Zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790817953; x=1791422753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rFT97ZWRBz3ey/79pcQ9Crf/WiVH/cFfH5FZgLCxjms=;
        b=zFMFw11ryP8xGCY+r7KXGD2kc7CGkBNNkpylwQtELLJVLW3d9Ho17yIxUUS1Daz3zY
         hoSdSHM/4W+6OO51P/JcRadKLZ29XM2R9uTwO/tVt01yJv+6Kl7HMduPfLfbZTsasd9y
         mLJCCz6igcO1IENchHNwwFr7yT5PU0PPkeVAjIUhF7mAbJSK5ZbtF9iJ6ZCg2K2VI3He
         xIiH0guWdwdcHbp4PjzNR+qewfKcBiJ8nOc2vjfg0ZnJ4ysoVMXegpx6QlvkBLynNVVH
         ru9vij1kJlxQjiPA9mJTY2SD00sqR0Z0I7yXPg6ypOSXf4plUo0D9tWeT2OsaiXIwmTw
         aDiQ==
X-Forwarded-Encrypted: i=1; AKwUvByji8aOLXeQIjPvOyxDSZhpdMw6bb2VhScchIHxFEoLqMaaT8GeXLm1Hg+aJ/9Pscu2oOLHkJXF/hDO+E4n5Q==@vger.kernel.org
X-Gm-Message-State: AFuF++mFsPMw00VKcjzUvyuf3eVyyUseYAZE5sJJEQv4L0kiTbMTLxO8
	qHzGmeC+mOV49Ucs4STuh1JQAeiGZlaBzKltowuakq9trn72KldCVVb8ARK7n/NoIZkTo2/Srnu
	jI11FtwWbuUtaCsB7m/Os9swV/5b5NNI=
X-Gm-Gg: AYBFou3ddBsBBLaECugl7vxG5I3/6VYtV8oLMWt4M50D4yjMOMdVDE7vUxKhZfvNLB2
	RrrH+M8kc8PztW9FTXxvfNd6eWdyCaA/5pxIHkazSJUuqGdg4ErXMkYXBokL96MVsenxd8oSPTK
	z2oeeI7cZf8AQANqbt9k7VwtQSFiw0R5KfhHS9nda1qrox6H8nz2PB7McLUUDyg2tAV58fAzrLl
	4xFfBczTHJIV5i1kCfI3V5RdLFImwVROhdbOFs+V+o7HSOv4v9pdub85vTV8k40q3iUUemtXyou
	xUyGyhuturmHVlPOUKD5XGcFsxczu9eKSB4ApXARGcDlN0QyW2Okt4zh
X-Received: by 2002:a05:6a00:2da0:b0:880:5a44:9367 with SMTP id
 d2e1a72fcca58-8874a69ec71mr2480685b3a.30.1790817953484; Wed, 30 Sep 2026
 18:25:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261001003501.2425492-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261001003501.2425492-1-lucid_duck@justthetip.ca>
From: Chris <hoopyfrood42@gmail.com>
Date: Wed, 30 Sep 2026 21:25:41 -0400
X-Gm-Features: AclHuK8_KWE1UfLVbGLDncG3ZFM4xVbCeQcbtCCHGsIVNzIJFDtLu7YJF8SsscU
Message-ID: <CAHaeJsSaqTJZ+Os-fxGq-g=wH7842n3Kt-_hmohdwN8qUwijiQ@mail.gmail.com>
Subject: Re: [PATCH wireless v2] wifi: mt76: move the channel survey when the
 channel changes
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 8:35=E2=80=AFPM Devin Wittmayer
<lucid_duck@justthetip.ca> wrote:
>
> mt7921 and mt7925 report every survey counter against one channel and
> never mark the one in use. Both use channel contexts, so the code that
> moves the survey never runs.
>
> Move it when a context is assigned or changed, after booking the time
> spent on the old channel.
>
> Tested on MT7922 over PCIe, MT7921AU and MT7925 over USB.
>
> Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
> Cc: stable@vger.kernel.org
> Reported-by: Chris <hoopyfrood42@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/CAHaeJsT8O8Nhq351hFp3NAL8e=
0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com/
>
> Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> ---
> v2: aim it at the wireless tree and tag it for stable. No code change.
>
>  drivers/net/wireless/mediatek/mt76/mac80211.c   | 17 +++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76.h       |  2 ++
>  .../net/wireless/mediatek/mt76/mt7921/main.c    |  1 +
>  .../net/wireless/mediatek/mt76/mt7925/main.c    |  2 ++
>  .../net/wireless/mediatek/mt76/mt792x_core.c    |  1 +
>  5 files changed, 23 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/=
wireless/mediatek/mt76/mac80211.c
> index abbe65cbcd89..fdfdb324ab98 100644
> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
> @@ -1045,6 +1045,23 @@ void mt76_update_survey(struct mt76_phy *phy)
>  }
>  EXPORT_SYMBOL_GPL(mt76_update_survey);
>
> +/* For drivers that retune without __mt76_set_channel(): book the time s=
pent
> + * on the old channel before moving the survey to the new one.
> + */
> +void mt76_set_survey_channel(struct mt76_phy *phy,
> +                            struct cfg80211_chan_def *chandef)
> +{
> +       if (!chandef->chan)
> +               return;
> +
> +       mt76_update_survey(phy);
> +
> +       phy->chandef =3D *chandef;
> +       phy->main_chandef =3D *chandef;
> +       phy->chan_state =3D mt76_channel_state(phy, chandef->chan);
> +}
> +EXPORT_SYMBOL_GPL(mt76_set_survey_channel);
> +
>  int __mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *c=
handef,
>                        bool offchannel)
>  {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wire=
less/mediatek/mt76/mt76.h
> index 62b41c8bb7c0..2cbe9884ab46 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -1548,6 +1548,8 @@ void mt76_sta_ps_transition(struct mt76_dev *dev, s=
truct mt76_wcid *wcid,
>  bool mt76_has_tx_pending(struct mt76_phy *phy);
>  int mt76_update_channel(struct mt76_phy *phy);
>  void mt76_update_survey(struct mt76_phy *phy);
> +void mt76_set_survey_channel(struct mt76_phy *phy,
> +                            struct cfg80211_chan_def *chandef);
>  void mt76_update_survey_active_time(struct mt76_phy *phy, ktime_t time);
>  int mt76_get_survey(struct ieee80211_hw *hw, int idx,
>                     struct survey_info *survey);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7921/main.c
> index 68a059504e83..915d6789c668 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
> @@ -1423,6 +1423,7 @@ mt7921_change_chanctx(struct ieee80211_hw *hw,
>         } else {
>                 mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->bss=
_conf.mt76, ctx);
>         }
> +       mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
>         mt792x_mutex_release(phy->dev);
>  }
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7925/main.c
> index 5993b31e1aae..e21bd79dcc56 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> @@ -2063,6 +2063,7 @@ mt7925_change_chanctx(struct ieee80211_hw *hw,
>                                                       link_conf, ctx);
>                 }
>         }
> +       mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
>
>         mt792x_mutex_release(phy->dev);
>  }
> @@ -2399,6 +2400,7 @@ static int mt7925_assign_vif_chanctx(struct ieee802=
11_hw *hw,
>
>         mconf->mt76.ctx =3D ctx;
>         mctx->bss_conf =3D mconf;
> +       mt76_set_survey_channel(mvif->phy->mt76, &ctx->def);
>         mutex_unlock(&dev->mt76.mutex);
>
>         return 0;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/n=
et/wireless/mediatek/mt76/mt792x_core.c
> index 0ad33f74c228..6a0d5b2c2d59 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
> @@ -472,6 +472,7 @@ int mt792x_assign_vif_chanctx(struct ieee80211_hw *hw=
,
>         mutex_lock(&dev->mt76.mutex);
>         mvif->bss_conf.mt76.ctx =3D ctx;
>         mctx->bss_conf =3D &mvif->bss_conf;
> +       mt76_set_survey_channel(&dev->mphy, &ctx->def);
>         mutex_unlock(&dev->mt76.mutex);
>
>         return 0;
> --
> 2.55.0
>

Tested on a Netgear A9000 (MT7925, USB 0846:9072) in monitor mode,
Ubuntu 7.0.0-34 with the patch backported (the mt7921 hunk needed
rebasing for the older brace-less if/else). Before: tuned to 2437 and
then 5180 MHz, every counter stayed on 5955 MHz and no channel was
marked in use. After: each of 2412/2437/2462/5180/5745/5955/6115 MHz
is "[in use]" while tuned, gets its own active time (~4.2 s per 4 s
dwell), keeps it when left and resumes on return.

The busy half of the report is unchanged: busy still grows by 0xADBEEF
=C2=B5s (11,386.6 ms) per update, now on the right channel. So the MIB busy
register read is still returning 0xDEADBEEF on this chip.

Tested-by: Chris hoopyfrood42@gmail.com

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793467127;
	b=xFBeX4jcBo5N+mTkC8OCLxTKJZRLuJ0pYXEx6jhy6nqGe5xWRNaZ5uT8tH8JxPn2Bvjw
	 aDGF3zTMxeJ3PbLfY5qOREjiAvLL37lmt3IHuDjL8AfD0aL96zG739LZgODQbqtd0qDOX
	 WMMHrKAwISeRowaIO/jPx4B+dOTGt6If+2D7Z/raurxc8H7IX0Gtu1mNOhhBmYHwBeqSB
	 9CQuKZFaHs8FlQCprdn4+D6TnmzNOenLMIwiAT06EtZPg1oQAIbircIA/0tO9na/H6YG6
	 qWDi2n44dKiblXr2lKfsINwUOi5k6V0xA6fwy6UttSQUTUw+OhLvNyCVrQWZK0zUuHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793467127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=V2piie36V2DMo2XoNrsEG9/VSdOmBi+2h4XzPx+NDiw=;
	b=LqAq/Ff/314g3+VZaU2bEmE3awbzOd5O+p+P+WoGpAbjs/+XqWFGkudZ4LZu+vNPH1Uv
	 3lAK6ZUhWYWkktw03WSOP5oiEFVfuVbtwldGpb0J8Vrlzy8fx0Pu2wxtzjjY65CURebos
	 MGBPHNBNBIGFDMGfmUa2mlHnLczhJk3wnC37U8wDeBgtlh4o4otVwRBZBKfhwgSfimVrl
	 4FPpj5FDvhjwx9LiTAb9MhW8rPXyYXl/WuKdjexMbqyUT6RmwrEP9wlZFeLRNJzZ4Zdel
	 LqAYk6frH7MVYxlmWTGeU5halGpObbrCCqlQUaAtdjFFq9UP1gYZhzuEUQnfv6V1deg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="WEM/00ce";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB9B606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 17:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CB9B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WEM/00ce
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-48ed188ee81so945280fac.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 10:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793467126; cv=none;
        d=google.com; s=arc-20260327;
        b=F2CeGGfojoAgO1P6nNIAi+frjXvlbKR+qNK1KnIAFZV2cQTEkf5YzijrS0eYCdWSZI
         1yMNkUn9r8CyxhdA9RUQwGv627a2kRhUIIm32XnsCbcb/mAgHGxqJcerBeRPsRWM0923
         pkOI7L3EhWIUgnKjCp4QzKA25QLkWyHQqBgKoyUB7Xoa083HP86EP/xWFcsAZYe3dvuF
         DLBX85oRzt00mrx65VohEWQtUzI9E5HOnNWIMNYuAoEMqE8irx7Iyof88JHFrdFEh9nv
         K6cyv9TfH8tjRYXA4sh2xMFHWxMIKnzVbSqhQrjYtbzp/ZHir+c3HnC084ifi7lrJKef
         g+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=V2piie36V2DMo2XoNrsEG9/VSdOmBi+2h4XzPx+NDiw=;
        fh=FR8kuZaV44hN9gCiuoinQ/l5sScVNUbgN1DgL1u7lwo=;
        b=q7CvWsHEZwkx+1U04Es/tmebW6HwiaBq751V9kQsvQQPsBmvIPeQThl7pmOLOo8A/n
         LscTQTnCB/ng0UZE/6xgUNNNpPXeN9ZxAp+4gKii2WiuXPD9Q7bdvr0KDPKxLUfAeJPJ
         XZTmTqz20vNB+A6MKuQL+mmDw6KNa+vYJHgemFTVlKCHyMSDbulLtvJSVwg3/sjzUua+
         4SyLSFH5LaVoHacX0HHrre6rSQgL+6J6UFfH0yuG+Od2DRkIOcTJzY2opxF5NmmpXe+0
         BcNnH64aZsmoLjlG7V9NLr+6o3EQoWrv58iCSm+mk2Ogkl/CCSr8SoHhwM/XX1IjWrJT
         hHoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793467126; x=1794071926; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V2piie36V2DMo2XoNrsEG9/VSdOmBi+2h4XzPx+NDiw=;
        b=WEM/00cenIgxMYlUq6BxDQ5kLNUmKT98i9hwk33Snqw8H93oRySaMzGjt7jeAwujfy
         8EL19gme2yHaw/XuetF9xVqVVJXc+EjLMytTfOcFXFoCKpnT8HS0aDQVXXtU/QY8YxkY
         KDsnemsHUYDnuNnRkZofC6tUlqKWdICQB4tde8gM7HYGGGi9Gc6/WzkWzhRLMQYlY1//
         OGZjd1H6l0AXeRiX7S4d9DJAIUE3/USy12y8+ymfvPiLFEtN27UgOyqmnoQhemx03DQy
         CsrNIHzk/th30zkW376OMF0rK+KKUjfv3IviVEGu3rE20fS8UPh9yk0LYKOFvV3r45tc
         xMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793467126; x=1794071926;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V2piie36V2DMo2XoNrsEG9/VSdOmBi+2h4XzPx+NDiw=;
        b=geV9B3VrlRVFBLHqzCM95UCZNbTYlDwzizLPUPhMEAT0X4sXtKvn7WhtNvsbe3NTSZ
         owt4xLmP6DUPe5uZclTz+edcxsF/e5YY7fO2fXFuL0PVxZhLSuZ1m8wLv0oSFa0+LAME
         eHRTALwTq3k5/7viMB/bW28U0ftalCoMLKuNb5ovM7r/EaIDqe4ZVeoLV2k+kdL5UwpW
         BmSa6CP68hFZmqCAjUknz5RHmBdtoW5JjOlJ6xjjJtEvxQqVpsz3E7OX4trvrN3ylk2p
         4GQaznBos+YElC4FIpFH/Y5+PW7wsb8dLq71/rN9jpsQ+0N0ATVguhGKtbRRT4BLBxO7
         LCPw==
X-Gm-Message-State: AFq9FYJ6jM15mxNeGHkw0WRFF5AibTM7KfdRrjXodeUaBYmJtcMbWtxT
	XD1lGydUVkyq6Hjhu8tsgj3QeYq24blPqu/TRUK+j9S+sfmKHIMLs5sWNGdzcN7eIieyv7OjZcX
	AC5Dan9PoZdWZYd40aSMpmno8EImTpTM=
X-Gm-Gg: AYBFou2sPpeQ1qP/x9upJTUEJYpETwgoi7/9AzP/m/MHaVQp2QhBCcYSRy7GnsEiE16
	hqt/E2y4o262oi7FWXcdlJbH6mvwb5nEm+nMFhkDau9W1xlMPgq6wmFofgEOLM2asvWFFnWsIHm
	HyZL09+Ho4ADnARgpf/tfAGImt0e8lmnNST7+4yMzyEthceuK9IUcK3ATU5qNTtRE2YFtKVcrIK
	h4YmPOepFRoQgjpKLUp8Y1oa809bPPdlfncRj/Gn15SErZ+uG4wiUQ2TOW/mNSUvMgg+8320wSx
	k+sIPZTll8xOzcl68L4Si8PgtRnzZAOg+qxnJmsX0qXZRKcB60xORWiRKWTpnfTiDPv/zd+y7Bc
	0W/HeMtIg0piDZfnjW/30caeYtOkER5hlsz9Eyhz8d3ZVtwvbkRK6bUZaBvoYPkKaBhaIhA1AK7
	9z8cVOjHYEG9LfWGgz
X-Received: by 2002:a05:6870:b2ea:b0:494:abea:ad80 with SMTP id
 586e51a60fabf-4a9076e545emr3771958fac.28.1793467126055; Sat, 31 Oct 2026
 10:18:46 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029134752.1299130-1-hjf3108@gmail.com> <20261029134752.1299130-7-hjf3108@gmail.com>
 <20261030091743.GB27096@wp.pl> <CABOQOSX6mBCtTTg9eJX665t7tj65jo=9hVTgr7pmFRB6csG2Yg@mail.gmail.com>
 <20261031110608.GD31143@wp.pl>
In-Reply-To: <20261031110608.GD31143@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Sun, 1 Nov 2026 01:18:09 +0800
X-Gm-Features: AclHuK-HDTmWcV6TllrWHm2F-CgUI-guMI-8Lmp9oMlILn3GyDSBiaH_UIZRaCU
Message-ID: <CABOQOSW-4dqo-wfwHcbAK7ECvA+Gc+hKhZjBFckyBRoO0EoB8Q@mail.gmail.com>
Subject: Re: [PATCH wireless-next 6/8] wifi: rt2800: set the mac80211
 fast-xmit and aggregation flags
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 Oct 2026 at 19:06, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Fri, Oct 30, 2026 at 07:33:44PM +0800, Jie Feng wrote:
> > On Fri, 30 Oct 2026 at 17:17, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> > >
> > > On Thu, Oct 29, 2026 at 09:47:47PM +0800, Ho Jie Feng wrote:
> > > > Enable AMSDU TX/RX support for this driver, which can increase
> > > > throughput.
> > > >
> > > > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > > > ---
> > > >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > > index 032cd6ac345f0..8b4458a74d33d 100644
> > > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > > @@ -11861,6 +11861,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> > > >       ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
> > > >       ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> > > >       ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
> > > > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORT_FAST_XMIT);
> > >
> > > IFICT this flag will not take the effect since we have SUPPORTS_PS.
> > > Also for WAP3 (802.11w) we fallback to software encryption -
> > > that will prevent fast xmit as well. To truly enable
> > Yeah, that is true. I also have a patch that enables hwcrypto in that case.
>
> So let's wait until all needed parts will be in tree or posted in the
> same patchset before advertising the support.
>
> > > fast xmit, I think we would need add hardware encryption support for
> > > WPA3 and also compromise by remove Power Save support (which is disabled by
> > > default, so that's possibly fine).
> > I think maybe a more general patch to mac80211 to enable fast-xmit when PS
> > is disabled and not only checking the feature flag will be better?
>
> Sounds like good idea to me, but let check with Johannes (cc-ed).
The patch might go something like this:

Within net/mac80211/tx.c, ieee80211_check_fast_xmit:
        if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
            !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS) &&
-           sdata->vif.type == NL80211_IFTYPE_STATION)
+           sdata->vif.type == NL80211_IFTYPE_STATION &&
Either:
+           sdata->u.mgd.powersave)
or this:
+           local->ps_sdata == sdata)
                goto out;



> > > > +     ieee80211_hw_set(rt2x00dev->hw, TX_AMSDU);
> > > > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
> > Although I think this flag will still be useful for this patch.
>
> AFICT TX_AMSDU require FAST_XMIT. I think we could potentially enable
> RX SUPPORTS_AMSDU_IN_AMPDU as long all buffer sizes setup by the driver
> and configured in registers allow handling big enough frames. Though
> I don't know how much beneficial that would be since we most likely
> can not configure very large (A)MPDU buffers. Need to check.
>
> Regards
> Stanislaw
>
> > > >
> > > >       /*
> > > >        * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> > > > --
> > > > 2.53.0
> > > >

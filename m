Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34871 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbBXKDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:03:41 -0500
Received: by mail-ob0-f179.google.com with SMTP id wp4so42266265obc.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 02:03:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFk-A4nyEvsaCah97ohnbLW7a0+GRbnuJGLyFkBLbpWVffn85w@mail.gmail.com>
References: <CAFk-A4kSa=TznTNdtbWnUMaGWKM=WHYppfdyywagNMYS=VBcmQ@mail.gmail.com>
	<1423016529-4812-1-git-send-email-masashi.honma@gmail.com>
	<1424771171.2192.3.camel@sipsolutions.net>
	<CAFk-A4nyEvsaCah97ohnbLW7a0+GRbnuJGLyFkBLbpWVffn85w@mail.gmail.com>
Date: Tue, 24 Feb 2015 19:03:40 +0900
Message-ID: <CAFk-A4=OJyzuQ04i=c5F2HpX+n8JK6RSbZrNKGU7M6J8EteH8w@mail.gmail.com> (sfid-20150224_110414_234466_CD9F565D)
Subject: Fwd: [PATCH v4] mac80211: Allow 0 for NL80211_MESHCONF_PLINK_TIMEOUT
 to disable STA expiration
From: Masashi Honma <masashi.honma@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will re-send this message to ML because of delivery error.

---------- Forwarded message ----------
From: Masashi Honma <masashi.honma@gmail.com>
Date: 2015-02-24 19:00 GMT+09:00
Subject: Re: [PATCH v4] mac80211: Allow 0 for
NL80211_MESHCONF_PLINK_TIMEOUT to disable STA expiration
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
Bob Copeland <me@bobcopeland.com>


2015-02-24 18:46 GMT+09:00 Johannes Berg <johannes@sipsolutions.net>:
>
> Hi,
>
> Sorry about the late reply! I'm getting back to merging now and taking a
> closer look at this issue.



Thank you for your review.

>
>
> > +++ b/net/wireless/nl80211.c
> > @@ -5261,7 +5261,7 @@ do {                                                                        \
> >       FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
> >                                 0, 65535, mask,
> >                                 NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
> > -     FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 1, 0xffffffff,
> > +     FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 0, 0xffffffff,
> >                                 mask, NL80211_MESHCONF_PLINK_TIMEOUT,
>
> I think you should document this new behaviour also in nl80211.h.


Yes. I will modify and re-send this patch.

>
>
> Additionally - what's the plan on how to discover this? Should userspace
> just try to set with 0 value and then drop back to some big number if it
> gets an error?


I already modified wpa_supplicant by commit
0cb5f8d94536e097af7a11273f79239001a602d6.
The way is same as you. It tries to set with 0, if failed it re-try
with 60sec future of wpa_supplicant timeout value.

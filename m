Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58800 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3DZQH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 12:07:29 -0400
Received: by mail-bk0-f49.google.com with SMTP id w5so1843833bku.22
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 09:07:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00ad01ce3f30$7ba5da10$72f18e30$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local>
 <CAG6hwVN5LRVgchuX7QQWKEioBxTz3WXO5JUVv7fE3_X5LKXayg@mail.gmail.com> <00ad01ce3f30$7ba5da10$72f18e30$@acksys.fr>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 26 Apr 2013 09:07:08 -0700
Message-ID: <CAG6hwVNrPdCtfdA3xDHAAqz=i_GegVReba9HOxYrw0VOgdcP+g@mail.gmail.com> (sfid-20130426_180733_414622_EA9FA6A0)
Subject: Re: Mutli vif in mesh mode
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cedric,

On Mon, Apr 22, 2013 at 1:07 AM, voncken <cedric.voncken@acksys.fr> wrote:
>         Thanks Thomas for your answer,
>
>         In ath9k_hw_beaconinit() the mesh mode use the hadhoc beacon mode. I
> try to change it, and  ath9k_set_beacon in
> driver/net/Wireless/ath/ath9k/beacon.c, but after these modifications, no
> beacon are sent (I think my change are wrong).
>
>         Could you give me the old patch, I can try to update it with the
> latest compat, and I will send to you an updated patch.

Sorry for the late response.

You need to change the hardware operating mode in
ath9k_hw_set_operating_mode() to AP as well. See [1] and please let me
know if that helps.

[1] https://github.com/cozybit/open80211s/commit/380bf3ad4c2ccd92658943e978f8d942611a3d6d

--
Thomas

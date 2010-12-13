Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:60737 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab0LMRaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 12:30:13 -0500
Received: by iwn37 with SMTP id 37so9623616iwn.11
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 09:30:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101213114351.47df9333@gotham.conectiva>
References: <20101213114351.47df9333@gotham.conectiva>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Dec 2010 09:29:52 -0800
Message-ID: <AANLkTinnhSj=50agjC3mVDKF1Z7-rMdZ4oqZvwmitmmE@mail.gmail.com>
Subject: Re: [PATCH] mac80211: avoid calling ieee80211_work_work unconditionally
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 5:43 AM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
> On suspend, there might be usb wireless drivers which wrongly trigger
> the warning in ieee80211_work_work. If an usb driver doesn't have a
> suspend hook, the usb stack will disconnect the device. On disconnect,
> a mac80211 driver calls ieee80211_unregister_hw, which calls dev_close,
> which calls ieee80211_stop, and in the end calls ieee80211_work_purge->
> ieee80211_work_work.
>
> The problem is that this call to ieee80211_work_purge comes after
> mac80211 is suspended, triggering the warning even when we don't have
> work queued in work_list (the expected case when already suspended),
> because it always calls ieee80211_work_work.
>
> So, just call ieee80211_work_work in ieee80211_work_purge if we really
> have to abort work. This addresses the warning reported at
> https://bugzilla.kernel.org/show_bug.cgi?id=24402
>
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Cc: stable@kernel.org ?

  Luis

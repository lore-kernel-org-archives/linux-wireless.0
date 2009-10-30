Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:63159 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbZJ3PCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 11:02:41 -0400
Received: by mail-iw0-f180.google.com with SMTP id 10so2176927iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 08:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256896722.3555.39.camel@johannes.local>
References: <1256896722.3555.39.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Oct 2009 08:02:26 -0700
Message-ID: <43e72e890910300802v25ba6211s4e9302dd1968230e@mail.gmail.com>
Subject: Re: [RFC] mac80211: make ieee80211_find_sta per virtual interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2009 at 2:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Since we have a TODO item to make all station
> management dependent on virtual interfaces, I
> figured I'd start with pushing such a change
> to drivers before more drivers use this kind
> of functionality...
>
> The iwlwifi bits are easy, but I don't know
> what to do about the ath9k bits. Any ideas?

> --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c 2009-10-30 10:54:10.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c      2009-10-30 10:55:48.000000000 +0100
> @@ -282,7 +282,7 @@ static void ath_tx_complete_aggr(struct
>
>        rcu_read_lock();
>
> -       sta = ieee80211_find_sta(sc->hw, hdr->addr1);
> +       sta = ieee80211_find_sta(/*??????*/, hdr->addr1);

Not sure but I just wanted to point out the that the sc->hw above here
was wrong anyway for virtual wiphy support, this should instead
probably look for the aphy with ath_get_virt_hw() as is done with
ath_rx_prepare().

  Luis

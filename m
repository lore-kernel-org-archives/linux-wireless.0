Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0JZCmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 22:42:39 -0400
Received: by qwk3 with SMTP id 3so2105933qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 19:42:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC5A936.7070009@candelatech.com>
References: <1287990961-2619-1-git-send-email-mshajakhan@atheros.com>
	<4CC5A936.7070009@candelatech.com>
Date: Mon, 25 Oct 2010 22:42:37 -0400
Message-ID: <AANLkTimXLX8Am6_7QK2tNSFbr4_MNNYReN-Co26STNnU@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Properly assign boolean types Signed-off-by:
 Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, j@w1.fi,
	Senthilkumar.Balasubramanian@atheros.com,
	Vasanth.Thiagarajan@atheros.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 11:58 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/25/2010 12:16 AM, Mohammed Shafi Shajakhan wrote:
>> -       is_cw40 = sta->ht_cap.cap&  IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>> +       is_cw40 = (sta->ht_cap.cap&  IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
>> +               true : false;
>
> Maybe use:
> is_cw40 = !!(sta->ht_cap.cap&  IEEE80211_HT_CAP_SUP_WIDTH_20_40);
>
> Seems a bit simpler to me...

Agreed, !! is idiomatic.

-- 
Bob Copeland %% www.bobcopeland.com

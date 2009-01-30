Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:46496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZA3RvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 12:51:01 -0500
Received: by fg-out-1718.google.com with SMTP id 16so82888fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 09:50:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090130165026.GD6534@tesla>
References: <1233310386.4161.25.camel@johannes.local>
	 <20090130165026.GD6534@tesla>
Date: Fri, 30 Jan 2009 18:50:58 +0100
Message-ID: <69e28c910901300950m2f74a302y6a0dbfc60b3236ed@mail.gmail.com> (sfid-20090130_185115_906587_2D4A1760)
Subject: Re: [PATCH] mac80211: remove HW_SIGNAL_DB
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bruno Randolf <bruno@thinktube.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 5:50 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Jan 30, 2009 at 02:13:06AM -0800, Johannes Berg wrote:
>> Giving the signal in dB isn't much more useful to userspace
>> than giving the signal in unspecified units. This removes
>> some radiotap information for zd1211 (the only driver using
>> this flag), but it helps a lot for getting cfg80211-based
>> scanning which won't support dB, and zd1211 being dB is a
>> little fishy anyway.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> Cc: Bruno Randolf <bruno@thinktube.com>
>
> We should be able to convert zd1211rw to use dBm anyway, we shall
> release a new "vendor driver" for it which I think has some bits for =
this.
> Just need to get around to it.
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

While you are at it, please also add the ability to disable in-HW
sequence number generation on a per-packet basis. This is required to
allow my proposed IEEE80211_F_TX_NOSEQ radiotap flag to work. (Right
now, even if mac80211's ieee80211_tx_h_sequence is bypassed, injected
packets will still have their sequence numbers overwritten, preventing
proper injection of fragments, and by grepping through the code of
zd1211rw, there appears to be no code to disable HW sequence number
generation. Potentially this might mean that mac80211-generated
sequence numbers also get overwritten by HW-generated ones!)

--G=E1bor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
